//
//  ImageContainer.swift
//  Pods
//
//  Created by Lucas Best on 6/17/19.
//

import UIKit

extension KeyedDecodingContainer {
    func decode(_ type: UIImage.Type, forKey key: KeyedDecodingContainer.Key) throws -> UIImage {
        let imageData = try self.decode(Data.self, forKey: key)

        if let image = UIImage(data: imageData) {
            return image
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Could not convert UIImage from Data."))
        }
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: UIImage.Type) throws -> UIImage {
        let imageData = try self.decode(Data.self)

        if let image = UIImage(data: imageData) {
            return image
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Could not convert UIImage from Data."))
        }
    }
}

public struct ImageContainer: Decodable {
    public var image: UIImage

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let data = try container.decode(Data.self)

        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Could not convert UIImage from Data."))
        }

        self.image = image
    }
}
