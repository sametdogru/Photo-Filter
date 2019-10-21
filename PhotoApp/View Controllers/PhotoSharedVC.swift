//
//  PhotoSharedVC.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 23.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import UIKit

class PhotoSharedVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var shareStoryButton: UIButton!
    var image = UIImage()
    var bgImage = UIImage()
    
    override func viewDidLoad() {
        
       imageView.image = self.image
       bgImageView.image = self.bgImage
        
       setUI()
    }
    
    func setUI() {
        shareStoryButton.layer.cornerRadius = 24
        shareStoryButton.layer.borderWidth = 2
        shareStoryButton.layer.borderColor = UIColor(red: 255/255, green: 58/255, blue: 120/255, alpha: 1.0).cgColor
    }
    
    
    @IBAction func shareStoryButton(_ sender: Any) {
        InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: self.image, instagramCaption: "My Photo", view: self.view)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
