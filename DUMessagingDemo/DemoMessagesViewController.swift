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
        let newMessage = messageModel(sendText: withText, isOutgoing: true)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
    }
    
    override func didPressAccessorySendButton(sender: UIButton) {
        self.inputToolbar.contentView?.inputTextView.resignFirstResponder()
        
        let actionSheet = UIActionSheet.init(title: "Meida messages", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send image", "Send URL")
        actionSheet.showFromToolbar(self.inputToolbar)
        /*
        let newMessage = messageModel(sendText: "GG", isOutgoing: false, isMedia: true)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
 */
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}

extension DemoMessagesViewController: UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == actionSheet.cancelButtonIndex {
            self.inputToolbar.contentView?.inputTextView.becomeFirstResponder()
            return
        }
        
        switch buttonIndex {
        case 1:
            let newMessage = messageModel(sendImage: UIImage(named:"dna")!, isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        case 2:
            let newMessage = messageModel(sendURL: "https://onboardmag.com/videos/web-series/sixty-minute-sessions-karl-anton-svensson.html", isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        default:
            return
        }
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
    
    init(sendText: String?, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = sendText
        hashValue = id.hashValue
        duChatInstance = nil
        isOutgoingMessage = isOutgoing
        isMediaMessage = false
        mediaItem = nil
    }
    
    init(sendURL: String, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        duChatInstance = nil
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromURL: sendURL)
    }
    
    init(sendImage: UIImage, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = nil
        hashValue = id.hashValue
        duChatInstance = nil
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromImage: sendImage)
    }
}
