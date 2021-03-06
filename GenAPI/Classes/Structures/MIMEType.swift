//
//  MIMEType.swift
//  GenAPI
//
//  Created by Lucas Best on 12/7/17.
//

import Foundation

/*
 Source: https://en.wikipedia.org/wiki/Media_type
 */

public enum Type: String {
    case application
    case audio
    case font
    case image
    case text
    case video
}

public enum Subtype: String {
    case css
    case formURLEncoded = "x-www-form-urlencoded"
    case html
    case javascript
    case jpeg
    case jpg
    case json
    case otf
    case pdf
    case png
    case tiff
    case xml
}

public struct MIMEType: RawRepresentable, Hashable {
    public var rawValue: String

    public let type: Type
    public let subtype: Subtype

    public let parameters: [String: String]

    public init?(rawValue: String) {
        self.rawValue = rawValue

        let dividedStrings = rawValue.components(separatedBy: "/")

        guard dividedStrings.count > 1 else {
            return nil
        }

        let typeString = dividedStrings[0]
        let remainingString = dividedStrings[1]

        guard let type = Type(rawValue: typeString) else {
            return nil
        }
        self.type = type

        let subtypeAndParameters = remainingString.components(separatedBy: ";")

        guard subtypeAndParameters.count > 0 else {
            return nil
        }

        let subtypeString = subtypeAndParameters[0]

        guard let subtype = Subtype(rawValue: subtypeString) else {
            return nil
        }

        self.subtype = subtype

        if subtypeAndParameters.count > 1 {
            let allParameterCombinations = subtypeAndParameters[1].components(separatedBy: ",")

            var parameters = [String: String]()

            for parameterCombination in allParameterCombinations {
                let keyValue = parameterCombination.components(separatedBy: "=")

                if keyValue.count > 1 {
                    let key = keyValue[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = keyValue[1].trimmingCharacters(in: .whitespacesAndNewlines)

                    parameters[key] = value
                }
            }

            self.parameters = parameters
        }
        else {
            self.parameters = [:]
        }
    }

    public init?(_ responseMIMETypeString: String?) {
        guard let realString = responseMIMETypeString else {
            return nil
        }

        self.init(rawValue: realString)
    }

    public init(_ type: Type, _ subtype: Subtype, _ parameters: [String: String] = [:]) {
        self.type = type
        self.subtype = subtype
        self.parameters = parameters

        var rawValue = "\(self.type.rawValue)/\(self.subtype.rawValue)"

        if parameters.count > 0 {
            rawValue.append("; \(MIMEType.parameterString(from: parameters))")
        }

        self.rawValue = rawValue
    }

    // MARK: - Private

    private static func parameterString(from parameters: [String: String]) -> String {
        var parameterString: String = ""

        for (key, value) in parameters {
            parameterString.append("\(key)=\(value)")
            parameterString.append(" ")
        }

        //Remove last space
        return String(parameterString.dropLast())
    }
}

public extension MIMEType {
    static let json = MIMEType(.application, .json)
}
