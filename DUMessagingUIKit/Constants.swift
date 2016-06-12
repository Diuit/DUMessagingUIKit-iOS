//
//  Constants.swift
//  DUMessagingUI
//
//  Created by Pofat Tseng on 2016/5/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

public struct Constants {
    static let bundleIdentifier = "com.duolc.DUMessagingUIKit"
}


// Global Theme setting
public class GlobalUISettings {
    // navigation bar settings
    static var navBarTintColor: UIColor? = nil
    static var navBarTitleTextColof: UIColor = UIColor.DUWaterBlueColor()
    static var navBarTitleFont: UIFont = UIFont.DUNavigationFont()!
    
    // theme color
    static var tintColor: UIColor = UIColor.DUWaterBlueColor()
    static var indicatingStatusColor: UIColor = UIColor.DUWaterBlueColor()
    
    // Message bubble color
    static var outgoingMessageBubbleBackgroundColor: UIColor = UIColor.DUWaterBlueColor()
    static var incomingMessageBubbleBackgroundColor: UIColor = UIColor.DULightgreyColor()
}