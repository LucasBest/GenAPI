//
//  DefaultError.swift
//  GenAPI_Example
//
//  Created by Lucas Best on 12/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct DefaultError: Decodable, LocalizedError {
    var code: Int?

    var errorDescription: String? {
        return "An Unknown Error Occured"
    }

    var recoverySuggestion: String? {
        return "Please try again later."
    }
}
