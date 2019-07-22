//
//  ObjectDecoder.swift
//  Pods
//
//  Created by Lucas Best on 6/16/19.
//

import Foundation

public protocol ObjectDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: ObjectDecoder {}
extension PropertyListDecoder: ObjectDecoder {}
