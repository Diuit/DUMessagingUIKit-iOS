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
    public enum MediaType: String {
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
            return CGSize(width: 212, height: 158)
        case .Audio, .File:
            return CGSize(width: 212, height: 53)
        case .URL:
            return CGSize(width: 204, height: 109)
        }
    }
    
    // MARK: Stored Properties
    /// Type of the media message
    public var type: MediaType
    ///  An UIView instance for placeholder.
    public var placeholderView: UIView { return _cachedPlaceholderView }
    /// Instance of media content, may be an UIImage
    public var mediaContentData: AnyObject?
    /// URL of media source. Used by file, URL, video and audio message.
    public var mediaSourceURL: String? = nil
    /// Display name of the file on media content view.
    public var fileDisplayName: String? = nil
    /// Detail description of file, default value is `nil`.
    public var fileDescription: String? = nil
    
    fileprivate var _cachedMediaContentView: UIView? = nil
    fileprivate var _cachedPlaceholderView: DUMediaPlaceholderView
    
    // MARK: Initialize
    /**
     Init an image mediaItem
     
     - parameter image: Main image, could be `nil` if you have not retrieved the image yet.
     
     - returns: An instance of `DUMediaItem` of image type
     */
    public init(fromImage image: UIImage?) {
        self.type = .Image
        self.mediaContentData = image
        _cachedPlaceholderView = DUMediaPlaceholderView.init(frame:CGRect.zero)
        _cachedPlaceholderView.frame = CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height)
    }
    
    /**
     Init an image mediaItem from URL string
     
     - parameter url: URL string of the image resource.
     
     - returns: An instance of `DUMediaItem` of image type
     */
    public init(fromImageURL url: String) {
        self.type = .Image
        self.mediaContentData = nil
        self.mediaSourceURL = url
        _cachedPlaceholderView = DUMediaPlaceholderView.init(frame:CGRect.zero)
        _cachedPlaceholderView.frame = CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height)
    }
    /**
     Init a video mediaItem
     
     - parameter url: URL string of video file path
     - parameter image: Preive image of the video.
     
     - returns: An instance of `DUMediaItem` of video type
     
     - note: If you initialize with a preview image, `mediaContentData` will be used to save it.
     */
    public init(fromVideoURL url: String, withPreviewImage image: UIImage?) {
        self.type = .Video
        self.mediaSourceURL = url
        self.mediaContentData = image
        
        _cachedPlaceholderView = DUMediaPlaceholderView.init(frame:CGRect.zero)
        _cachedPlaceholderView.frame = CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height)
    }
    
    /**
     Init a file mediaItem
     
     - parameter url:             URL string of file path
     - parameter fileName:        File name string.
     - parameter fileDescription: File information, such as file size. Default value is `nil`.
     
     - returns: An instance of `DUMediaItem` of file type
     
     - note: This file is neither playable video or playable audio
     */
    public init(fromFileURL url: String, fileName: String, fileDescription: String?) {
        self.type = .File
        self.mediaSourceURL = url
        self.fileDisplayName = fileName
        self.fileDescription = fileDescription
        
        _cachedPlaceholderView = DUMediaPlaceholderView.init(frame:CGRect.zero)
        _cachedPlaceholderView.frame = CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height)
    }
    
    /**
     Init a URL preview mediaItem
     
     - parameter url: URL string
     
     - returns: An instance of `DUMediaItem` of URL type
     
     - note: You can get a preview from web page's open graph (if they have)
     */
    public init(fromURL url: String) {
        self.type = .URL
        self.mediaSourceURL = url
        
        _cachedPlaceholderView = DUMediaPlaceholderView.init(frame:CGRect.zero)
        _cachedPlaceholderView.frame = CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height)
    }

    /**
     Get media contnet view. Return `nil` if there is no media data
     
     - returns: A media content view. May be UIImageView or composed UIView
     */
    public mutating func getMediaContentView() -> UIView? {
        if mediaContentData == nil && mediaSourceURL == nil {
            return nil
        }
        
        if _cachedMediaContentView != nil {
            return _cachedMediaContentView
        }
        
        switch type {
        case .Image:
            _cachedMediaContentView = DUMediaContentViewFactory.makeImageContentView(image: mediaContentData as? UIImage, frame:CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height))
            return _cachedMediaContentView
        case .URL:
            _cachedMediaContentView = DUMediaContentViewFactory.makeURLContentView(url: mediaSourceURL!, frame: CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height))
            return _cachedMediaContentView
        case .File:
            _cachedMediaContentView = DUMediaContentViewFactory.makeFileContentView(name: fileDisplayName ?? "File", description: fileDescription, frame: CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height))
            return _cachedMediaContentView
        case .Video:
            _cachedMediaContentView = DUMediaContentViewFactory.makeVideoContentView(previewImage: mediaContentData as? UIImage, frame: CGRect(x: 0, y: 0, width: mediaDisplaySize.width, height: mediaDisplaySize.height))
            return _cachedMediaContentView
        default:
            return nil
        }
    }
    
    /**
     Set a media content view on your own. Rememer your customized view will be displayed with default size for each type of media message.
     
     - parameter view: Your customized media content view.
     */
    public mutating func set(mediaContentView view: UIView) {
        _cachedMediaContentView = view
    }

}
