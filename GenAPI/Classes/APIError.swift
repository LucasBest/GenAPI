//
//  APIError.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public enum APIError<ErrorType : LocalizedError> : LocalizedError{
    case session(URLResponse?, Error)
    case parse(Error)
    case api(ErrorType)
    case unexpected
    
    public var errorDescription: String?{
        switch self {
        case .session(_, let error):
            return error.localizedDescription
        case .parse(let error):
            return error.localizedDescription
        case .api(let error):
            return error.errorDescription
        case .unexpected:
            return nil
        }
    }
    
    public var failureReason: String?{
        switch self {
        case .session(_, let error):
            return (error as NSError).localizedFailureReason
        case .parse(let error):
            return (error as NSError).localizedFailureReason
        case .api(let error):
            return error.failureReason
        case .unexpected:
            return nil
        }
    }
    
    public var recoverySuggestion: String?{
        switch self {
        case .session(_, let error):
            return (error as NSError).localizedRecoverySuggestion
        case .parse(let error):
            return (error as NSError).localizedRecoverySuggestion
        case .api(let error):
            return error.recoverySuggestion
        case .unexpected:
            return nil
        }
    }
    
    public var helpAnchor: String?{
        switch self {
        case .session(_, let error):
            return (error as NSError).helpAnchor
        case .parse(let error):
            return (error as NSError).helpAnchor
        case .api(let error):
            return error.helpAnchor
        case .unexpected:
            return nil
        }
    }
}
