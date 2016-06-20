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
    /// An integer id which specifies the message.
    var messageID: Int { get }
    /// An unique string identifier of the user who sent the message
    var senderIdentifier: String { get }
    /// The display name of the sender
    var senderDisplayName: String { get }
    /// The NSDate instance indicating when the message created.
    var date: NSDate? { get }
    /// If this message is a media message.
    var isMediaMessage: Bool { get }
    /// Return an instance of `DUMediaItem` if this is a mediat message.
    var mediaItem: DUMediaItem? { get set }
    /// If this message is sent by self.
    var isOutgoingMessage: Bool { get }
    /// Content text of a text message.
    var contentText: String? { get }
    /// Hash value for message layout cache.
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
    public var isMediaMessage: Bool {
        // no MIME type will be regarded as text message
        guard self.mime != nil else {
            return true
        }
        switch self.mime! {
        case DUMIMEType.textPlain, DUMIMEType.system:
            return false
        case DUMIMEType.imageBMP, DUMIMEType.imageGIF, DUMIMEType.imageJPG, DUMIMEType.imagePNG, DUMIMEType.imageTIFF:
            return true
        // FIXME: general file is now regarded as text message
        case DUMIMEType.general:
            return false
        default:
            return false
        }
    }
    public var mediaItem: DUMediaItem? {
        get {
            // no MIME type will be regarded as text message
            guard self.mime != nil else {
                return nil
            }
            
            switch self.mime! {
            case DUMIMEType.textPlain, DUMIMEType.system:
                return nil
            case DUMIMEType.imageBMP, DUMIMEType.imageGIF, DUMIMEType.imageJPG, DUMIMEType.imagePNG, DUMIMEType.imageTIFF:
                return DUMediaItem.init(fromImage: nil)
            // FIXME: general file is now regarded as text message
            case DUMIMEType.general:
                return nil
            default:
                return nil
            }
        }
        set {
            
        }
    }
    public var contentText: String? { return self.data }
    override public var hashValue: Int { return messageID.hashValue }
}
