//
//  NSDate+FormattingOptions.swift
//  GenAPI
//
//  Created by Lucas Best on 12/14/17.
//

import Foundation

public extension Date{
    struct FormattingOptions{
        public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    }
}
