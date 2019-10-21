//
//  FilterCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 19.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageFilter: UIImageView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var nameView: UIView!
    
    func configure(with item: UIImage, name: String) {
        imageFilter.image = item
        filterName.text = name
        nameView.isHidden = true
    }
    
}
