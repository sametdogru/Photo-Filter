//
//  FilterModel.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 24.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import Foundation
import UIKit

class FilterModel {
    var name: String
    var filter: String
    var image: UIImage

    init(name: String, filter: String, image: UIImage) {
        self.name = name
        self.filter = filter
        self.image = image
    }
}
