//
//  DUMediaContentViewFactory.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

/// Generate media content views for each media message type.
public class DUMediaContentViewFactory {
    /**
     Generate content view of image message.
     
     - parameter image:            Main image.
     - parameter highlightedImage: Highlighted image.
     - parameter frame:            Frame rect.
     
     - returns: UIImageView instance with image of the message. Return `nil` if image is nil
     */
    public static func makeImageContentView(image: UIImage?, highlightedImage: UIImage? = nil, frame: CGRect? = CGRectMake(0,0, 212, 158)) -> DUMediaContentImageView? {
        guard image != nil else {
            return nil
        }
        let imageView = DUMediaContentImageView.init(frame: frame ?? CGRectZero)
        imageView.image = image
        imageView.highlightedImage = highlightedImage
        return imageView
    }
    
    
}
