//
//  Extensions.swift
//  Assginment
//
//  Created by ndot on 05/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import UIKit
import SDWebImage

class Extensions: NSObject {

    class func getSDImages(imageBaseUrl: String, imageView : UIImageView, reSize : CGSize) -> Void
    {
        imageView.image = #imageLiteral(resourceName: "NoImage")
        
        let imageV : UIImage! = SDImageCache.shared().imageFromCache(forKey: imageBaseUrl)
        
        let url = URL(string: imageBaseUrl)
        
        if imageV == nil // Check whether Image is already in cache or not
        {
            //Again download tha image and set
            
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "NoImage"), options: []) { (image, error, cacheType, url) in
                if error == nil{
                    
                    if reSize != CGSize.zero
                    {
                        let reSizeImage = image?.resizedImageWithinRect(rectSize: reSize)
                        
                        imageView.image = reSizeImage
                    }
                    else {
                        imageView.image = image
                        
                    }
                }
                else {
                    imageView.image = #imageLiteral(resourceName: "NoImage")
                }
            }
        }
        else {
            if reSize != CGSize.zero
            {
                let reSizeImage = imageV.resizedImageWithinRect(rectSize: reSize)
                
                imageView.image = reSizeImage
            }
            else {
                imageView.image = imageV
            }
        }
        
    }
}

extension UIImage {
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Returns a image that fills in newSize
    
    func resizedImage(newSize: CGSize) -> UIImage {
        
        // Guard newSize is different
        
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
        
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    
    /// Note that the new image size is not rectSize, but within it.
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        
        let widthFactor = size.width / rectSize.width
        
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        
        if size.height > size.width {
            
            resizeFactor = heightFactor
            
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        
        let resized = resizedImage(newSize: newSize)
        
        return resized
        
    }
}
