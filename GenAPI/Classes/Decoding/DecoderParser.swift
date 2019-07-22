//
//  DecoderParser.swift
//  GenAPI
//
//  Created by Lucas Best on 12/12/17.
//

import Foundation

struct DecoderParser {
    static func decoderForMIMEType(_ mimeType: MIMEType?) -> ObjectDecoder {
        guard let realMimeType = mimeType else {
            return JSONDecoder()
        }

        switch realMimeType.type {
        case .application:
            switch realMimeType.subtype {
            case .json:
                return JSONDecoder()
            default:
                return JSONDecoder()
            }
        case .image:
            return ImageDecoder()
        default:
            return JSONDecoder()
        }
    }
}
