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
    class func DUBodyTimeFriendFont() -> UIFont? {
        //TODO: fix custom font return nil
        //return UIFont(name: "Roboto-Regular", size: 22.0)
        return UIFont(name: "Helvetica", size: 22.0)
    }
    
    class func DUNavigationFont() -> UIFont? {
        return UIFont(name: "Helvetica", size: 17.0)
    }
    
    class func DUSubheadFont() -> UIFont? {
        return UIFont(name: "Helvetica", size: 16.0)
    }
    
    class func DUUnreadTitleFont() -> UIFont? {
        //TODO: fix custom font return nil
        //return UIFont(name: "Roboto-Bold", size: 16.0)
        return UIFont(name: "Helvetica-Bold", size: 16.0)
    }
    
    class func DUSendButtonFont() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 14.0)
    }
    
    class func DUBodyFont() -> UIFont? {
        return UIFont(name: "Helvetica", size: 14.0)
    }
    
    class func DUChatBodyFriendFont() -> UIFont? {
        return UIFont(name: "Helvetica", size: 14.0)
    }
    
    class func DUBodyTimeUnreadFont() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 11.0)
    }
    
    class func DUBodyTimeFont() -> UIFont? {
        return UIFont(name: "Helvetica", size: 11.0)
    }
    
    class func DUChatroomDateFont() -> UIFont? {
        return UIFont(name: "Helvetica-Light", size: 11.0)
    }
    
    class func DUChatAvatarFont() -> UIFont? {
        return UIFont (name: "Helvetica Neue", size: 30)
    }
}

// MARK: functions
extension NSDate {
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
        return UIImage(named: "CreateChat_n", inBundle: NSBundle(identifier: Constants.bundleIdentifier) , compatibleWithTraitCollection: nil)!
    }
    
    class func DUDefaultPersonAvatarImage() -> UIImage {
        return UIImage(named: "defaultAvatar", inBundle: NSBundle(identifier: Constants.bundleIdentifier) , compatibleWithTraitCollection: nil)!
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}

// NSStringFromClass for Swift version
public extension NSObject{
    public class var nameOfClass: String{
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    public var nameOfClass: String{
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}


