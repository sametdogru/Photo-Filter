//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 10.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var secondPhotoView: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var albumTitleCollectionView: UICollectionView!
    

    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization({
            (status) in
        
            switch status {
            case .notDetermined:
                print("izin yok sorulmamış")
            case .authorized:
                DispatchQueue.main.async {
                    self.fetchPhotos()
                    self.setUI()
                }
            case .denied:
                DispatchQueue.main.async {
                    self.makeAlert()
                }
                print("reddetmiş")
                
            case .restricted: break
            default: break
            }
        })

    }
    
    func makeAlert(){
        let alert = UIAlertController(title: "'PhotoApp' Like to Access Your Photos 🤔", message: "Go to Settings", preferredStyle: .alert)
        let button = UIAlertAction(title: "Settings", style: .default) { (UIAlertAction) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUI() {
        photoView.layer.cornerRadius = 20
        photoCollectionView.layer.cornerRadius = 25
    }
    
    func fetchPhotos() {
        PhotoAlbumManager.shared.fetchAlbums()
        PhotoAlbumManager.shared.getPhotos(with: PhotoAlbumManager.shared.titleArray[0])
        self.albumTitleCollectionView.reloadData()
        self.photoCollectionView.reloadData()
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
            let imageCustomVC = storyboard.instantiateViewController(withIdentifier: "PhotoCustomizeVC") as! PhotoCustomizeVC
                imageCustomVC.originalImage = PhotoAlbumManager.shared.imageArray[indexPath.row]
            self.navigationController?.pushViewController(imageCustomVC, animated: true)
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "PhotoCustomizeVC") as! PhotoCustomizeVC
        vc.originalImage = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotoAlbumVC: UICollectionViewDelegateFlowLayout {
    
    private func collectionView(_ collectionView: photoCollectionViewCell, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = photoCollectionView.bounds.width
        return CGSize(width: collectionWidth/3 - 2, height: collectionWidth/3 - 2)
    }
    
    private func collectionView(_ collectionView: photoCollectionViewCell, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    private func collectionView(_ collectionView: photoCollectionViewCell, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
    
