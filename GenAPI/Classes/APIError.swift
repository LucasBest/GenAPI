//
//  APIError.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public enum APIError<ErrorType> : Error{
    case session(URLResponse?, Error)
    case parse(Error)
    case api(ErrorType)
    case unexpected
}
