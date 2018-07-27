//
//  Modelable+Default.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation
import ObjectDecoder

public typealias DecodableModel = Modelable & Decodable
public typealias CodableModel = Modelable & Codable

public extension Modelable where Self:Decodable{
    public static func toModel(from something: Any?) throws -> Self {
        guard let realSomething = something else{
            throw DecodingError.valueNotFound(Self.self, DecodingError.Context.init(codingPath: [], debugDescription: "Nothing to convert."))
        }
        
        let objectDecoder = ObjectDecoder()
        objectDecoder.dataDecodingStrategy = Data.FormattingOptions.dataDecodingStrategy
        objectDecoder.dateDecodingStrategy = Date.FormattingOptions.dateDecodingStrategy
        objectDecoder.nonConformingFloatDecodingStrategy = Float.FormattingOptions.nonConformingFloatDecodingStrategy
        
        return try objectDecoder.decode(self, from: realSomething)
    }
}

extension Array : Modelable where Element : Modelable{
    public static func toModel(from something: Any?) throws -> Array<Element> {
        var modeledArray = self.init()
        
        if let array = something as? Array<Any> {
            for container in array{
                let model = try Element.toModel(from:container)
                modeledArray.append(model)
            }
        }
        
        return modeledArray
    }
}

extension URL : Modelable{
    public static func toModel(from something: Any?) throws -> URL {
        guard let urlString = something as? String, let url = URL(string:urlString) else{
            throw ModelingError.invalidType
        }
        
        return url
    }
}
