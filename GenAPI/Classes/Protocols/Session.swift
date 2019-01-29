//
//  Session.swift
//  Alamofire
//
//  Created by Lucas Best on 12/7/17.
//

import Foundation

public protocol Session {
    func data(for request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void)
    func download(request: URLRequest, completionHandler: @escaping(URL?, URLResponse?, Error?) -> Void)

    func uploadData(_ data: Data, for request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void)
    func uploadFile(at url: URL, for request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void)
}
