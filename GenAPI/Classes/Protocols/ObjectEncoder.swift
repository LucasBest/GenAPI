//
//  ObjectEncoder.swift
//  GenAPI-iOS
//
//  Created by Lucas Best on 6/16/19.
//

import Foundation

public protocol ObjectEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: ObjectEncoder {}
extension PropertyListEncoder: ObjectEncoder {}
