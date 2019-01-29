//
//  DefaultError.swift
//  GenAPI_Example
//
//  Created by Lucas Best on 12/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import protocol GenAPI.Modelable

struct DefaultError: Modelable, LocalizedError {
    var code: Int?

    static func toModel(from something: Any?) throws -> DefaultError {
        var defaultError = self.init()

        if let dictionary = something as? [String: Any] {
            defaultError.code = (dictionary["code"] as? NSNumber)?.intValue
        }

        return defaultError
    }

    var errorDescription: String? {
        return "An Unknown Error Occured"
    }

    var recoverySuggestion: String? {
        return "Please try again later."
    }
}
