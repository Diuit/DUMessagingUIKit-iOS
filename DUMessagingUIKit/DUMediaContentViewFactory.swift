//
//  DUMediaContentViewFactory.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import URLEmbeddedView
import MisterFusion


/// Generate media content views for each media message type.
open class DUMediaContentViewFactory {
    /// Maximum characters in the title label of URL media view
    static let kMaximumURLCharacterNumbersInURLMediaContentView: Int = 23
    /**
     Generate content view of image message.
     
     - parameter image:            Main image.
     - parameter highlightedImage: Highlighted image.
     - parameter frame:            The frame size of this content view.
     
     - returns: UIImageView instance with image of the message. Return `nil` if image is nil
     */
    public static func makeImageContentView(image: UIImage?, highlightedImage: UIImage? = nil, frame: CGRect? = CGRect(x: 0,y: 0, width: 212, height: 158)) -> DUMediaContentImageView? {
        guard image != nil else {
            return nil
        }
        let imageView = DUMediaContentImageView.init(frame: frame ?? CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.highlightedImage = highlightedImage
        return imageView
    }
    /**
     Generate content view of an URL message.
     
     - parameter url:   URL string of the web page.
     - parameter frame: The frame size of dthis content view.
     
     - returns: A composed UIView of URL preview result.
     */
    public static func makeURLContentView(url: String, frame: CGRect) -> DUURLMediaContentView {
        // FIXME: size of each subviews are fixed. UI will go nuts when using customized frame.
        let contentView = DUURLMediaContentView.init(frame: frame)
        
        let urlFrame: CGRect = CGRect(x: 0, y: 33, width: frame.size.width, height: frame.size.height - 33)
        let urlView = URLEmbeddedView.init(frame: urlFrame)
        contentView.addSubview(urlView)
        
        urlView.cornerRaidus = 0
        urlView.backgroundColor = .white
        urlView.borderWidth = 0
        urlView.textProvider[.title].font = UIFont.DUURLPreviewTitleFont()
        urlView.textProvider[.description].font = UIFont.DUURLPreviewDescriptionFont()
        urlView.loadURL(url)
        
        let textFrame: CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 33)
        let textView: UITextView = UITextView.init(frame: textFrame)
        contentView.addSubview(textView)
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = UIColor.DULightgreyColor()
        textView.textContainerInset = UIEdgeInsetsMake(7, 14, 7, 14)
        textView.font = UIFont.DUBodyFont()
        
        // FIXME: truncate too long url string, a stupid way
        var truncatedString: String = ""
        if url.characters.count > kMaximumURLCharacterNumbersInURLMediaContentView {
            truncatedString = url.substring(to: url.characters.index(url.startIndex, offsetBy: kMaximumURLCharacterNumbersInURLMediaContentView - 1))
            truncatedString += "..."
        } else {
            truncatedString = url
        }
        let underline = NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternSolid.rawValue
        textView.attributedText = NSAttributedString(string: truncatedString, attributes:
            [  NSForegroundColorAttributeName : UIColor.blue,
               NSFontAttributeName: UIFont.DUBodyFont(),
               NSUnderlineStyleAttributeName: underline])
        
        return contentView
    }
    
    /**
     Generate content view of a file message. The file here refers to non-video and non-audio file. The content view will have a file icon, a file anme label and an description label(optional).
     
     - parameter name:        The file name which will be displayed on the screen.
     - parameter description: The description about the file, which is optional. Set to `nil` if you don't have any further information.
     - parameter frame:       The frame size of this content view.
     
     - returns: A composed view of a file message.
     
     - note: Typically you will use this for non-video and non-audio file. Just for general files which have only download operation.
     */
    public static func makeFileContentView(name: String, description: String?, frame: CGRect) -> DUFileMediaContentView {
        // FIXME: size of each subviews are fixed. UI will go nuts when using customized frame.
        let contentView = DUFileMediaContentView.init(frame: frame)
        
        let imageView = UIImageView.init(image: UIImage.DUFileIconImage())
        imageView.contentMode = .scaleAspectFill
        
        let fileNameLabel = UILabel.init()
        fileNameLabel.font = UIFont.DUFileTitleFont()
        fileNameLabel.text = name
        
        let fileDescLabel = UILabel.init()
        fileDescLabel.font = UIFont.DUFileDescLabelFont()
        fileDescLabel.text = description ?? ""
        
        contentView.addLayoutSubview(imageView, andConstraints:
            imageView.centerY |==| contentView.centerY,
            imageView.left    |+| 12,
            imageView.width   |==| 32,
            imageView.height  |==| 36
        )
        
        contentView.addLayoutSubview(fileNameLabel, andConstraints:
            fileNameLabel.top    |==| imageView.top,
            fileNameLabel.left   |==| imageView.right |+| 18,
            fileNameLabel.right  |-| 12,
            fileNameLabel.height |==| 20
        )
        
        contentView.addLayoutSubview(fileDescLabel, andConstraints:
            fileDescLabel.top    |==| fileNameLabel.bottom |+| 2,
            fileDescLabel.left   |==| imageView.right |+| 18,
            fileDescLabel.right  |-| 12,
            fileDescLabel.height |==| 14
        )
        
        return contentView
    }
    
    /**
     Generate content view of a playable video message. You can set a preivew image as background image of this video message cell, otherwise the background will be all black.
     
     - parameter previewImage: An UIImage as a preview of the video. Set to `nil` if you just want a pure black background.
     - parameter frame:        The frame size of this content view.
     
     - returns: A composed content view of playable video message.
     */
    public static func makeVideoContentView(previewImage: UIImage?, frame: CGRect) -> DUMediaContentView {
        let contentView = DUMediaContentView.init(frame: frame)
        
        let playIconImageView = UIImageView.init(image: UIImage.DUPlayIcon())
        playIconImageView.contentMode = .center
        playIconImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        if previewImage != nil {
            let backgroundImageView = UIImageView.init(image: previewImage!)
            backgroundImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            backgroundImageView.contentMode = .scaleAspectFill
            
            playIconImageView.backgroundColor = UIColor.clear
            backgroundImageView.addSubview(playIconImageView)
            
            contentView.addSubview(backgroundImageView)
        } else {
            playIconImageView.backgroundColor = UIColor.black
            contentView.addSubview(playIconImageView)
        }
        
        return contentView
    }
}
