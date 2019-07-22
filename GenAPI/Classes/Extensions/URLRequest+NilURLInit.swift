//
//  URLRequest+NilURLInit.swift
//  Pods
//
//  Created by Lucas Best on 6/17/19.
//

import Foundation

extension URLRequest {
    init(url: URL?) {
        self.init(url: URL(fileURLWithPath: ""))
        self.url = nil
    }
}
