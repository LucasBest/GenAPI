//
//  HTTPURLResponse+SuccessfulStatus.swift
//  GenAPI
//
//  Created by Lucas Best on 12/5/17.
//

import Foundation

public extension HTTPURLResponse {
    func successful() -> Bool {
        return self.statusCode >= 200 && self.statusCode < 400
    }
}
