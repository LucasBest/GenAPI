//
//  APIError.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public extension Notification.Name {
    static let apiObjectError = Notification.Name.init("com.GenAPI.apiObjectError")
}

public struct APIErrorDetails: CustomDebugStringConvertible {
    public let decodedResponseData: Data?
    public let error: Error
    public let errorType: Any.Type
    public let request: URLRequest
    public let responseType: Any.Type
    public let urlResponse: URLResponse?

    public var debugDescription: String {
        var debugString = "\(type(of: self)): \r   Error: \(self.error)\r   ---\r   ResponseType: \(self.responseType)\r   ---\r   ErrorType: \(self.errorType)\r   ---\r   Request: \(self.request)\r"

        if let realResponse = self.urlResponse {
            debugString.append("   ---\r   Response: \(realResponse)\r")
        }

        let bodyString = Utils.bodyStringFromDecodedData(self.decodedResponseData, urlResponse: self.urlResponse)
        debugString.append("   ---\r   Body: \(bodyString)")

        return debugString
    }
}

public enum APIErrorNotificationKey: String {
    case errorDetails = "com.GenAPI.APIErrorNotificationKey.errorDetails"
}

public protocol CodingError: LocalizedError {
    var underlyingError: Error { get set }
    init(underlyingError: Error)
}

struct DefaultCodingError: CodingError {
    var underlyingError: Error
}

public struct APIError<ErrorType: LocalizedError>: LocalizedError, CustomDebugStringConvertible {
    public enum Category {
        case session(Error)
        case coding(CodingError)
        case api(ErrorType)
        case unexpected
    }

    public struct NoDataToParseError<ParseType>: Error {
        public var errorDescription: String? {
            return "Could not parse \(ParseType.self)."
        }

        public var failureReason: String? {
            return "No data provided."
        }

        public var recoverySuggestion: String? {
            return "Must provide data to parse \(ParseType.self)."
        }
    }

    public struct MissingURLError: Error {
        public var errorDescription: String? {
            return "No URL included in request."
        }

        public var failureReason: String? {
            return "No URL included in request."
        }

        public var recoverySuggestion: String? {
            return "Please add a URL before submitting the request."
        }
    }

    public let category: Category
    public let response: URLResponse?
    public let rawResponseData: Data?

    public var debugDescription: String {
        var debugString = "\(type(of: self)): \r   Underlying Error: \(self.underlyingError)\r"

        if let realResponse = self.response {
            debugString.append("   ---\r   Response: \(realResponse)\r")
        }

        let bodyString = Utils.bodyStringFromDecodedData(self.rawResponseData, urlResponse: self.response)
        debugString.append("   ---\r   Body: \(bodyString)")

        return debugString
    }

    public init(category: Category, response: URLResponse? = nil, rawResponseData: Data? = nil) {
        self.category = category
        self.response = response
        self.rawResponseData = rawResponseData
    }

    public var underlyingError: Error {
        switch self.category {
        case .session(let error):
            return error
        case .coding(let codingError):
            return codingError.underlyingError
        case .api(let error):
            return error
        case .unexpected:
            return self
        }
    }

    public var errorDescription: String? {
        switch self.category {
        case .session(let error):
            return error.localizedDescription
        case .coding(let error):
            return error.localizedDescription
        case .api(let error):
            return error.errorDescription
        case .unexpected:
            return nil
        }
    }

    public var failureReason: String? {
        switch self.category {
        case .session(let error):
            return (error as NSError).localizedFailureReason
        case .coding(let error):
            return (error as NSError).localizedFailureReason
        case .api(let error):
            return error.failureReason
        case .unexpected:
            return nil
        }
    }

    public var recoverySuggestion: String? {
        switch self.category {
        case .session(let error):
            return (error as NSError).localizedRecoverySuggestion
        case .coding(let error):
            return (error as NSError).localizedRecoverySuggestion
        case .api(let error):
            return error.recoverySuggestion
        case .unexpected:
            return nil
        }
    }

    public var helpAnchor: String? {
        switch self.category {
        case .session(let error):
            return (error as NSError).helpAnchor
        case .coding(let error):
            return (error as NSError).helpAnchor
        case .api(let error):
            return error.helpAnchor
        case .unexpected:
            return nil
        }
    }
}
