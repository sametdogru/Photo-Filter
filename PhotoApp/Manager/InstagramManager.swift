import UIKit

final class InstagramManager {
    
    static func instagramIsActive() -> Bool {
        let url = URL(string: "instagram-stories://share")
        let isActive = UIApplication.shared.canOpenURL(url!)
        return isActive
    }
    
    static func shareInstagramStory(img: UIImage) {
        let data: NSData = img.pngData()! as NSData
        let url = URL(string: "instagram-stories://share")
        
        let pasteboardItems: [String: Any] = ["com.instagram.sharedSticker.stickerImage": data as Data]
        let pasteboardOptions = UIPasteboard.OptionsKey(rawValue: "instagramOption")
        UIPasteboard.general.setItems([pasteboardItems], options: [pasteboardOptions: Date().addingTimeInterval(60 * 5)])
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}


