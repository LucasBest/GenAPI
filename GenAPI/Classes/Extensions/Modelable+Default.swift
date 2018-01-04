//
//  Modelable+Default.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation
import ObjectDecoder

public typealias DecodableModel = Modelable & Decodable

public extension Modelable where Self:Decodable{
    public static func toModel(from something: Any?) throws -> Self {
        guard let realSomething = something else{
            throw DecodingError.valueNotFound(Self.self, DecodingError.Context.init(codingPath: [], debugDescription: "Nothing to convert."))
        }
        
        let objectDecoder = ObjectDecoder()
        
        return try objectDecoder.decode(self, from: realSomething)
    }
}

extension Array : Modelable{
    public static func toModel(from something: Any?) throws -> Array<Element> {
        var modeledArray = self.init()
        
        if let array = something as? Array<Any> {
            for container in array{
                if let modelableType = Element.self as? Modelable.Type{
                    if let model = try modelableType.toModel(from:container) as? Element{
                        modeledArray.append(model)
                    }
                }
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
