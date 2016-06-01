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

// protocol for loading mediat resource
public protocol DUImageResource: DURemoteResource {
    var imagePath: String { get }
    var placeholderImage: UIImage { get }
}
extension DUImageResource {
    public func load(url: String, completion: (Bool -> Void)? ) {
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
    
    /// Beware your completion closure will be executed in main queue, so do not deal with time-consuming stuff here
    func loadImage(completion: (Void -> Void)? ) {
        self.load(self.imagePath) { success in
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
    
    /// return cached image for given URL
    func imageForURL(url: String) -> UIImage? {
        let imgManager = SDWebImageManager.sharedManager()
        let indexKey = imgManager.cacheKeyForURL(NSURL(string: url))
        return imgManager.imageCache.imageFromMemoryCacheForKey(indexKey)
    }
    
    /// get UIImage value
    var imageValue: UIImage? {
        if let img = self.imageForURL(self.imagePath) {
            return img
        } else {
            return self.placeholderImage
        }
        
    }
}
