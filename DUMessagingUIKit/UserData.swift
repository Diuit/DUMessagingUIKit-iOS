//
//  UserData.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation

class UserData: DUUserData {
    var displayName: String
    var imagePath: String?
    var placeholderImage: UIImage

    init(name: String, imagePath: String?) {
        displayName = name
        self.imagePath = imagePath
        let initial = name.substringToIndex(name.startIndex.advancedBy(1)).uppercaseString
        placeholderImage = DUAvatarImageFactory.makeAvatarImage(initial, backgroundColor: UIColor.DUAvatarBgDefaultColor(), textColor: UIColor.whiteColor(), font: UIFont.DUUnreadTitleFont()!, diameter: 32.0)!
    }
}