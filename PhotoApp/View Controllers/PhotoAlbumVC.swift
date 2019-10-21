//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 10.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var secondPhotoView: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var albumTitleCollectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        setUI()
    }
    
    func setUI() {
        photoView.layer.cornerRadius = 20
        photoCollectionView.layer.cornerRadius = 25
    }
    
    func fetchPhotos() {
        PhotoAlbumManager.shared.fetchAlbums()
        PhotoAlbumManager.shared.getPhotos(with: PhotoAlbumManager.shared.titleArray[0])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == photoCollectionView) {
            return PhotoAlbumManager.shared.imageArray.count
        }
        return PhotoAlbumManager.shared.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! photoCollectionViewCell
        cell.imageView.image = PhotoAlbumManager.shared.imageArray[indexPath.row]
    
        if (collectionView == albumTitleCollectionView) {
            let cell2 = albumTitleCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! AlbumTitleCollectionViewCell
            cell2.configure(with: PhotoAlbumManager.shared.titleArray[indexPath.row])
            if indexPath.row == 0 {
                cell2.titleView.isHidden = false
                
            }
            return cell2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == albumTitleCollectionView  {
    
                if self.selectedIndexPath?.row ?? -1 >= 0 {
                    if let cell = albumTitleCollectionView.cellForItem(at: self.selectedIndexPath!) as? AlbumTitleCollectionViewCell {
                        cell.titleView.isHidden = true
                        cell.albumTitle.textColor = .lightGray
                    }
                }
            
                if let cell = albumTitleCollectionView.cellForItem(at: indexPath) as? AlbumTitleCollectionViewCell {
                        cell.titleView.isHidden = false
                        cell.albumTitle.textColor = .white
                        self.selectedIndexPath = indexPath
                }
            PhotoAlbumManager.shared.getPhotos(with: PhotoAlbumManager.shared.titleArray[indexPath.row])
            self.photoCollectionView.reloadData()
    }
        
        if collectionView == photoCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let imageCustomVC = storyboard.instantiateViewController(withIdentifier: "ImageCustomizeVC") as! PhotoCustomizeVC
                imageCustomVC.originalImage = PhotoAlbumManager.shared.imageArray[indexPath.row]
            self.navigationController?.pushViewController(imageCustomVC, animated: true)
        }
    }
}
    
