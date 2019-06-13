//
//  NotificationController.swift
//  GenAPI Watch Extension
//
//  Created by Lucas Best on 6/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
import GenAPI

class NotificationController: WKUserNotificationInterfaceController {

    override init() {
        // Initialize variables here.
        super.init()
        
        let userAPIObject = APIObject<User, DefaultError>(success: {(user) in
            print("From Notification - \(user)")
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

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
}
