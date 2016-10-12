//
//  Constants.swift
//  DUMessagingUI
//
//  Created by Pofat Tseng on 2016/5/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

/// Global Theme setting
public class GlobalUISettings {
    /// Navigation bar tint color
    public static var navBarTintColor: UIColor? = nil
    /// Navigation bar title text color
    static var navBarTitleTextColof: UIColor = UIColor.DUWaterBlueColor()
    /// Navigation bar title font
    static var navBarTitleFont: UIFont = UIFont.DUNavigationFont()
    
    /// Tint color for whole app
    static var tintColor: UIColor = UIColor.DUWaterBlueColor()
    static var indicatingStatusColor: UIColor = UIColor.DUWaterBlueColor()
    
    // Message bubble color
    public static var outgoingMessageBubbleBackgroundColor: UIColor = UIColor.DUWaterBlueColor()
    public static var outgoingMessageTextColor: UIColor = UIColor.whiteColor()
    public static var incomingMessageBubbleBackgroundColor: UIColor = UIColor.DULightgreyColor()
    public static var incomingMessageTextColor: UIColor = UIColor.blackColor()
}

extension GlobalUISettings {
    /// This property can add extra bottom content inset to your message collection view, the default is 0.0
    public static var extraMessageCollectionViewBottomInset: CGFloat = 0.0
}