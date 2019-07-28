//
//  ViewController.swift
//  GenAPI
//
//  Created by Lucas Best on 12/06/2017.
//  Copyright (c) 2017 Lucas Best. All rights reserved.
//

import UIKit
import GenAPI

class ViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .apiObjectError, object: nil, queue: .main) { (notification) in
            if let apiErrorDetails = notification.userInfo?[APIErrorNotificationKey.errorDetails] as? APIErrorDetails {
                print("Recieved error from notification center: \(apiErrorDetails)")
            }
        }

        let imageAPIObject = APIObject<ImageContainer, DefaultError>(host: URL(string: "https://vignette.wikia.nocookie.net/leonhartimvu/images/2/24/222_Corsola_Shiny.png"), success: { (container) in
            self.imageView.image = container.image
        }, failure: { (_) in })

        imageAPIObject.get()

        let userAPIObject = APIObject<User, DefaultError>(host: URL(string: "https://jsonplaceholder.typicode.com"), success: {(user) in
            print(user)
        }, failure: { (_) in })

        userAPIObject.endPoint = "/users/1"

        userAPIObject.addQueryItem(URLQueryItem(name: "test1", value: "query1"))
        userAPIObject.addQueryItems([URLQueryItem(name: "test2", value: "query2"), URLQueryItem(name: "test3", value: "query3")])

        userAPIObject.debugOptions = .printDetailedTransaction

        userAPIObject.get()

        let errorAPIObject = APIObject<User, DefaultError>(host: URL(string: "https://google.com"), success: {(user) in
           // This closure won't be called because of the error.
        }, failure: { (apiError) in
            print("Recieved error in callback: \(apiError)")
        })

        errorAPIObject.debugOptions = .printErrorDetails

        errorAPIObject.get()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
