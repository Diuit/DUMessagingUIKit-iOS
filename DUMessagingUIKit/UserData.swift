//
//  UserData.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

/**
    This class conforms to protocol `DUUserData`, in order to display user information in `DUChatSettingViewController` correctly.
 */
struct UserData: DUUserData {
    /// The display name of the user
    var userDisplayName: String
    /// URL of user avatar image
    var imagePath: String?
    /// Placeholder image before the avatar is fully loaded
    var placeholderImage: UIImage
    /// Metadata of the user
    var userMeta: [String:AnyObject] = [:]

    init(name: String, imagePath: String?) {
        userDisplayName = name
        self.imagePath = imagePath
        let initial = name.substringToIndex(name.startIndex.advancedBy(1)).uppercaseString
        placeholderImage = DUAvatarImageFactory.makeAvatarImage(initial, backgroundColor: UIColor.DUAvatarBgDefaultColor(), textColor: UIColor.whiteColor(), font: UIFont.DUUnreadTitleFont()!, diameter: 32.0)!
    }
}