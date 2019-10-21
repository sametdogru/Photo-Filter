//
//  ImageCustomizeVC.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 19.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit
import CoreImage

class PhotoCustomizeVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath?
    
    var filterImageArray = [UIImage]()
    
    var myFilterModel = [FilterModel]()
    var context = CIContext()
    var originalImage: UIImage! // = UIImage(named: "image")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = originalImage
        addFilters()
        self.blurEffect()
    }

    func blurEffect() {
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: originalImage!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        self.bgImageView.image = processedImage
    }
    
    func addFilters() {
        
        filter("Original", filter: "none")
        filter("Elegant", filter: "CIPhotoEffectInstant")
        filter("Noir", filter: "CIPhotoEffectNoir")
        filter("Black", filter: "CIPhotoEffectTonal")
        filter("Alive", filter: "CIPhotoEffectTransfer")
        filter("Sepia", filter: "CISepiaTone")

        for  i in 0...self.myFilterModel.count-1 {
            
            if i == 0 {
                self.filterImageArray.append(originalImage)
            } else {
                self.filterImageArray.append(self.applyAppleFilterToImage(with: originalImage, filterName: self.myFilterModel[i].filter))
            }
        }
        self.filterCollectionView.reloadData()
    }
    
    func filter(_ name: String, filter: String) {
        self.myFilterModel.append(FilterModel(name: name, filter: filter))
    }

    func applyAppleFilterToImage(with image: UIImage, filterName: String) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: "\(filterName)" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        //swiftlint:disable all
        let filteredImageData = filter!.value(forKey:kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredİmage = UIImage(cgImage: filteredImageRef!)
        return filteredİmage
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myFilterModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCollectionViewCell
        cell.configure(with: self.filterImageArray[indexPath.row], name: self.myFilterModel[indexPath.row].name)
        
        if indexPath.row == 0 {
            cell.nameView.isHidden = false
            cell.imageFilter.image = UIImage(named: "none")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedIndexPath?.row ?? -1 >= 0 {
            if let cell = filterCollectionView.cellForItem(at: self.selectedIndexPath!) as? FilterCollectionViewCell {
                cell.filterName.textColor = .lightGray
                cell.nameView.isHidden = true
            }
        }
        
        if let cell = filterCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.filterName.textColor = .white
            cell.nameView.isHidden = false
            
            if indexPath.row != 0 {
                self.imageView.image = self.filterImageArray[indexPath.row]
            } else {
                self.imageView.image = originalImage
            }
            self.selectedIndexPath = indexPath
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func okButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let photoSharedVC = storyBoard.instantiateViewController(withIdentifier: "PhotoSharedVC") as! PhotoSharedVC
        photoSharedVC.image = self.imageView.image!
        photoSharedVC.bgImage = self.bgImageView.image!
        self.navigationController?.pushViewController(photoSharedVC, animated: true)
    }
}

