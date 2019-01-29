//
//  DefaultSession.swift
//  Alamofire
//
//  Created by Lucas Best on 12/7/17.
//

import Foundation

struct DefaultSession: Session {
    func data(for request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }

    func download(request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: request, completionHandler: completionHandler)
        downloadTask.resume()
    }

    func uploadData(_ data: Data, for request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let uploadTask = URLSession.shared.uploadTask(with: request, from: data, completionHandler: completionHandler)
        uploadTask.resume()
    }

    func uploadFile(at url: URL, for request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let uploadTask = URLSession.shared.uploadTask(with: request, fromFile: url, completionHandler: completionHandler)
        uploadTask.resume()
    }
}
