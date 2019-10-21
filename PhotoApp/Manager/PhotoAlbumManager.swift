//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 10.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumManager: NSObject {
    
    var imageArray = [UIImage]()
    var titleArray = [String]()

    var assetArray = [PHAsset]()
    var imageIndex = [Int]()
    
    static let shared = PhotoAlbumManager()
    static let maximumImageSize = PHImageManagerMaximumSize

    
    func fetchAlbums() {
      
        var collectionsAllPhoto: PHFetchResult<PHAssetCollection>
        var collectionsFavorites: PHFetchResult<PHAssetCollection>
        var collectionsUser: PHFetchResult<PHAssetCollection>
 
        collectionsAllPhoto = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

        collectionsFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        collectionsUser = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        

        // get albums
        
        albumTitle(collectionsAllPhoto)
        albumTitle(collectionsFavorites)
        albumTitle(collectionsUser)

    }
    
    func albumTitle(_ type: PHFetchResult<PHAssetCollection>) {
             type.enumerateObjects { (collection, index, _) in
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
            if photoInAlbum.count > 0 {
                self.titleArray.append(collection.localizedTitle!)
            }
        }
    }
    
    func getPhotos(with type: String) {
        
        self.imageArray.removeAll()
        
        var collectionsT: PHFetchResult<PHAssetCollection>!
        
        if type == self.titleArray[0] {
            collectionsT = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            
        } else if type == self.titleArray[1] {
            collectionsT = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        } else {
            collectionsT = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        }

        collectionsT.enumerateObjects { (collection, index, _) in
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
            
            photoInAlbum.enumerateObjects({ (asset, index, _) in
                self.assetArray.append(asset)
                self.imageIndex.append(index)
                
                let imageSize = CGSize(width: 200, height: 200)
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestOptions.deliveryMode = .highQualityFormat
                
                let imageManager = PHImageManager.default()
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, info) in
                    if image != nil {
                        self.imageArray.append(image!)
                    }
                })
            })
        }
    }
}
