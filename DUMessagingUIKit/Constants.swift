//
//  Constants.swift
//  DUMessagingUI
//
//  Created by Pofat Tseng on 2016/5/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

/// Global Theme setting
open class GlobalUISettings {
    /// Navigation bar tint color
    open static var navBarTintColor: UIColor? = nil
    /// Navigation bar title text color
    static var navBarTitleTextColof: UIColor = UIColor.DUWaterBlueColor()
    /// Navigation bar title font
    static var navBarTitleFont: UIFont = UIFont.DUNavigationFont()
    
    /// Tint color for whole app
    static var tintColor: UIColor = UIColor.DUWaterBlueColor()
    static var indicatingStatusColor: UIColor = UIColor.DUWaterBlueColor()
    
    // Message bubble color
    open static var outgoingMessageBubbleBackgroundColor: UIColor = UIColor.DUWaterBlueColor()
    open static var outgoingMessageTextColor: UIColor = UIColor.white
    open static var incomingMessageBubbleBackgroundColor: UIColor = UIColor.DULightgreyColor()
    open static var incomingMessageTextColor: UIColor = UIColor.black
}

extension GlobalUISettings {
    /// This property can add extra bottom content inset to your message collection view, the default is 0.0
    public static var extraMessageCollectionViewBottomInset: CGFloat = 0.0
}
