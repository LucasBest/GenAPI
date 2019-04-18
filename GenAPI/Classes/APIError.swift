//
//  APIError.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public struct APIError<ErrorType: LocalizedError>: LocalizedError {
    public enum Category {
        case session(Error)
        case parse(Error)
        case api(ErrorType)
        case unexpected
    }

    public let category: Category
    public let response: URLResponse?
    public let rawResponseData: Data?

    public init(category: Category, response: URLResponse? = nil, rawResponseData: Data? = nil) {
        self.category = category
        self.response = response
        self.rawResponseData = rawResponseData
    }

    public var errorDescription: String? {
        switch self.category {
        case .session(let error):
            return error.localizedDescription
        case .parse(let error):
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
        case .parse(let error):
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
        case .parse(let error):
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
        case .parse(let error):
            return (error as NSError).helpAnchor
        case .api(let error):
            return error.helpAnchor
        case .unexpected:
            return nil
        }
    }
}
