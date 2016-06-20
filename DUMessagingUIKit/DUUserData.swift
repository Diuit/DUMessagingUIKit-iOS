//
//  DUUserData.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/6.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

/**
 Data protocol for displaying user information
 
 - Seealso `DUChatSettingViewController`
 */
public protocol DUUserData: DUImageResource {
    var userDisplayName: String { get }
    var userMeta: [String: AnyObject] { get }
}