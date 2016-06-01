//
//  DUChatProtocol.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/28.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

/// Data source for disaplaying chat info for chat list and chat settings
public protocol DUChatData: DUImageResource {
    var hasUnreadMessage: Bool { get }
    var avatarPlaceholderImage: UIImage { get }
    var chatTitle: String { get }
    var chatDetailText: String { get }
    var chatAccessoryText: String { get }
    var chatSettingPageType: DUChatType { get }
    var chatMembers: [String] { get }
}

// MARK: Default behavior 

/// Use default setting to link data with UI elements
///     meta["name"] -> chatTitleLabel
///     lastMessage  -> chatDetailLaabel
///     meta["url"]  -> chatAvatarImageView; otherwise will be uppercased first letter
extension DUChat: DUChatData {
    public var imagePath: String { return self.meta!["url"] as? String ?? "" }
    /// if chat room type is Direct, placeholer will be a person avatar; otherwise will be text avatar of uppercase initial
    public var placeholderImage: UIImage {
        switch self.type {
        case .Direct:
            return UIImage.DUDefaultPersonAvatarImage()
        default:
            return DUAvatarImageFactory.avatarImageWithString(String(self.chatTitle[chatTitle.startIndex]).uppercaseString, font: UIFont.DUChatAvatarFont()!, diameter: DUAvatarImageFactory.kAvataImageDefaultDiameterInChatsList)!
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
}