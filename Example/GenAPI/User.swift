//
//  User.swift
//  GenAPI_Example
//
//  Created by Lucas Best on 12/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import GenAPI

struct User: DecodableModel {
    struct Company: DecodableModel {
        var name: String
        var catchPhrase: String
    }

    var id: Int
    var name: String?

    var company: Company?
}
