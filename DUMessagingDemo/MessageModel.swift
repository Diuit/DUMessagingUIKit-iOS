//
//  MessageModel.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/30.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessagingUIKit
import DUMessaging


// FIXME: This is a test-only class, delete when test done
struct MessageModel: DUMessageData {
    var senderIdentifier: String = "me"
    var senderDisplayName: String = "MySelf"
    var messageID: Int
    var isMediaMessage: Bool
    var mediaItem: DUMediaItem?
    var isOutgoingMessage: Bool
    var date: NSDate?
    var contentText: String?
    var hashValue: Int
    var reads: [String]? = ["1"]
    
    init(text: String?, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = text
        hashValue = id.hashValue
        isOutgoingMessage = isOutgoing
        isMediaMessage = false
        mediaItem = nil
    }
    
    init(url: String, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromURL: url)
    }
    
    init(image: UIImage, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromImage: image)
    }
    
    init(fileURL: String, fileName: String, fileDescription: String?, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromFileURL: fileURL, fileName: fileName, fileDescription: fileDescription)
    }
    
    init(videoURL: String, previewImage: UIImage?, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromVideoURL: videoURL, withPreviewImage: previewImage)
    }
}