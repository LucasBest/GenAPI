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

        let imageAPIObject = APIObject<UIImage, DefaultError>(success: { (image) in
            self.imageView.image = image
        }, failure: { (_) in })

        imageAPIObject.request.url = URL(string: "https://vignette.wikia.nocookie.net/leonhartimvu/images/2/24/222_Corsola_Shiny.png")

        imageAPIObject.get()

        let userAPIObject = APIObject<User, DefaultError>(success: {(user) in
            print(user)
        }, failure: { (_) in })

        userAPIObject.baseURL = URL(string: "https://jsonplaceholder.typicode.com")
        userAPIObject.endPoint = "/users/1"

        userAPIObject.addQueryItem(URLQueryItem(name: "test1", value: "query1"))
        userAPIObject.addQueryItems([URLQueryItem(name: "test2", value: "query2"), URLQueryItem(name: "test3", value: "query3")])

        userAPIObject.debugOptions = .printDetailedTransaction

        userAPIObject.get()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
