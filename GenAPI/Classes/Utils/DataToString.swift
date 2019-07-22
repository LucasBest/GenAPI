//
//  DataToString.swift
//  GenAPI-iOS
//
//  Created by Lucas Best on 7/22/19.
//

import Foundation

internal struct Utils {
    internal static func bodyStringFromDecodedData(_ data: Data?, urlResponse: URLResponse?) -> String {
        var bodyString = String()
        let noDataString = "(No Body Data)"

        if let realDecodedResponseData = data {
            func tryDefaultBodyString() -> String {
                return String(data: realDecodedResponseData, encoding: .utf8) ?? noDataString
            }

            if let mimeTypeString = (urlResponse as? HTTPURLResponse)?.mimeType, let mimeType = MIMEType(rawValue: mimeTypeString) {

                var string: String?

                switch mimeType.type {
                case .text:
                    switch mimeType.subtype {
                    case .html:
                        string = try? NSAttributedString(data: realDecodedResponseData, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                                  .characterEncoding: String.Encoding.utf8.rawValue
                            ], documentAttributes: nil).string
                    default:
                        break
                    }
                default:
                    return tryDefaultBodyString()
                }

                if let responseString = string {
                    return responseString
                }
                else {
                    return tryDefaultBodyString()
                }
            }
            else {
                return tryDefaultBodyString()
            }
        }
        else {
            return noDataString
        }
    }

}
