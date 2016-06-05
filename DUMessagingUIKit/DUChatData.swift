//
//  DUChatProtocol.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/28.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

/**
    Data protocol for disaplaying chat information for list chats and setting

    - seealso `DUChatListProtocolForViewController`, `DUChatSettingViewController`
 */
public protocol DUChatData: DUImageResource {
    /// If this chat has unread message
    var hasUnreadMessage: Bool { get }
    /// User for avatar before completely loading the real image
    var avatarPlaceholderImage: UIImage { get }
    /// Title for a chat room, will be displayed in chatTitleLabel of DUChatCell
    var chatTitle: String { get }
    /// Detail text for a chat, will be the content of last message and displayed in chatDetailLabel of DUChatCell
    var chatDetailText: String { get }
    /// This text will be diaplayed in chatAccessoryLabel of DUChatCell
    var chatAccessoryText: String { get }
    /// Indicate if this chat is a group chat for DUChatSettingViewController to determine its displaying UI
    var chatSettingPageType: DUChatType { get }
    /// Members of this caht
    var chatMembers: [String] { get }
    /// Only availabe in a direct mesage chat room. Indicate if the opponent is blocke by current user
    var isBlocked: Bool { get }
}


// MARK: Default behavior 
/// extend DUChat to conform to DUChatData protocol
extension DUChat: DUChatData {
    public var imagePath: String? { return self.meta!["url"] as? String ?? "" }
    /// if chat room type is Direct, placeholer will be a person avatar; otherwise will be text avatar of uppercase initial
    public var placeholderImage: UIImage {
        switch self.type {
        case .Direct:
            return UIImage.DUDefaultPersonAvatarImage()
        default:
            return DUAvatarImageFactory.makeAvatarImage(String(self.chatTitle[chatTitle.startIndex]).uppercaseString, font: UIFont.DUChatAvatarFont()!, diameter: DUAvatarImageFactory.kAvataImageDefaultDiameterInChatsList)!
        }
    }
    public var hasUnreadMessage: Bool { return (self.unreadMessageCount > 0) }
    public var avatarPlaceholderImage: UIImage {
        return self.placeholderImage
    }
    public var chatTitle: String {
        if let m = self.meta {
            return (m["name"] ?? String(self.id)) as! String
        } else {
            return String(self.id)
        }
    }
    public var chatDetailText: String {
        return self.lastMessage?.data ?? ""
    }
    public var chatAccessoryText: String {
        return self.lastMessage?.createdAt?.messageTimeLabelString ?? ""
    }
    public var chatSettingPageType: DUChatType { return self.type }
    public var chatMembers: [String] { return self.members ?? [] }
    public var isBlocked: Bool { return self.isBlockedByMe }
}
