//
//  User.swift
//  GenAPI_Example
//
//  Created by Lucas Best on 12/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct User: Decodable {
    struct Company: Decodable {
        var name: String
        var catchPhrase: String
    }

    var id: Int
    var name: String?

    var company: Company?
}
