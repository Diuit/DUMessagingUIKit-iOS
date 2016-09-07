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
    static var navBarTintColor: UIColor? = nil
    /// Navigation bar title text color
    static var navBarTitleTextColof: UIColor = UIColor.DUWaterBlueColor()
    /// Navigation bar title font
    static var navBarTitleFont: UIFont = UIFont.DUNavigationFont()
    
    /// Tint color for whole app
    static var tintColor: UIColor = UIColor.DUWaterBlueColor()
    static var indicatingStatusColor: UIColor = UIColor.DUWaterBlueColor()
    
    // Message bubble color
    static var outgoingMessageBubbleBackgroundColor: UIColor = UIColor.DUWaterBlueColor()
    static var outgoingMessageTextColor: UIColor = UIColor.whiteColor()
    static var incomingMessageBubbleBackgroundColor: UIColor = UIColor.DULightgreyColor()
    static var incomingMessageTextColor: UIColor = UIColor.blackColor()
}