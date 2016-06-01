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
}

@objc public protocol BarButtonReaction {
    func didClickRightBarButton(sender: UIBarButtonItem?)
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
public protocol GlobalUIProtocol: NavigationBarStyle, TintColor {}
public extension GlobalUIProtocol {
    var myBarTintColor: UIColor? { return GlobalUISettings.navBarTintColor }
    var myNavigationBarTextColor: UIColor { return GlobalUISettings.navBarTitleTextColof }
    var myNavigationBartTextFont: UIFont { return GlobalUISettings.navBarTitleFont }
    
    var myTintColor: UIColor { return GlobalUISettings.tintColor }
}



