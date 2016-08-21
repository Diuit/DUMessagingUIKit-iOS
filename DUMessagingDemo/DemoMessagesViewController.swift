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
    
    // MARK: click events to be overrided
    override func didPress(sendButton button: UIButton, withText: String) {
        self.messageData.append(MockMessageModel(text: withText, isOutgoing: true))
        self.endSendingMessage()
    }
    
    override func didPress(accessoryButton button: UIButton) {
        self.inputToolbar.contentView?.inputTextView.resignFirstResponder()
        presentActionSheet()
    }
    
    override func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print(" did tap avatar in demo app")
    }
    
    override func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print(" did tap bubble in demo app")
    }
    
    override func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print(" did tap cell in demo app")
    }

    override func didClickRightBarButton(sender: UIBarButtonItem?) {
        self.performSegueWithIdentifier("toSettingSegue", sender: nil)
    }

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableRefreshControl = true
        
        // cast chat data to get last message
        let chatModel = self.chat as! MockChatModel
        self.messageData = chatModel.messageDatas
        self.endReceivingMessage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DemoChatSettingViewController {
            vc.chatDataForSetting = self.chat
        }
    }
}

// MARK: private methods
private extension DemoMessagesViewController {
    // present action sheet
    
    func presentActionSheet() {
        let actionController = UIAlertController.init(title: NSLocalizedString("MEDIA_MESSAGE", comment: "Media message"), message: NSLocalizedString("CHOOSE_TO_DEMO", comment: "Choose to demo"), preferredStyle: .ActionSheet)
        
        let sendImageAction = UIAlertAction.init(title: NSLocalizedString("SEND_IMAGE", comment: "Send image"), style: .Default){ [unowned self] action in
            let newMessage = MockMessageModel(image: UIImage(named:"dna")!, isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendVideoAction = UIAlertAction.init(title: NSLocalizedString("SEND_VIDEO", comment: "Send video"), style: .Default){ [unowned self] action in
            let newMessage = MockMessageModel(videoURL: "file://", previewImage: UIImage(named: "videoThumbnail"), isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendURLAction = UIAlertAction.init(title: NSLocalizedString("SEND_LINK", comment: "Send a link"), style: .Default){ [unowned self] action in
            let newMessage = MockMessageModel(url: "http://www.nytimes.com/2016/08/14/sports/olympics/michael-phelps-23-gold-medals-swimming-4x100-relay.html?_r=0", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendFileAction = UIAlertAction.init(title: NSLocalizedString("SEND_FILE", comment: "Send file"), style: .Default){ [unowned self] action in
            let newMessage = MockMessageModel(fileURL: NSBundle.mainBundle().pathForResource("WWDC_419", ofType: "pdf")!, fileName: "WWDC_419.pdf", fileDescription: "Session 419 slide", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let dummyReceiving = UIAlertAction.init(title: NSLocalizedString("SIMULATE_RECEIVING", comment: "Simulate Receiving"), style: .Default){ [unowned self] action in
            self.displayTypingIndicator = true
            self.scrollToBottom(true)
            
            var fakeReceivedMessage: MockMessageModel
            
            if let lastMessage = self.messageData.last as? MockMessageModel {
                fakeReceivedMessage = lastMessage
                fakeReceivedMessage.messageID += 1
                fakeReceivedMessage.isOutgoingMessage = false
            } else {
                fakeReceivedMessage = MockMessageModel.init(text: "Hi, this is your first received message", isOutgoing: false)
            }
            fakeReceivedMessage.senderIdentifier = "her"
            fakeReceivedMessage.senderDisplayName = "Bot"
            fakeReceivedMessage.date = NSDate()
            
            self.messageData.append(fakeReceivedMessage)
            
            // For showing typing indicator
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.endReceivingMessage()
            }
            
        }

        actionController.addAction(sendImageAction)
        actionController.addAction(sendVideoAction)
        actionController.addAction(sendURLAction)
        actionController.addAction(sendFileAction)
        actionController.addAction(dummyReceiving)
        actionController.addAction(UIAlertAction.init(title: "Cancel", style: .Cancel) { [unowned self] action in
            self.inputToolbar.contentView?.inputTextView.becomeFirstResponder()
        })
        
        self.presentViewController(actionController, animated: true, completion: nil)
    }

}
