//
//  APIObject.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public struct APIObjectConfiguration {
    public struct DebugOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let printDeinitialization = DebugOptions(rawValue: 1 << 0)
        public static let printErrorDetails = DebugOptions(rawValue: 1 << 1)
        public static let printDetailedTransaction = DebugOptions(rawValue: 1 << 2)
        public static let printRawDataResponseBody = DebugOptions(rawValue: 1 << 3)
    }

    public struct Global {
        public static var accept: MIMEType?
        public static var debugOptions: DebugOptions = []
        public static var host: URL?
        public static var session: URLSession?

        static fileprivate var overrideDecoders = [MIMEType: ObjectDecoder]()
        static fileprivate var codingErrorType: CodingError.Type?

        public static func setDecoder(_ decoder: ObjectDecoder, forMIMEType mimeType: MIMEType) {
            self.overrideDecoders[mimeType] = decoder
        }

        public static func setCodingErrorType<DecodeErrorType: CodingError>(_ errorType: DecodeErrorType.Type?) {
            self.codingErrorType = errorType
        }
    }
}

public class APIObject<ResponseType: Decodable, ErrorType: Decodable & LocalizedError> {
    public var request = URLRequest(url: nil)

    public var debugOptions: APIObjectConfiguration.DebugOptions = []

    public var responseQueue = DispatchQueue.main
    public var failureQueue = DispatchQueue.main

    public var endPoint: String? {
        get {
            return self.request.url?.path
        }
        set {
            var urlComponents = self.urlComponents()
            urlComponents?.path = newValue ?? ""

            self.request.url = urlComponents?.url
        }
    }

    public var failOnIgnorableError = false

    private let success: (ResponseType) -> ()
    private let failure: (APIError<ErrorType>) -> ()

    private var session: URLSession = URLSession.shared
    private var task: URLSessionTask?

    public init(accept: MIMEType? = APIObjectConfiguration.Global.accept, host: URL? = APIObjectConfiguration.Global.host, session: URLSession? = APIObjectConfiguration.Global.session, success: @escaping(ResponseType) -> (), failure: @escaping(APIError<ErrorType>) -> ()) {
        self.success = success
        self.failure = failure

        if let realHost = host {
            self.request = URLRequest(url: realHost)
        }

        if let realSession = session {
            self.session = realSession
        }

        if let realAccept = accept {
            self.accept(contentType: realAccept)
        }
    }

    deinit {
        if self.allDebugOptions().contains(.printDeinitialization) {
            dump(type(of: self), name: "| Deinit called with request: \(self.request)", indent: 3, maxDepth: 0)
        }
    }

    // MARK: - Public

    public func addQueryItem(_ queryItem: URLQueryItem) {
        var urlComponents = self.urlComponents()

        var queryItems = urlComponents?.queryItems ?? []
        queryItems.append(queryItem)
        urlComponents?.queryItems = queryItems

        self.request.url = urlComponents?.url
    }

    public func addQueryItems(_ queryItems: [URLQueryItem]) {
        var urlComponents = self.urlComponents()

        var allQueryItems = urlComponents?.queryItems ?? []
        allQueryItems.append(contentsOf: queryItems)
        urlComponents?.queryItems = allQueryItems

        self.request.url = urlComponents?.url
    }

    public func send(method: HTTPMethod) {
        self.request.httpMethod = method.rawValue
        self.getData()
    }

    public func accept(contentType: MIMEType) {
        self.request.setValue(contentType.rawValue, forHTTPHeaderField: "Accept")
    }

    public func setContentType(_ contentType: MIMEType) {
        self.request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }

    //https://gist.github.com/HomerJSimpson/80c95f0424b8e9718a40
    public func setFormURLEncodedBody(_ form: [String: String], replaceSpaceWithPlus: Bool = false) {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        if replaceSpaceWithPlus {
            allowedCharacters.insert(" ")
        }

        let formParameters = form.map { (key, value) -> String in
            let percentEncodedValue = value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? value
            return "\(key)=\(replaceSpaceWithPlus ? percentEncodedValue.replacingOccurrences(of: " ", with: "+") : percentEncodedValue)"
        }

        let formString = formParameters.joined(separator: "&")

        self.request.httpBody = formString.data(using: .utf8)
        self.setContentType(MIMEType(.application, .formURLEncoded, ["charset": "utf8"]))
    }

    public func setBody<EncodableType: Encodable>(_ body: EncodableType, withEncoder encoder: ObjectEncoder) throws {
        self.request.httpBody = try encoder.encode(body)
    }

    public func cancel() {
        self.task?.cancel()
    }

    // MARK: - Private

    private func getData() {
        guard self.request.url != nil else {
            self.invokeFailure(APIError(category: .session(APIError<ErrorType>.MissingURLError())))
            return
        }

        self.printDetailedRequestInformationIfOptionIsSet()

        self.task = self.session.dataTask(with: self.request) { (data, response, error) in
            if let realError = error {
                if self.failOnIgnorableError || !realError.canIgnore() {
                    self.printSessionErrorIfOptionIsSet(realError)
                    self.invokeFailure(APIError(category: .session(realError), response: response, rawResponseData: data))
                }
            }
            else {
                self.printDetailedResponseInformationIfOptionIsSet(response)
                self.printDetailedDataInformationIfOptionIsSet(data, response)
                self.processData(data, with: response)
            }
        }
        self.task?.resume()
    }

    private func processData(_ data: Data?, with response: URLResponse?) {
        do {
            let mimeType = MIMEType(response?.mimeType)

            let decoder: ObjectDecoder

            if let realMIMEType = mimeType, let overrideDecoder = APIObjectConfiguration.Global.overrideDecoders[realMIMEType] {
                decoder = overrideDecoder
            }
            else {
                decoder = DecoderParser.decoderForMIMEType(mimeType)
            }

            if self.responseSuccessful(response) {
                let decodedResponse: ResponseType = try self.decodeData(data, withDecoder: decoder)
                self.responseQueue.async {
                    self.success(decodedResponse)
                }
            }
            else {
                let decodedError: ErrorType = try self.decodeData(data, withDecoder: decoder)
                self.invokeFailure(APIError(category: .api(decodedError), response: response, rawResponseData: data))
            }
        }
        catch let error {
            self.printDetailedDecodingErrorInformationIfOptionIsSet(error, data, response)

            let codingError = self.codingErrorFromError(error)
            self.invokeFailure(APIError(category: .coding(codingError), response: response, rawResponseData: data))
        }
    }

    private func decodeData<Type: Decodable>(_ data: Data?, withDecoder decoder: ObjectDecoder) throws -> Type {
        guard let realData = data else {
            switch Type.self {
            case let optionalType as OptionalProtocol.Type:
                return optionalType.nilValue()
            default:
                throw APIError<ErrorType>.NoDataToParseError<Type>()
            }
        }

        return try decoder.decode(Type.self, from: realData)
    }

    private func urlComponents() -> URLComponents? {
        if let realURL = self.request.url {
            return URLComponents(url: realURL, resolvingAgainstBaseURL: true)
        }

        return nil
    }

    private func invokeFailure(_ apiError: APIError<ErrorType>) {
        self.failureQueue.async {
            self.failure(apiError)

            let errorDetails = APIErrorDetails(decodedResponseData: apiError.rawResponseData,
                                               error: apiError.underlyingError,
                                               errorType: ErrorType.self,
                                               request: self.request,
                                               responseType: ResponseType.self,
                                               urlResponse: apiError.response)

            NotificationCenter.default.post(name: .apiObjectError,
                                            object: self,
                                            userInfo: [APIErrorNotificationKey.errorDetails: errorDetails])
        }
    }

    private func codingErrorFromError(_ error: Error) -> CodingError {
        var codingError: CodingError

        if let globalCodingErrorType = APIObjectConfiguration.Global.codingErrorType {
            codingError = globalCodingErrorType.init(underlyingError: error)
        }
        else {
            codingError = DefaultCodingError(underlyingError: error)
        }

        return codingError
    }

    private func responseSuccessful(_ urlResponse: URLResponse?) -> Bool {
        return (urlResponse as? HTTPURLResponse)?.successful() ?? true
    }

    private func allDebugOptions() -> APIObjectConfiguration.DebugOptions {
        return self.debugOptions.union(APIObjectConfiguration.Global.debugOptions)
    }

    private func printSessionErrorIfOptionIsSet(_ error: Error) {
        if  self.allDebugOptions().contains(.printErrorDetails) ||
            self.allDebugOptions().contains(.printDetailedTransaction) {
            dump(error, name: "| Error: Request Failed - Details", indent: 3)
        }
    }

    private func printDetailedRequestInformationIfOptionIsSet() {
        if self.allDebugOptions().contains(.printDetailedTransaction) {
            dump(self.request, name: "| Starting request", indent: 3)
            print("       -------")
            dump(ResponseType.self, name: "Response Type", indent: 5)
            print("       -------")
            if let realHTTPBody = self.request.httpBody {
                if let httpBodyString = String(data: realHTTPBody, encoding: .utf8) {
                    print("       HTTP Body: \(httpBodyString)")
                    print("       -------")
                }
            }
        }
    }

    private func printDetailedResponseInformationIfOptionIsSet(_ response: URLResponse?) {
        let debugName: String

        let responseSuccessful = self.responseSuccessful(response)

        if responseSuccessful {
            debugName = "| Received Response"
        }
        else {
            debugName = "| Received Error Response"
        }

        let allDebugOptions = self.allDebugOptions()

        if (allDebugOptions.contains(.printErrorDetails) && !responseSuccessful) ||
            allDebugOptions.contains(.printDetailedTransaction) {
            dump(response, name: debugName, indent: 3, maxDepth: 0)
        }
    }

    private func printDetailedDataInformationIfOptionIsSet(_ data: Data?, _ response: URLResponse?) {
        let responseFailed = !self.responseSuccessful(response)

        if responseFailed {
            print("Error Body:")
        }

        let allDebugOptions = self.allDebugOptions()

        if (allDebugOptions.contains(.printErrorDetails) && responseFailed) ||
            allDebugOptions.contains(.printDetailedTransaction) {
            print(Utils.bodyStringFromDecodedData(data, urlResponse: response))
        }
    }

    private func printDetailedDecodingErrorInformationIfOptionIsSet(_ error: Error, _ data: Data?, _ response: URLResponse?) {
        if self.allDebugOptions().contains(.printErrorDetails) {
            dump(self.request, name: "| Decoding Error for request", indent: 3, maxDepth: 0)
            print("       -------")
            dump(error, name: "Error", indent: 5)
            print("       -------")
            print(Utils.bodyStringFromDecodedData(data, urlResponse: response))
            print("       -------")
        }
    }
}

public extension APIObject {
    func create() {
        self.send(method: .post)
    }

    func edit() {
        self.send(method: .put)
    }

    func delete() {
        self.send(method: .delete)
    }

    func get() {
        self.send(method: .get)
    }

    func modify() {
        self.send(method: .patch)
    }

    func setJSONBody<EncodableType: Encodable>(_ body: EncodableType) throws {
        self.setContentType(.json)
        try self.setBody(body, withEncoder: JSONEncoder())
    }

    func setFailingJSONBody<EncodableType: Encodable>(_ body: EncodableType) {
        self.setContentType(.json)
        do {
            try self.setBody(body, withEncoder: JSONEncoder())
        }
        catch let error {
            let codingError = self.codingErrorFromError(error)
            self.invokeFailure(APIError<ErrorType>(category: .coding(codingError)))
        }
    }
}
