//
//  DUAvatarImageFactory.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/21.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUAvatarImageFactory: NSObject {
    // constants
    public static let kAvataImageDefaultDiameterInChatsList: CGFloat = 66.0
    public static let kAvatarImageDefualtDiameterInMessags: CGFloat = 32.0
    
    /// return an UIImage instance of default user avatar
    //public static let defaultUserAvatarImage: UIImage = UIImage.DUDefaultUserAvatarImage()!
    
    public static func avatarImageWithString(text: String, backgroundColor: UIColor = UIColor.DUAvatarBgDefaultColor(), textColor: UIColor = UIColor.whiteColor(), font: UIFont, diameter: CGFloat) -> UIImage? {
        //assert(text != nil, "Source string can not be nil")
        //assert(font != nil, "Font can not be nil")
        assert(diameter > 0, "diameter of avatar image must be greater than 0")
        
        let frame: CGRect = CGRectMake(0.0, 0.0, diameter, diameter)
        let attributes:[String: AnyObject] = [NSForegroundColorAttributeName: textColor, NSFontAttributeName: font]
        let NSText = text as NSString
        let textRect = NSText.sizeWithAttributes(attributes)
        
        let frameCenter: CGPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        let textCenter: CGPoint = CGPointMake(textRect.width/2, textRect.height/2)
        
        let drawOrigin: CGPoint = CGPointMake(frameCenter.x - textCenter.x, frameCenter.y - textCenter.y)
        
        var resultImage: UIImage? = nil
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, frame)
        NSText.drawAtPoint( drawOrigin, withAttributes: attributes)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }

}
