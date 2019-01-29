//
//  HTTPMethod.swift
//  GenAPI
//
//  Created by Lucas Best on 12/7/17.
//

import Foundation

/*
 Source: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods
 */

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}
