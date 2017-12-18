//
//  Data+FormattingOptions.swift
//  GenAPI
//
//  Created by Lucas Best on 12/14/17.
//

import Foundation

public extension Data{
    public struct FormattingOptions{
        public static var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64
    }
}
