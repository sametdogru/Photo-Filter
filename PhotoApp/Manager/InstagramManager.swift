//
//  InstagramManager.swift
//  PhotoApp
//
//  Created by Ahmet Doğru on 24.09.2019.
//  Copyright © 2019 Samet Doğru. All rights reserved.
//

import Foundation
import UIKit


class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
  
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {

        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            
            do {
                try imageInstagram.jpegData(compressionQuality: 0.75)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                print(error)
            }
            
            let rect = CGRect.zero
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            
            
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
        
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
        }
        else {
            
            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
        }
    }
}
