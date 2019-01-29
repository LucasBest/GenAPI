//
//  ObjectRepresentation.swift
//  GenAPI
//
//  Created by Lucas Best on 12/12/17.
//

import Foundation

struct ObjectRepresentation {
    static func forData(_ data: Data?, mimeType: MIMEType?) throws -> Any? {
        guard let realMimeType = mimeType else {
            return try self.jsonObjectWithData(data)
        }

        switch realMimeType.type {
        case .application:
            switch realMimeType.subtype {
            case .json:
                return try self.jsonObjectWithData(data)
            default:
                return try self.jsonObjectWithData(data)
            }
        case .image:
            return data
        default:
            return try self.jsonObjectWithData(data)
        }
    }

    private static func jsonObjectWithData(_ data: Data?) throws -> Any? {
        guard let realData = data else {
            return nil
        }

        return try JSONSerialization.jsonObject(with: realData, options: [])
    }
}
