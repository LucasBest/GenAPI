//
//  Modelable.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public enum ModelingError: Error {
    case invalidType
}

public protocol Modelable {
    static func toModel(from something: Any?) throws -> Self
}
