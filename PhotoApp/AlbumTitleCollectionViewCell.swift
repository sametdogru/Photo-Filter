//
//  AlbumTitleCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 11.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit
import Photos


class AlbumTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    func configure(with item: String) {
        albumTitle.text = item
        titleView.layer.cornerRadius = 2
        albumTitle.textColor = .lightGray
        titleView.isHidden = true
    }
}







