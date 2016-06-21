//
//  DemoMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessagingUIKit
import DUMessaging

var id: Int = 0

class DemoMessagesViewController: DUMessagesViewController {
    
    override func didPressSendButton(sender: UIButton, withText: String) {
        let newMessage = messageModel(sendText: withText, isOutgoing: true, isMedia: false)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
    }
    
    override func didPressAccessorySendButton(sender: UIButton) {
        let newMessage = messageModel(sendText: "GG", isOutgoing: false, isMedia: true)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}


// FIXME: This is a test-only class, delete when test done
struct messageModel: DUMessageData {
    var senderIdentifier: String = "me"
    var senderDisplayName: String = "MySelf"
    var messageID: Int
    var isMediaMessage: Bool
    var mediaItem: DUMediaItem?
    var isOutgoingMessage: Bool
    var date: NSDate?
    var contentText: String?
    var hashValue: Int
    var duChatInstance: DUChat?
    
    init(sendText: String?, isOutgoing: Bool, isMedia: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = sendText
        hashValue = id.hashValue
        duChatInstance = nil
        isOutgoingMessage = isOutgoing
        isMediaMessage = isMedia
        if !isMedia {
            mediaItem = nil
        } else {
            //mediaItem = DUMediaItem.init(fromImage: UIImage(named: "dna"))
            mediaItem = DUMediaItem.init(fromURL: "https://onboardmag.com/videos/web-series/sixty-minute-sessions-karl-anton-svensson.html")
        }
    }
}
