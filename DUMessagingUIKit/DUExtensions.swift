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
public extension Date {
    /**
        Convert NSDate instance to a String indicating time with specif format:
            - 7:33PM : Display hour and minute if the time is today
            - April 11 : Display date if the time lies in this year
            - 2015/04/11 : Display complete date if the time is even earlier
     */
    var messageTimeLabelString: String {
        get {
            let cal = Calendar.current
            var components = (cal as NSCalendar).components([.era, .year, .month, .day], from: Date())
            let currentYear = components.year
            let today = cal.date(from: components)!
            components = (cal as NSCalendar).components([.era, .year, .month, .day], from: self)
            let thisYear = components.year
            let thisDate = cal.date(from: components)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            if today == thisDate { // today, print out time only
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
            } else { // not today, print out date
                if thisYear == currentYear {
                    dateFormatter.dateFormat = "MMM dd"
                } else {
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .none
                }
            }
            
            return dateFormatter.string(from: self)
        }
    }
}

public extension UIImage {
    class func DUNewChatButtonImage() -> UIImage {
        return UIImage(named: "CreateChat_n", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    
    class func DUDefaultPersonAvatarImage() -> UIImage {
        return UIImage(named: "defaultAvatar", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    
    class func DUAddUserImage() -> UIImage {
        return UIImage(named: "addUser", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    
    class func DUFileIconImage() -> UIImage {
        return UIImage(named: "fileIcon", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    
    class func DUPlayIcon() -> UIImage {
        return UIImage(named:"playIcon", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    
    class func DUSettingsIcon() -> UIImage {
        return UIImage(named:"setting", in: Bundle.du_messagingUIKitBundle , compatibleWith: nil)!
    }
    /**
        Return an UIImage instance with size 1.0 * 1.0 of given background UIColor
     */
    class func imageWith(backgroundColor color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    func masked(withColor color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var maskedImage: UIImage! = nil
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        
        context?.clip(to: imageRect, mask: self.cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(imageRect)
        
        maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
}


public extension NSAttributedString {
    class func DUDeliverWarningAttributed(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSFontAttributeName : UIFont.DUMessageTimeLabelFont(), NSForegroundColorAttributeName : UIColor.DUWarnigColor()])
    }
}

public extension UIView {
    /// Add NSLayoutConstraints to make subview as same as current view in size
    func pingAlledge(ofSubview subview: UIView) {
        self.ping(subview: subview, toEdge: .top)
        self.ping(subview: subview, toEdge: .leading)
        self.ping(subview: subview, toEdge: .bottom)
        self.ping(subview: subview, toEdge: .trailing)
    }
    /// Ping one edge of subview with given attribut onto current view's edge
    func ping(subview:UIView, toEdge attribute: NSLayoutAttribute) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0.0))
    }
}

public extension String {
    /**
     Return a `String` object with all white all spaces trimmed
     
     - returns: Trimmed String
     */
    func du_trimingWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    /**
     Calculate the minimum rectangle which contains the given text, with given width and font.
     
     - parameter width: The maximum width of the text.
     - parameter font:  UIFont of the text
     
     - returns: A CGRect structure of calculated result.
     */
    func rectWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingRect.integral
    }
    
    /**
     To verify if this string is a valid HTTP URL
     
     - returns: A Bool to indicate if this is a HTTP URL
     */
    func isValidURL() -> Bool {
        let urlRegEx = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [urlRegEx])
        return predicate.evaluate(with: self)
    }
}

public extension NSObject {
    /// Return class string
    public class var nameOfClass: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    /// Return dynamic type string of the instance
    public var nameOfClass: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}


public extension URL {
    /**
     Get complete asset file name, e.g. 'image1.jpg'
     
     - returns: A String of complte file name.
     */
    func getAssetFullFileName() -> String? {
        guard self.scheme == "assets-library" else {
            return nil
        }
        let absoluePath = self.absoluteString
        let idRange = absoluePath.range(of: "id=")
        let extRange = absoluePath.range(of: "&ext=")
        let fileName = absoluePath.substring(with: idRange!.upperBound..<extRange!.lowerBound)
        let ext = absoluePath.substring(with: extRange!.upperBound..<absoluePath.endIndex)
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
        let extRange = absoluePath.range(of: "&ext=")
        return absoluePath.substring(with: extRange!.upperBound..<absoluePath.endIndex)
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
        let idRange = absoluePath.range(of: "id=")
        let extRange = absoluePath.range(of: "&ext=")
        return absoluePath.substring(with: idRange!.upperBound..<extRange!.lowerBound)
    }
}

public extension Int {
    var convertedByteSizeString: String {
        var convertedValue = Double(self)
        var multiplyFactor = 0
        let sizeUnits = ["bytes", "KB", "MB", "GB", "TB"]
        
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        
        return String(format: "%4.2f\(sizeUnits[multiplyFactor])", convertedValue)
    }
}

public extension Bundle {
    static var du_messagingUIKitBundle: Bundle {
        return Bundle(for: DUMessagesViewController.classForCoder())
    }
}



