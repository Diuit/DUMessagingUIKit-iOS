//
//  DUMediaContentViewFactory.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import URLEmbeddedView

let kMaximumURLCharacterNumbersInURLMediaContentView: Int = 23
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
    /**
     Generate contetn view of an URL message.
     
     - parameter url:   URL string.
     - parameter frame: Content view frame.
     
     - returns: A composed UIView of URL preview result.
     */
    public static func makeURLContentView(url: String, frame: CGRect) -> DUURLMediaContentView {
        let contentView = DUURLMediaContentView.init(frame: frame)
        
        let urlFrame: CGRect = CGRectMake(0, 33, frame.size.width, frame.size.height - 33)
        let urlView = URLEmbeddedView.init(frame: urlFrame)
        contentView.addSubview(urlView)
        
        urlView.cornerRaidus = 0
        urlView.backgroundColor = UIColor.whiteColor()
        urlView.borderWidth = 0
        urlView.textProvider[.Title].font = UIFont.DUURLPreviewTitleFont()
        urlView.textProvider[.Description].font = UIFont.DUURLPreviewDescriptionFont()
        urlView.loadURL(url)
        
        let textFrame: CGRect = CGRectMake(0, 0, frame.size.width, 33)
        let textView: UITextView = UITextView.init(frame: textFrame)
        contentView.addSubview(textView)
        
        textView.scrollEnabled = false
        textView.editable = false
        textView.backgroundColor = UIColor.DULightgreyColor()
        textView.textContainerInset = UIEdgeInsetsMake(7, 14, 7, 14)
        textView.font = UIFont.DUBodyFont()!
        
        // FIXME: truncate too long url string, a stupid way
        var truncatedString: String = ""
        if url.characters.count > kMaximumURLCharacterNumbersInURLMediaContentView {
            truncatedString = url.substringToIndex(url.startIndex.advancedBy(kMaximumURLCharacterNumbersInURLMediaContentView - 1))
            truncatedString += "..."
        } else {
            truncatedString = url
        }
        let underline = NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternSolid.rawValue
        textView.attributedText = NSAttributedString(string: truncatedString, attributes:
            [  NSForegroundColorAttributeName : UIColor.blueColor(),
               NSFontAttributeName: UIFont.DUBodyFont()!,
               NSUnderlineStyleAttributeName: underline])
        
        return contentView
    }
    
    
    public static func makeFileContentView(name: String, frame: CGRect) -> DUFileMediaContentView {
        let contentView = DUFileMediaContentView.init(frame: frame)
        
        let imageView = UIImageView.init(frame: CGRectMake(12, 9, 32, 36))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage.DUFileIconImage()
        contentView.addSubview(imageView)
        
        let fileNameLabel = UILabel
        
    }
}
