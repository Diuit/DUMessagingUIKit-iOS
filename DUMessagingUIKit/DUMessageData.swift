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
    /// The users who have read this message. Return nil if you do not need this feature.
    var reads: [String]? { get }
}

// Make DUMessage conform to DUMessageData
extension DUMessage: DUMessageData, DUImageResource {
    public var imagePath: String? { return mediaItem?.mediaSourceURL ?? nil }
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
    
    public var isMediaMessage: Bool {
        // no MIME type will be regarded as text message
        guard self.mime != nil else {
            return true
        }
        
        // if MIME is not Media message but content text is an URL, return true (web mediat message)
        switch self.mime! {
        case DUMIMEType.textPlain:
            if let _ = contentText {
                return (contentText!.isValidURL())
            }
            return false
        case DUMIMEType.system:
            return false
        case DUMIMEType.imageBMP, DUMIMEType.imageGIF, DUMIMEType.imageJPG, DUMIMEType.imagePNG, DUMIMEType.imageTIFF:
            return true
        // FIXME: general file is now regarded as text message
        case DUMIMEType.general:
            return true
        default:
            if let _ = contentText {
                return (contentText!.isValidURL())
            }
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
            case DUMIMEType.textPlain:
                if let _ = contentText {
                    return (contentText!.isValidURL()) ? DUMediaItem.init(fromURL: contentText!) : nil
                }
                return nil
            case DUMIMEType.system:
                return nil
            case DUMIMEType.imageBMP, DUMIMEType.imageGIF, DUMIMEType.imageJPG, DUMIMEType.imagePNG, DUMIMEType.imageTIFF:
                if self.localImage != nil {
                    return DUMediaItem.init(fromImage: self.localImage!)
                } else {
                    // FIXME: is it possible to load image source here and trigger collecion view reload here?
                    // Because i don't know how to do it yet, set nil here and load image in `DUCollectionViewDataSource`
                    if let content = self.data {
                        if content.isValidURL() { return DUMediaItem.init(fromImageURL: content) }
                        else { return DUMediaItem.init(fromImage: nil) }
                    } else {
                        return DUMediaItem.init(fromImage: nil)
                    }
                }
            // FIXME: file is broken
            case DUMIMEType.general:
                if self.status == .Delivered || self.status == .Received {
                    let fileName: String = self.meta?["name"] as? String ?? "Unnamed file"
                    let fileDesc: String = self.meta?["description"] as? String ?? "No description"
                    return DUMediaItem.init(fromFileURL: self.data!, fileName: fileName, fileDescription: fileDesc)
                } else {
                    return DUMediaItem.init(fromFileURL: "", fileName: "", fileDescription: "")
                }
            default:
                if let _ = contentText {
                    return (contentText!.isValidURL()) ? DUMediaItem.init(fromURL: contentText!) : nil
                }
                return nil
            }
        }
        set {
            
        }
    }
    public var contentText: String? { return self.data }
    override public var hashValue: Int { return messageID.hashValue }
}
