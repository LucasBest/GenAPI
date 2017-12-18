//
//  UIImage+Modelable.swift
//  GenAPI
//
//  Created by Lucas Best on 12/14/17.
//

import UIKit

extension UIImage : Modelable{
    public static func toModel(from something: Any?) throws -> Self {
        guard let data = something as? Data, let image = self.init(data:data) else{
            throw ModelingError.invalidType
        }
        
        return image
    }
}
