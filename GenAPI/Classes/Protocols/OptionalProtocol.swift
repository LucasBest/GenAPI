//
//  OptionalProtocol.swift
//  Pods
//
//  Created by Lucas Best on 6/16/19.
//

import Foundation

//https://stackoverflow.com/questions/47690210/how-can-you-check-if-a-type-is-optional-in-swift
protocol OptionalProtocol {
    static func nilValue<WrappedType>() -> WrappedType
}

extension Optional: OptionalProtocol {
    static func nilValue<WrappedType>() -> WrappedType {
        return Optional<Wrapped>.none as! WrappedType
    }
}
