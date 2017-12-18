//
//  TestMIMEType.swift
//  GenAPI_Tests
//
//  Created by Lucas Best on 12/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import struct GenAPI.MIMEType

class TestMIMEType: XCTestCase {
    
    func testApplicationJSON() {
        let mimeTypeString = "application/json"
        
        let mimeType = MIMEType(rawValue:mimeTypeString)
        
        XCTAssert(mimeType?.type == .application, "MIMEType.type is \(mimeType?.type.rawValue ?? "nil")")
        XCTAssert(mimeType?.subtype == .json, "MIMEType.subtype is \(mimeType?.subtype.rawValue ?? "nil")")
    }
    
    func testTextHTMLWithCharSet() {
        let mimeTypeString = "text/html; charset=utf8"
        
        let mimeType = MIMEType(rawValue:mimeTypeString)
        
        XCTAssert(mimeType?.type == .text, "MIMEType.type is \(mimeType?.type.rawValue ?? "nil")")
        XCTAssert(mimeType?.subtype == .html, "MIMEType.subtype is \(mimeType?.subtype.rawValue ?? "nil")")
        
        if let parameters = mimeType?.parameters{
            XCTAssert(parameters == ["charset" : "utf8"], "MIMEType.parameters are \(parameters)")
        }
        else{
            XCTAssert(false, "MIMEType is nil")
        }
        
    }
    
    func testTextHTMLWithCharSetWithCrazyWhiteSpace() {
        let mimeTypeString = "text/html;       charset  =  utf8    "
        
        let mimeType = MIMEType(rawValue:mimeTypeString)
        
        XCTAssert(mimeType?.type == .text, "MIMEType.type is \(mimeType?.type.rawValue ?? "nil")")
        XCTAssert(mimeType?.subtype == .html, "MIMEType.subtype is \(mimeType?.subtype.rawValue ?? "nil")")
        
        if let parameters = mimeType?.parameters{
            XCTAssert(parameters == ["charset" : "utf8"], "MIMEType.parameters are \(parameters)")
        }
        else{
            XCTAssert(false, "MIMEType is nil")
        }
        
    }
}
