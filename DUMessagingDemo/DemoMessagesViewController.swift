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
        let newMessage = messageModel(sendText: withText)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}


// FIXME: This is a test-only class, delete when test done
class messageModel: DUMessageData {
    var senderIdentifier: String = "me"
    var senderDisplayName: String = "MySelf"
    var messageID: Int
    var isMediaMessage: Bool { return false }
    var isOutgoingMessage: Bool { return true }
    var date: NSDate?
    var contentText: String?
    var hashValue: Int
    var duChatInstance: DUChat?
    
    init(sendText: String) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = sendText
        hashValue = id.hashValue
        duChatInstance = nil
    }
}
