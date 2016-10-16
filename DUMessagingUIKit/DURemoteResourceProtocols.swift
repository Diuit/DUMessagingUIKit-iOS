//
//  RemoteResourceProtocol.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/28.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

/// Base protocol for remote resources
public protocol DURemoteResource {
    func load(url: String, completion: ((Bool) -> Void)? )
}

/// Protocol for loading image resource
public protocol DUImageResource: DURemoteResource {
    /// URL of image resource
    var imagePath: String? { get }
    /// Placeholder image for displaying before image is fully loaded
    //var placeholderImage: UIImage { get }
}
extension DUImageResource {
    /// Load the image resource from imagePath
    public func load(url: String, completion: ((Bool) -> Void)? ) {
        guard imagePath != nil && imagePath != "" else {
            print("image path is nil or empty")
            completion?(false)
            return
        }
        print("Fetching remote resources from \(url)")
        
        if let _ = imageCache.object(forKey: url as AnyObject) as? Data {
            completion?(true)
        } else {
            let session = URLSession.shared
            let u = URL(string: url)
            let downloadTask = session.dataTask(with: u!, completionHandler: { data, response, error in
                guard error == nil else {
                    completion?(false)
                    return
                }
                if data != nil {
                    imageCache.setObject(data! as AnyObject, forKey: url as AnyObject)
                    completion?(true)
                }
            })
            downloadTask.resume()
        }

    }
    
    /// Send a completion handler to this function and trigger the image loading procedure.
    /// Beware your completion closure will be executed in main queue, so do not deal with time-consuming stuff here.
    func loadImage(onCompletion completion: ((Void) -> Void)? ) {
        guard self.imagePath != nil else { return }
        self.load(url: self.imagePath!) { success in
            if let c = completion {
                DispatchQueue.main.async(execute: c)
            }
        }
    }
    
    /// Return cached image for given URL
    func imageFor(url: String) -> UIImage? {
        let cachedData = imageCache.object(forKey: url as AnyObject) as? Data
        if let _ = cachedData {
            return UIImage(data: cachedData!)
        } else {
            return nil
        }
    }
    
    /// get UIImage instance, return placeholderImage if remote resource failed to load
    var imageValue: UIImage? {
        if self.imagePath == nil { return nil }
        if let img = self.imageFor(url: self.imagePath!) {
            return img
        } else {
            return nil
        }
        
    }
}
