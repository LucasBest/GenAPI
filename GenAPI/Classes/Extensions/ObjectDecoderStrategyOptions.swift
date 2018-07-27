//
//  Data+FormattingOptions.swift
//  GenAPI
//
//  Created by Lucas Best on 12/14/17.
//

import Foundation
import ObjectDecoder

internal extension Data{
    struct FormattingOptions{
        static var dataDecodingStrategy: DataDecodingStrategy = .base64
    }
}

internal extension Date{
    struct FormattingOptions{
        static var dateDecodingStrategy: DateDecodingStrategy = .deferredToDate
    }
}

internal extension Float{
    struct FormattingOptions{
        static var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw
    }
}

