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
public protocol BackGroundColor   { var myBackgroundColor: UIColor { get } }
public protocol TintColor         { var myTintColor: UIColor       { get } }
public protocol MasksToBoundsTRUE {}
public protocol CornerRadius       { var du_CornerRadius: CGFloat   { get } }

public protocol CircleShapeView: CornerRadius {}
extension CircleShapeView where Self: UIView {
    var du_CornerRadius: CGFloat { return bounds.size.width/2 }
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
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: mySelf.rightBarButtonImage?.imageWithRenderingMode(.AlwaysOriginal) , style: .Plain, target: Self().self, action: nil)
            case .textButton:
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: mySelf.rightBarButtonText, style: .Plain, target: Self().self, action: nil)
            default:
                navigationItem.rightBarButtonItem = nil
            }
            
            if navigationItem.rightBarButtonItem != nil { // add click event
                navigationItem.rightBarButtonItem?.action = #selector(mySelf.didClickRightBarButton(_:))
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


// UIView
extension UIView: UIProtocolAdoption {
    public override func awakeFromNib() {
        super.awakeFromNib()
        adoptProtocolUIApperance()
    }
    
    public func adoptProtocolUIApperance() {
        
        // CALayer
        if let mySelf = self as? CornerRadius      { layer.cornerRadius  = mySelf.du_CornerRadius }
        if self is MasksToBoundsTRUE               { layer.masksToBounds = true }
        
        // UIView
        if let mySelf = self as? BackGroundColor   { backgroundColor    = mySelf.myBackgroundColor }
        if let mySelf = self as? TintColor         { tintColor          = mySelf.myTintColor }
    }
    
    public func setupInheritedProtocolUI() {
        // do nothing here
    }
}
