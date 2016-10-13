//
//  MockChatModel.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/8/15.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessagingUIKit
import DUMessaging

struct MockChatModel: DUChatData {
    var hasUnreadMessage: Bool = false
    var avatarPlaceholderImage: UIImage = UIImage(named: "botAvatar")!
    var chatTitle: String = "Demo Chat Room"
    var chatDetailText: String
    var chatAccessoryText: String
    var chatSettingPageType: DUChatType = .group
    var chatMembers: [String] = ["Bot", "myself"]
    var isBlocked: Bool = false
    var imagePath: String? = ""
    var messageDatas: [DUMessageData] = []
    
    init(withMessages messages: [DUMessageData]) {
        messageDatas = messages
        chatDetailText = messages[messages.count - 1].contentText ?? ""
        chatAccessoryText = messages[messages.count - 1].date?.messageTimeLabelString ?? ""
    }
    
}
