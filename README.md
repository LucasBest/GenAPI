# GenAPI

[![Version](https://img.shields.io/cocoapods/v/GenAPI.svg?style=flat)](http://cocoapods.org/pods/GenAPI)
[![License](https://img.shields.io/cocoapods/l/GenAPI.svg?style=flat)](http://cocoapods.org/pods/GenAPI)
[![Platform](https://img.shields.io/cocoapods/p/GenAPI.svg?style=flat)](http://cocoapods.org/pods/GenAPI)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

GenAPI utilizes Swift generics for you to easily define the return types of your API calls.

```swift
let userAPIObject = APIObject<User, DefaultError>(success: { (user) in
    print(user)
}, failure:{ (apiError) in

})

userAPIObject.baseURL = URL(string:"https://jsonplaceholder.typicode.com")
userAPIObject.endPoint = "/users/1"

userAPIObject.debugOptions = .printDetailedTransaction

userAPIObject.get()
```

All that is required is that your return types conform to the protocol `Modelable`. However if you already have your models conforming to Apple's new `Decodable` protocol, all you have to do is change the conformance from `Decodable`  to `DecodableModel` and your models will be ready to use with GenAPI.

```swift
struct User : DecodableModel{
    struct Company : DecodableModel{
        var name:String
        var catchPhrase:String
    }

    var id:Int
    var name:String?
    var company:Company?
}
```

The  `APIError` enum breaks down any error that occurs into 1 of 3 different possibilities:

- a session error
- a parsing error
- or an API error

A session error is returned if there is an error with the `Session`.<br>
A parsing error is returned if an error is thrown when trying to decode either the Response type OR the Error type. (The parse error is most commonly a  `DecodingError`.)<br>
An API error is returned if the HTTP status code of the response is determined to be outside of the success range.<br>

The `APIObject` class has many convenience functions to easily manipulate the underlying `URLRequest`, but the request is also publicly available in case you need to do any custom configuration. Simply access with  `APIObject.request`.

## Installation

GenAPI is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GenAPI'
```

## Author

Lucas Best, lucas.best.5@gmail.com

## License

GenAPI is available under the MIT license. See the LICENSE file for more info.
