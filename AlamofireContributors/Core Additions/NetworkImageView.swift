//
//  NetworkImageView.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/2/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

class NetworkImageView: UIImageView {
    
    var dataTask : URLSessionDataTask?
    
    func loadImageUsingCache(withUrl url : URL) {
        self.image = nil
        dataTask?.cancel()
        
        if let cachedImage = imageCache.object(forKey: url.path as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.path as NSString)
                    self.image = image
                }
            }
            
        })
        
        dataTask?.resume()
        
    }

}
