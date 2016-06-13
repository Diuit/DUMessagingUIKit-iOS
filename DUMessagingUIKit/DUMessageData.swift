//
//  DUMessageData.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/6.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

/**
    `DUMessageData` protocol defines the interface between your message data source objects and `DUMessagesViewController`.
    
    You must implement all interfaces to correctly display messages within a `DUMessageCollectionViewCell`
 */
public protocol DUMessageData {
    /// - returns: An integer id which specifies the message.
    var messageID: Int { get }
    /// - returns: An unique string identifier of the user who sent the message
    var senderIdentifier: String { get }
    /// - returns: The display name of the sender
    var senderDisplayName: String { get }
    /// - returns: The NSDate instance indicating when the message created
    var date: NSDate? { get }
    /// - returns: If this message is a media message.
    var isMediaMessage: Bool { get }
    /// - returns: If this message is sent by self.
    var isOutgoingMessage: Bool { get }
    /// - returns: Content text of a text message.
    var contentText: String? { get }
    /// - returns: Hash value for message layout cache.
    var hashValue: Int { get }
}

extension DUMessage: DUMessageData {
    public var messageID: Int { return self.id }
    public var senderIdentifier: String { return self.senderUser?.serial ?? "Diuit-System-Sender" }
    public var senderDisplayName: String {
        if let meta = self.senderUser?.meta {
            return meta["name"] as? String ?? senderUser!.serial
        } else {
            return "System"
        }
    }
    public var date: NSDate? { return self.createdAt }
    // FIXME: use MIMEType struct
    public var isMediaMessage: Bool { return false }
    public var contentText: String? { return self.data }
    override public var hashValue: Int { return messageID.hashValue }
}
