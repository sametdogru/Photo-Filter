//
//  FilterModel.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 24.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import Foundation

class FilterModel {
    var name: String
    var filter: String
    
    init(name:String, filter:String) {
        self.name = name
        self.filter = filter
    }
}
