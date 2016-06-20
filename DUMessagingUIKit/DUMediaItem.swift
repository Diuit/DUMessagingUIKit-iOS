//
//  DUMediaItem.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

/**
 *  This structure contains all elements required by a media message for displaying.
 */
public struct DUMediaItem {
    /**
     Indicating the type of this media message
     
     - image:    An image message.
     - video:    A video message.
     - file:     A file message.
     - audio:    An audio message.
     - location: A location message.
     - URL:      If your text message contains only URL, it will be transformed to an URL media message.
     */
    public enum Type: String {
        case Image
        case Video
        case File
        case Audio
        case Location
        case URL
    }
    
    /// Return the size of media content
    public var mediaDisplaySize: CGSize {
        switch self.type {
        case .Image, .Video, .Location:
            return CGSizeMake(212, 158)
        case .Audio, .File:
            return CGSizeMake(212, 53)
        case .URL:
            return CGSizeMake(204, 109)
        }
    }
    
    // MARK: Stored Properties
    /// Type of the media message
    var type: Type
    ///  An UIView instance for placeholder.
    var placeholder: UIView
    /// An UIview of acutal meida content, will be diffrent in layout for each type.
    var mediaContent: UIView? = nil
    
    public init(type: Type, mediaSource: AnyObject?) {
        self.type = type
        self.placeholder = DUMediaPlaceholderView.init()
        // FIXME: do a real content view
        if type == .Image {
            let imageSource = mediaSource as? UIImage
            if imageSource == nil {
                self.mediaContent = nil
            } else {
                self.mediaContent = DUMediaContentViewFactory.makeImageContentView(imageSource!, frame: nil)
                self.mediaContent?.frame.size = self.mediaDisplaySize
            }
        }
        
        self.placeholder.frame.size = self.mediaDisplaySize
    }
}
