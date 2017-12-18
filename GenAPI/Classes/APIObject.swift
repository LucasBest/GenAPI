//
//  APIObject.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public struct DebugOptions : OptionSet{
    public let rawValue:Int
    
    public init(rawValue:Int){
        self.rawValue = rawValue
    }
    
    public static let printDeserializedObject = DebugOptions(rawValue:1)
    public static let printDetailedTransaction = DebugOptions(rawValue:2)
}

open class APIObject<ResponseType : Modelable, ErrorType: Modelable>{
    public var request = URLRequest(url: URL(fileURLWithPath: ""))
    
    public var debugOptions:DebugOptions = []
    
    public var responseQueue = DispatchQueue.main
    public var session:Session = DefaultSession()
    
    private var success:(ResponseType) -> ()
    private var failure:(APIError<ErrorType>) -> ()
    
    public init(success:@escaping(ResponseType) -> (), failure:@escaping(APIError<ErrorType>) -> ()){
        self.success = success
        self.failure = failure
        
        self.request.url = nil
    }
    
    // MARK: - Private
    
    private func getData(){
        self.printDetailedRequestInformationIfOptionIsSet()
        
        self.session.data(for: self.request) { (data, response, error) in
            if !self.checkHasError(error, with: response){
                self.printDetailedResponseInformationIfOptionIsSet(response)
                self.printDetailedDataInfromationIfOptionIsSet(data)
                
                self.decodeData(data, with: response)
            }
        }
    }
    
    private func checkHasError(_ error:Error?, with response:URLResponse?) -> Bool{
        if let realError = error{
            if self.debugOptions.contains(.printDetailedTransaction){
                print("     | Error: Request Failed - Details:", realError)
            }
            
            self.responseQueue.async {
                self.failure(APIError.session(response, realError))
            }
            
            return true
        }
        
        return false
    }
    
    private func decodeData(_ data:Data?, with response:URLResponse?){
        do{
            var mimeType:MIMEType? = nil
            
            if let realMIMETypeString = response?.mimeType{
                mimeType = MIMEType(rawValue:realMIMETypeString)
            }
            
            let container = try ObjectRepresentation.forData(data, mimeType: mimeType)
            
            if self.debugOptions.contains(.printDeserializedObject){
                print("Container Object:", container ?? "No Container")
            }
            
            if (response as? HTTPURLResponse)?.successful() ?? true{
                let responseModel = try ResponseType.toModel(from: container)
                
                self.responseQueue.async {
                    self.success(responseModel)
                }
            }
            else{
                let error = try ErrorType.toModel(from: container)
                
                self.responseQueue.async {
                    self.failure(APIError.api(error))
                }
            }
        }
        catch let error{
            self.responseQueue.async {
                self.failure(APIError.parse(error))
            }
        }
    }
    
    private func printDetailedRequestInformationIfOptionIsSet(){
        if self.debugOptions.contains(.printDetailedTransaction){
            var bodyString = "No Body"
            
            if let realHTTPBody = self.request.httpBody{
                if let httpBodyString = String(data:realHTTPBody, encoding:.utf8){
                    bodyString = httpBodyString
                }
            }
            
            print("     | Starting request:", self.request, "...\r          Headers:", self.request.allHTTPHeaderFields ?? "[:]", "\r          Response Type:", String(describing:ResponseType.self), "\r          Body:", bodyString)
        }
    }
    
    private func printDetailedResponseInformationIfOptionIsSet(_ response:URLResponse?){
        if self.debugOptions.contains(.printDetailedTransaction){
            if let realResponse = response{
                print("     | Received Response:", realResponse)
            }
        }
    }
    
    private func printDetailedDataInfromationIfOptionIsSet(_ data:Data?){
        if self.debugOptions.contains(.printDetailedTransaction){
            if let realData = data{
                print(String(data:realData, encoding:.utf8) ?? "(No Data)")
            }
        }
    }
}

public extension APIObject{
    public var baseURL:URL?{
        get{
            return self.request.url?.baseURL
        }
        set{
            var urlComponents = self.urlComponents()
            urlComponents?.host = newValue?.absoluteString
            
            self.request.url = newValue
        }
    }
    
    public var endPoint:String?{
        get{
            return self.request.url?.path
        }
        set{
            var urlComponents = self.urlComponents()
            urlComponents?.path = newValue ?? ""
            
            self.request.url = urlComponents?.url
        }
    }
    
    private func urlComponents() -> URLComponents?{
        if let realURL = self.request.url{
            return URLComponents(url: realURL, resolvingAgainstBaseURL: true)
        }
        
        return nil
    }
}

public extension APIObject{
    public func send(method:HTTPMethod){
        self.request.httpMethod = method.rawValue
        self.getData()
    }
    
    public func create(){
        self.send(method: .post)
    }
    
    public func edit(){
        self.send(method: .put)
    }
    
    public func delete(){
        self.send(method: .delete)
    }
    
    public func get(){
        self.send(method: .get)
    }
    
    public func modify(){
        self.send(method: .patch)
    }
    
    public func accept(contentType:MIMEType){
        self.request.setValue(contentType.rawValue, forHTTPHeaderField: "Accept")
    }
    
    public func setContentType(_ contentType:MIMEType){
        self.request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
    
    public func setJSONBody(_ body:Any){
        self.setContentType(MIMEType(.application, .json))
        self.request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
