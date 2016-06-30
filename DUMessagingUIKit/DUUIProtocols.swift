//
//  DUGeneralUIProtocols.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/27.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

// MARK: UI properties
// UIView-related protocols
public protocol BackgroundColor   { var myBackgroundColor: UIColor { get } }
public protocol TintColor         { var myTintColor: UIColor       { get } }
public protocol BorderWidth       { var myBorderWidth: CGFloat     { get } }
public protocol BorderColor       { var myBorderColor: UIColor     { get } }
public protocol MasksToBoundsTRUE {}
public protocol CornerRadius      { var myCornerRadius: CGFloat   { get } }

public protocol CircleShapeView: CornerRadius, MasksToBoundsTRUE {}
extension CircleShapeView where Self: UIView {
    public var myCornerRadius: CGFloat { return bounds.size.width/2 }
}

// UIBarButton
public enum UIBarButtonType {
    case imageButton, textButton, noButton
}
@objc public protocol BarButtonReaction {
    func didClickRightBarButton(sender: UIBarButtonItem?)
}
public protocol BarButton {
    var myBarButtonType: UIBarButtonType { get }
}
public protocol RightBarButton: BarButton, BarButtonReaction {
    var rightBarButtonImage: UIImage? { get }
    var rightBarButtonText: String? { get }
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

// MARK: UI adoption
/// Method to adopt ui protocol
public protocol UIProtocolAdoption {
    func setupInheritedProtocolUI()
    func adoptProtocolUIApperance()
}

// UIViewController
public extension UIProtocolAdoption where Self: UIViewController {
    /// Build parent UI protocols, do this first in adoptProtocolUI()
    func setupInheritedProtocolUI() {
        // NavigationBar
        if let mySelf = self as? NavigationBarStyle {
            navigationController?.navigationBar.barTintColor = mySelf.myBarTintColor
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: mySelf.myNavigationBarTextColor, NSFontAttributeName: mySelf.myNavigationBartTextFont]
        }
        if let mySelf = self as? NavigationBarTitle { navigationItem.title = mySelf.myBarTitle }
        if let mySelf = self as? RightBarButton {
            switch mySelf.myBarButtonType {
            case .imageButton:
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: mySelf.rightBarButtonImage?.imageWithRenderingMode(.AlwaysOriginal) , style: .Plain, target: self, action: #selector(mySelf.didClickRightBarButton(_:)))
            case .textButton:
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: mySelf.rightBarButtonText, style: .Plain, target: self, action: #selector(mySelf.didClickRightBarButton(_:)))
            default:
                navigationItem.rightBarButtonItem = nil
            }
            
        }
        // TintColor
        if let mySelf = self as? TintColor {
            UIApplication.sharedApplication().delegate?.window??.tintColor = mySelf.myTintColor
            navigationItem.rightBarButtonItem?.tintColor = mySelf.myTintColor
        }
    }
}

/// Global UI with default setting
public protocol GlobalUIProtocol: NavigationBarStyle, TintColor {}
public extension GlobalUIProtocol where Self: UIViewController {
    var myBarTintColor: UIColor? { return GlobalUISettings.navBarTintColor }
    var myNavigationBarTextColor: UIColor { return GlobalUISettings.navBarTitleTextColof }
    var myNavigationBartTextFont: UIFont { return GlobalUISettings.navBarTitleFont }
    
    var myTintColor: UIColor { return GlobalUISettings.tintColor }
}

// MARK: Aggregate UI protocol
/**
 *  UI style for placehold view of media messages.
 */
public protocol PlaceholderStyle: BackgroundColor, BorderWidth, CornerRadius, BorderColor, MasksToBoundsTRUE {}
public extension PlaceholderStyle {
    public var myBackgroundColor: UIColor { return UIColor.DULightgreyColor() }
    public var myBorderWidth: CGFloat     { return 1.0 }
    public var myCornerRadius: CGFloat    { return 14.0 }
    public var myBorderColor: UIColor     { return UIColor.DULightgreyColor() }
}

/**
 *  UI style for content UIView of media messages.
 */
public protocol MediaContentStyle: BackgroundColor, CornerRadius, MasksToBoundsTRUE {}
extension MediaContentStyle {
    public var myBackgroundColor: UIColor { return UIColor.DULightgreyColor() }
    public var myCornerRadius: CGFloat    { return 14.0 }
}

public protocol URLMediaContentStyle: MediaContentStyle, BorderWidth, BorderColor {}
extension URLMediaContentStyle {
    public var myBorderColor: UIColor     { return UIColor.DULightgreyColor() }
    public var myBorderWidth: CGFloat     { return 1.0 }
    public var myBackgroundColor: UIColor { return UIColor.whiteColor() }
}

// MARK: adoption method for ecah UIKit
extension UIView: UIProtocolAdoption {
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        adoptProtocolUIApperance()
    }
    
    public func adoptProtocolUIApperance() {
        // UIView
        if let mySelf = self as? BackgroundColor   { backgroundColor       = mySelf.myBackgroundColor }
        if let mySelf = self as? TintColor         { tintColor             = mySelf.myTintColor   }
        if let mySelf = self as? BorderWidth       { layer.borderWidth     = mySelf.myBorderWidth }
        if let mySelf = self as? BorderColor       { layer.borderColor     = mySelf.myBorderColor.CGColor }
        if let mySelf = self as? CornerRadius      { layer.cornerRadius    = mySelf.myCornerRadius}
        if self is MasksToBoundsTRUE               { layer.masksToBounds = true }
        
    }
    
    public func setupInheritedProtocolUI() {
        // do nothing for UIView
    }
    public override func prepareForInterfaceBuilder() {
        adoptProtocolUIApperance()
    }
}
