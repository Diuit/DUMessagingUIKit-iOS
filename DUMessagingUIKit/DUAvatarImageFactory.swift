//
//  DUAvatarImageFactory.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/21.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUAvatarImageFactory: NSObject {
    /// Defualt avatar image diameter in DUChatList table view
    public static let kAvatarImageDefaultDiameterInChatList: CGFloat = 66.0
    /// Default avatar image diameter in DUMessagesCollectionView
    public static let kAvatarImageDefualtDiameterInMessags: CGFloat = 32.0
    
    /**
        Create an UIImage instance of avatar with given text and diameter
        
        - parameters:
            - text: The displaying text at the center of avatar image. Better use short and uppercasted text.
     
        - returns:
            An UIImage instance of avatar, or `nil` if creation failed
     */
    public static func makeTextAvatarImage(text: String, backgroundColor: UIColor = UIColor.DUAvatarBgDefaultColor(), textColor: UIColor = UIColor.white, font: UIFont, diameter: CGFloat) -> UIImage? {
        assert(diameter > 0, "diameter of avatar image must be greater than 0")
        
        let frame: CGRect = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
        let attributes:[String: AnyObject] = [NSForegroundColorAttributeName: textColor, NSFontAttributeName: font]
        let NSText = text as NSString
        let textRect = NSText.size(attributes: attributes)
        
        let frameCenter: CGPoint = CGPoint(x: frame.midX, y: frame.midY)
        let textCenter: CGPoint = CGPoint(x: textRect.width/2, y: textRect.height/2)
        
        let drawOrigin: CGPoint = CGPoint(x: frameCenter.x - textCenter.x, y: frameCenter.y - textCenter.y)
        
        var resultImage: UIImage? = nil
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(backgroundColor.cgColor)
        context.fill(frame)
        NSText.draw( at: drawOrigin, withAttributes: attributes)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }

}
