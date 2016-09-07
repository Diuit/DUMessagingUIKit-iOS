//
//  DUExtensions.swift
//  DUMessagingUI
//
//  Created by Pofat Tseng on 2016/5/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

// MARK: Resources
public extension UIColor {
    class func DUWaterBlueColor() -> UIColor {
        return UIColor(red: 20.0 / 255.0, green: 167.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    }
    
    class func DUAvatarBgDefaultColor() -> UIColor {
        return UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
    
    class func DUBlackColor() -> UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    class func DUUnreadBlackColor() -> UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }
    
    class func DUDarkGreyColor() -> UIColor {
        return UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    
    class func DULightgreyColor() -> UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 1.0)
    }
    
    class func DUSettingbgColor() -> UIColor {
        return UIColor(red: 245.0 / 255.0, green: 248.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
    }
    
    class func DUShadowColor() -> UIColor {
        return UIColor(red: 56.0 / 255.0, green: 60.0 / 255.0, blue: 69.0 / 255.0, alpha: 0.25)
    }
    
    class func DUWarnigColor() -> UIColor {
        return UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    }
    
    class func DUWhiteColor() -> UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
}

public extension UIFont {
    class func DUBodyTimeFriendFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 22.0)!
    }
    
    class func DUNavigationFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 17.0)!
    }
    
    class func DUSubheadFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 16.0)!
    }
    
    class func DUMessageSenderFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 12.0)!
    }
    
    class func DUUnreadTitleFont() -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: 16.0)!
    }
    
    class func DUSendButtonFont() -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: 14.0)!
    }
    
    class func DUFileTitleFont() -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: 15.0)!
    }
    
    class func DUBodyFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 14.0)!
    }
    
    class func DUChatBodyFriendFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 14.0)!
    }
    
    class func DUBodyTimeUnreadFont() -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: 11.0)!
    }
    
    class func DUMessageTimeLabelFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 11.0)!
    }
    
    class func DUFileDescLabelFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 11.0)!
    }
    
    class func DUChatroomDateFont() -> UIFont {
        return UIFont(name: "Helvetica-Light", size: 11.0)!
    }
    
    class func DUChatAvatarFont() -> UIFont {
        return UIFont (name: "Helvetica Neue", size: 30)!
    }
    
    class func DUURLPreviewTitleFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 12.0)!
    }

    class func DUURLPreviewDescriptionFont() -> UIFont {
        return UIFont(name: "Helvetica-Light", size: 10.0)!
    }
    
}

// MARK: functions
public extension NSDate {
    /**
        Convert NSDate instance to a String indicating time with specif format:
            - 7:33PM : Display hour and minute if the time is today
            - April 11 : Display date if the time lies in this year
            - 2015/04/11 : Display complete date if the time is even earlier
     */
    var messageTimeLabelString: String {
        get {
            let cal = NSCalendar.currentCalendar()
            var components = cal.components([.Era, .Year, .Month, .Day], fromDate: NSDate())
            let currentYear = components.year
            let today = cal.dateFromComponents(components)!
            components = cal.components([.Era, .Year, .Month, .Day], fromDate: self)
            let thisYear = components.year
            let thisDate = cal.dateFromComponents(components)!
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            if today.isEqualToDate(thisDate) { // today, print out time only
                dateFormatter.dateStyle = .NoStyle
                dateFormatter.timeStyle = .ShortStyle
            } else { // not today, print out date
                if thisYear == currentYear {
                    dateFormatter.dateFormat = "MMM dd"
                } else {
                    dateFormatter.dateStyle = .ShortStyle
                    dateFormatter.timeStyle = .NoStyle
                }
            }
            
            return dateFormatter.stringFromDate(self)
        }
    }
}

public extension UIImage {
    class func DUNewChatButtonImage() -> UIImage {
        return UIImage(named: "CreateChat_n", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    
    class func DUDefaultPersonAvatarImage() -> UIImage {
        return UIImage(named: "defaultAvatar", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    
    class func DUAddUserImage() -> UIImage {
        return UIImage(named: "addUser", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    
    class func DUFileIconImage() -> UIImage {
        return UIImage(named: "fileIcon", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    
    class func DUPlayIcon() -> UIImage {
        return UIImage(named:"playIcon", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    
    class func DUSettingsIcon() -> UIImage {
        return UIImage(named:"setting", inBundle: NSBundle.du_messagingUIKitBundle , compatibleWithTraitCollection: nil)!
    }
    /**
        Return an UIImage instance with size 1.0 * 1.0 of given background UIColor
     */
    class func imageWith(backgroundColor color: UIColor) -> UIImage {
        let rect: CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func masked(withColor color: UIColor) -> UIImage {
        let imageRect = CGRectMake(0, 0, self.size.width, self.size.height)
        var maskedImage: UIImage! = nil
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CGContextClipToMask(context, imageRect, self.CGImage)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        
        maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
}


public extension NSAttributedString {
    class func DUDeliverWarningAttributed(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSFontAttributeName : UIFont.DUMessageTimeLabelFont(), NSForegroundColorAttributeName : UIColor.DUWarnigColor()])
    }
}

public extension UIView {
    /// Add NSLayoutConstraints to make subview as same as current view in size
    func pingAlledge(ofSubview subview: UIView) {
        self.ping(subview: subview, toEdge: .Top)
        self.ping(subview: subview, toEdge: .Leading)
        self.ping(subview: subview, toEdge: .Bottom)
        self.ping(subview: subview, toEdge: .Trailing)
    }
    /// Ping one edge of subview with given attribut onto current view's edge
    func ping(subview subview:UIView, toEdge attribute: NSLayoutAttribute) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0.0))
    }
}

public extension String {
    /**
     Return a `String` object with all white all spaces trimmed
     
     - returns: Trimmed String
     */
    func du_trimingWhitespace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    /**
     Calculate the minimum rectangle which contains the given text, with given width and font.
     
     - parameter width: The maximum width of the text.
     - parameter font:  UIFont of the text
     
     - returns: A CGRect structure of calculated result.
     */
    func rectWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingRect = self.boundingRectWithSize(constraintRect, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return CGRectIntegral(boundingRect)
    }
    
    /**
     To verify if this string is a valid HTTP URL
     
     - returns: A Bool to indicate if this is a HTTP URL
     */
    func isValidURL() -> Bool {
        let urlRegEx = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [urlRegEx])
        return predicate.evaluateWithObject(self)
    }
}

public extension NSObject {
    /// Return class string
    public class var nameOfClass: String{
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    /// Return dynamic type string of the instance
    public var nameOfClass: String{
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}


public extension NSURL {
    /**
     Get complete asset file name, e.g. 'image1.jpg'
     
     - returns: A String of complte file name.
     */
    func getAssetFullFileName() -> String? {
        guard self.scheme == "assets-library" else {
            return nil
        }
        let absoluePath = self.absoluteString
        let idRange = absoluePath.rangeOfString("id=")
        let extRange = absoluePath.rangeOfString("&ext=")
        let fileName = absoluePath.substringWithRange(idRange!.endIndex..<extRange!.startIndex)
        let ext = absoluePath.substringWithRange(extRange!.endIndex..<absoluePath.endIndex)
        return fileName+"."+ext
    }
    
    /**
     Get asset file extentsion, e.g. 'jpg'
     
     - returns: A String of file extenstion.
     */
    func getAssetFileExt() -> String? {
        guard self.scheme == "assets-library" else {
            return nil
        }
        let absoluePath = self.absoluteString
        let extRange = absoluePath.rangeOfString("&ext=")
        return absoluePath.substringWithRange(extRange!.endIndex..<absoluePath.endIndex)
    }
    
    /**
     Get asset file name without extension, e.g. 'image1'
     
     - returns: A String of file name.
     */
    func getAssetFileName() -> String? {
        guard self.scheme == "assets-library" else {
            return nil
        }
        let absoluePath = self.absoluteString
        let idRange = absoluePath.rangeOfString("id=")
        let extRange = absoluePath.rangeOfString("&ext=")
        return absoluePath.substringWithRange(idRange!.endIndex..<extRange!.startIndex)
    }
}

public extension NSBundle {
    static var du_messagingUIKitBundle: NSBundle {
        return NSBundle(forClass: DUMessagesViewController.classForCoder())
    }
}



