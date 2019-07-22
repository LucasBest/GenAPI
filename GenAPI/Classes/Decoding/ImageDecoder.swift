//
//  ImageDecoder.swift
//  Pods
//
//  Created by Lucas Best on 6/17/19.
//

import Foundation

class ImageDecoder: ObjectDecoder {
    private var data: Data?

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        self.data = data
        return try T.init(from: self)
    }
}

private struct DataContainer: SingleValueDecodingContainer {
    var data: Data?

    var codingPath: [CodingKey] = []

    init(_ data: Data?) {
        self.data = data
    }

    func decodeNil() -> Bool {
        return true
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        throw decodingError(type: type)
    }

    func decode(_ type: String.Type) throws -> String {
        throw decodingError(type: type)
    }

    func decode(_ type: Double.Type) throws -> Double {
        throw decodingError(type: type)
    }

    func decode(_ type: Float.Type) throws -> Float {
        throw decodingError(type: type)
    }

    func decode(_ type: Int.Type) throws -> Int {
        throw decodingError(type: type)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        throw decodingError(type: type)
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        throw decodingError(type: type)
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        throw decodingError(type: type)
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        throw decodingError(type: type)
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        throw decodingError(type: type)
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        throw decodingError(type: type)
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        throw decodingError(type: type)
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        throw decodingError(type: type)
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        throw decodingError(type: type)
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard let realData = data, type.self is Data.Type else {
            throw decodingError(type: type)
        }

        return realData as! T
    }

    private func decodingError(type: Any.Type) -> DecodingError {
        return DecodingError.typeMismatch(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot decode type \(type) from Data."))
    }
}

private struct DataUnkeyedContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey]

    var count: Int?

    var isAtEnd: Bool

    var currentIndex: Int

    mutating func decodeNil() throws -> Bool {
        throw decodingError()
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        throw decodingError()
    }

    mutating func decode(_ type: String.Type) throws -> String {
        throw decodingError()
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        throw decodingError()
    }

    func decode(_ type: Float.Type) throws -> Float {
        throw decodingError()
    }

    func decode(_ type: Int.Type) throws -> Int {
        throw decodingError()
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        throw decodingError()
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        throw decodingError()
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        throw decodingError()
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        throw decodingError()
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        throw decodingError()
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        throw decodingError()
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        throw decodingError()
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        throw decodingError()
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        throw decodingError()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        throw decodingError()
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        throw decodingError()
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw decodingError()
    }

    mutating func superDecoder() throws -> Decoder {
        throw decodingError()
    }

    private func decodingError() -> DecodingError {
        return DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Does not support unkeyed containers"))
    }
}

struct KeyedDataContainer<DataKey: CodingKey>: KeyedDecodingContainerProtocol {
    typealias Key = DataKey

    var codingPath: [CodingKey]

    var allKeys: [DataKey]

    func contains(_ key: DataKey) -> Bool {
        return false
    }

    func decodeNil(forKey key: DataKey) throws -> Bool {
         throw decodingError()
    }

    func decode(_ type: Bool.Type, forKey key: DataKey) throws -> Bool {
         throw decodingError()
    }

    func decode(_ type: String.Type, forKey key: DataKey) throws -> String {
         throw decodingError()
    }

    func decode(_ type: Double.Type, forKey key: DataKey) throws -> Double {
         throw decodingError()
    }

    func decode(_ type: Float.Type, forKey key: DataKey) throws -> Float {
         throw decodingError()
    }

    func decode(_ type: Int.Type, forKey key: DataKey) throws -> Int {
         throw decodingError()
    }

    func decode(_ type: Int8.Type, forKey key: DataKey) throws -> Int8 {
         throw decodingError()
    }

    func decode(_ type: Int16.Type, forKey key: DataKey) throws -> Int16 {
         throw decodingError()
    }

    func decode(_ type: Int32.Type, forKey key: DataKey) throws -> Int32 {
         throw decodingError()
    }

    func decode(_ type: Int64.Type, forKey key: DataKey) throws -> Int64 {
         throw decodingError()
    }

    func decode(_ type: UInt.Type, forKey key: DataKey) throws -> UInt {
         throw decodingError()
    }

    func decode(_ type: UInt8.Type, forKey key: DataKey) throws -> UInt8 {
         throw decodingError()
    }

    func decode(_ type: UInt16.Type, forKey key: DataKey) throws -> UInt16 {
         throw decodingError()
    }

    func decode(_ type: UInt32.Type, forKey key: DataKey) throws -> UInt32 {
         throw decodingError()
    }

    func decode(_ type: UInt64.Type, forKey key: DataKey) throws -> UInt64 {
         throw decodingError()
    }

    func decode<T>(_ type: T.Type, forKey key: DataKey) throws -> T where T: Decodable {
         throw decodingError()
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: DataKey) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
         throw decodingError()
    }

    func nestedUnkeyedContainer(forKey key: DataKey) throws -> UnkeyedDecodingContainer {
         throw decodingError()
    }

    func superDecoder() throws -> Decoder {
         throw decodingError()
    }

    func superDecoder(forKey key: DataKey) throws -> Decoder {
         throw decodingError()
    }

    private func decodingError() -> DecodingError {
        return DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Does not support unkeyed containers"))
    }
}

extension ImageDecoder: Decoder {
    var codingPath: [CodingKey] {
        return []
    }

    var userInfo: [CodingUserInfoKey: Any] {
        return [:]
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return KeyedDecodingContainer<Key>(KeyedDataContainer<Key>(codingPath: [], allKeys: []))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return DataUnkeyedContainer(codingPath: [], count: 0, isAtEnd: true, currentIndex: 0)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return DataContainer(self.data)
    }
}
