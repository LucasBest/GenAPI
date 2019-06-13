//
//  InterfaceController.swift
//  GenAPI Watch Extension
//
//  Created by Lucas Best on 6/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation
import GenAPI

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let userAPIObject = APIObject<User, DefaultError>(success: {(user) in
            print("From Interface - \(user)")
        }, failure: { (_) in })

        userAPIObject.baseURL = URL(string: "https://jsonplaceholder.typicode.com")
        userAPIObject.endPoint = "/users/1"

        userAPIObject.addQueryItem(URLQueryItem(name: "test1", value: "query1"))
        userAPIObject.addQueryItems([URLQueryItem(name: "test2", value: "query2"), URLQueryItem(name: "test3", value: "query3")])

        userAPIObject.debugOptions = .printDetailedTransaction

        userAPIObject.get()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
