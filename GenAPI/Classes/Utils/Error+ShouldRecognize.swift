//
//  Error+ShouldRecognize.swift
//  Pods
//
//  Created by Lucas Best on 7/28/19.
//

import Foundation

extension Error {
    func canIgnore() -> Bool {
        // `NSError` code -999 is returned when the request is cancelled. Currently GenAPI defines this as an ignorable error.
        return (self as NSError).code == -999
    }
}
