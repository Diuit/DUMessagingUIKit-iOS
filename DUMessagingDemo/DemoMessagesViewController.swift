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
        let newMessage = messageModel(text: withText, isOutgoing: true)
        self.messageData.append(newMessage)
        self.collectionView?.reloadData()
    }
    
    override func didPressAccessorySendButton(sender: UIButton) {
        self.inputToolbar.contentView?.inputTextView.resignFirstResponder()
        presentActionSheet()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}

private extension DemoMessagesViewController {
    
    func presentActionSheet() {
        let actionController = UIAlertController.init(title: "Media message", message: "Choose one to demo", preferredStyle: .ActionSheet)
        
        let sendImageAction = UIAlertAction.init(title: "Send image", style: .Default){ action in
            let newMessage = messageModel(image: UIImage(named:"dna")!, isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        }
        
        let sendVideoAction = UIAlertAction.init(title: "Send vidoe", style: .Default){ action in
            let newMessage = messageModel(videoURL: "file://", previewImage: UIImage(named: "videoThumbnail"), isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        }
        
        let sendURLAction = UIAlertAction.init(title: "Send a link", style: .Default){ action in
            let newMessage = messageModel(url: "https://onboardmag.com/videos/web-series/sixty-minute-sessions-karl-anton-svensson.html", isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        }
        
        let sendFileAction = UIAlertAction.init(title: "Send a file", style: .Default){ action in
            let newMessage = messageModel(fileURL: NSBundle.mainBundle().pathForResource("WWDC_419", ofType: "pdf")!, fileName: "WWDC_419.pdf", fileDescription: "Session 419 slide", isOutgoing: true)
            self.messageData.append(newMessage)
            self.collectionView?.reloadData()
        }
        
        actionController.addAction(sendImageAction)
        actionController.addAction(sendVideoAction)
        actionController.addAction(sendURLAction)
        actionController.addAction(sendFileAction)
        actionController.addAction(UIAlertAction.init(title: "Cancel", style: .Cancel) { [unowned self] action in
            self.inputToolbar.contentView?.inputTextView.becomeFirstResponder()
        })
        
        self.presentViewController(actionController, animated: true, completion: nil)
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
    
    init(text: String?, isOutgoing: Bool) {
        messageID = id
        id += 1
        date = NSDate()
        contentText = text
        hashValue = id.hashValue
        duChatInstance = nil
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
        duChatInstance = nil
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
        duChatInstance = nil
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
        duChatInstance = nil
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
        duChatInstance = nil
        isOutgoingMessage = isOutgoing
        isMediaMessage = true
        mediaItem = DUMediaItem.init(fromVideoURL: videoURL, withPreviewImage: previewImage)
    }
}
