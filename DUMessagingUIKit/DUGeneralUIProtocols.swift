//
//  DUGeneralUIProtocols.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/27.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

// UIView
public protocol BackGroundColor { var myBackgroundColor: UIColor { get } }
public protocol TintColor       { var myTintColor: UIColor       { get } }

// UIBarButton
public enum UIBarButtonType {
    case imageButton, textButton, noButton
}

public protocol BarButton {
    var myBarButtonType: UIBarButtonType { get }
}
public protocol RightBarButton: BarButton {
    var rightBarButtonImage: UIImage? { get }
    var rightBarButtonText: String? { get }
    var didClickRightBarButton: Void->Void { get }
}


// UINavigationBar
public protocol NavigationBarStyle {
    var myBarTintColor: UIColor? { get }
    var myNavigationBarTextColor: UIColor { get }
    var myNavigationBartTextFont: UIFont { get }
}

public protocol NavigationBarTitle {
    var myBarTitle: String { get }
}

// method to adopt ui protocol
public protocol UIProtocolAdoption {
    func adoptProtocolUIApperance()
}

// Global UI with default setting
public protocol GlobalUISetting: NavigationBarStyle, TintColor {}
// FIXME: global setting value should return from an sharedInstance struct (or class?)
public extension GlobalUISetting {
    var myBarTintColor: UIColor? { return nil }
    var myNavigationBarTextColor: UIColor { return UIColor.DUWaterBlueColor() }
    var myNavigationBartTextFont: UIFont { return UIFont.DUNavigationFont()! }
    
    var myTintColor: UIColor { return UIColor.DUWaterBlueColor() }
}


public protocol GlobalTheme: TintColor, NavigationBarStyle { }
public extension GlobalTheme {
    var myTintColor: UIColor { return UIColor.DUWaterBlueColor() }
    
    var myBarTintColor: UIColor? { return nil }
    
    var myNavigationBarTextColor: UIColor { return UIColor.DUWaterBlueColor() }
    // FIXME: delete later
    var myNavigationBartTextFont: UIFont { return UIFont.DUNavigationFont()! }
}

// TODO: this may be unneccesary?
public extension UIApplicationDelegate {
    func adoptGlobalUIApperance() {
        if let mySelf = self as? GlobalTheme {
            window??.tintColor = mySelf.myTintColor
            UINavigationBar.appearance().barTintColor = mySelf.myBarTintColor
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: mySelf.myNavigationBarTextColor]
        }
    }
}
/*
extension UIView: DUMessagingUIProtocol {
    public override func awakeFromNib() {
        super.awakeFromNib()
        adoptProtocolUIApperance()
    }
    
    public func adoptProtocolUIApperance() {
        if let mySelf = self as? BackGroundColor { backgroundColor = mySelf.myBackgroundColor }
        if let mySelf = self as? TintColor       { tintColor       = mySelf.myTintColor       }
    }
}
 */

// FIXME: when do we use it?
/*
extension UINavigationBar {
    override public func adoptProtocolUIApperance() {
        super.adoptProtocolUIApperance()
        
        if let mySelf = self as? BackGroundColor { barTintColor = mySelf.myBackgroundColor }
        if let mySelf = self as? NavigationBarStyle {
            barTintColor = mySelf.myBarTintColor
            topItem?.title = mySelf.myNavigationBarTitle
        }
    }
}
 */


