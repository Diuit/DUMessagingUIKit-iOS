//
//  RemoteResourceProtocol.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/28.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import SDWebImage

/// Base protocol for remote resources
public protocol DURemoteResource {
    func load(url: String, completion: (Bool -> Void)? )
}

/// Protocol for loading image resource
public protocol DUImageResource: DURemoteResource {
    /// URL of image resource
    var imagePath: String? { get }
    /// Placeholder image for displaying before image is fully loaded
    var placeholderImage: UIImage { get }
}
extension DUImageResource {
    /// Load the image resource from imagePath
    public func load(url: String, completion: (Bool -> Void)? ) {
        guard imagePath != nil else {
            print("image path is nil")
            completion?(false)
            return
        }
        print("Fetching remote resources from \(url)")
        let imgManager = SDWebImageManager.sharedManager()
        let indexKey = imgManager.cacheKeyForURL(NSURL(string: url))
        let cachedImage = imgManager.imageCache.imageFromMemoryCacheForKey(indexKey)
        if cachedImage != nil {
            completion?(true)
        } else {
            let downloader = SDWebImageDownloader.sharedDownloader()
            downloader.downloadImageWithURL(NSURL(string: url), options: .AllowInvalidSSLCertificates, progress: { (received, expected) in
                // do nothing about progress status
            }) { image, data, error, finished in
                if image != nil && finished {
                    // image downloaded
                    imgManager.saveImageToCache(image, forURL: NSURL(string: url))
                    completion?(true)
                } else {
                    // download failed
                    print("Request error! \(error!.localizedDescription)")
                    completion?(false)
                }
            }
        }
    }
    
    /// Send a completion handler to this function and trigger the image loading procedure.
    /// Beware your completion closure will be executed in main queue, so do not deal with time-consuming stuff here.
    func loadImage(completion: (Void -> Void)? ) {
        guard self.imagePath != nil else { return }
        self.load(self.imagePath!) { success in
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
    
    /// Return cached image for given URL
    func imageForURL(url: String) -> UIImage? {
        let imgManager = SDWebImageManager.sharedManager()
        let indexKey = imgManager.cacheKeyForURL(NSURL(string: url))
        return imgManager.imageCache.imageFromMemoryCacheForKey(indexKey)
    }
    
    /// get UIImage instance, return placeholderImage if remote resource failed to load
    var imageValue: UIImage? {
        if self.imagePath == nil { return nil }
        if let img = self.imageForURL(self.imagePath!) {
            return img
        } else {
            return self.placeholderImage
        }
        
    }
}
