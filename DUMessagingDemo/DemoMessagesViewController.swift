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
        if let du_chat = self.chat as? DUChat {
            du_chat.sendText(withText, beforeSend: { [weak self] message in
                self?.messageData.append(message)
                self?.endSendingMessage()
            }) { [weak self] error, message in
                self?.collectionView?.reloadData()
            }
        }
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
        if let c = self.chat as? DUChat {
            c.listMessages() { [weak self] error, messages in
                for message: DUMessage in messages! {
                    self?.messageData.insert(message, atIndex: 0)
                }
                self?.endReceivingMessage()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DemoChatSettingViewController {
            vc.chatDataForSetting = self.chat
        }
    }
}


extension DemoMessagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        var meta:[String: AnyObject] = [String:AnyObject]()
        
        if let imageName = imageURL.getAssetFullFileName() {
            print("choose image name: \(imageName)")
            meta["name"] = imageName
        }

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        })
        
        let newMessage = MessageModel.init(image: image, isOutgoing: true)
        self.messageData.append(newMessage)
        self.endSendingMessage()
    }
}

// MARK: private methods
private extension DemoMessagesViewController {
    // present action sheet
    func presentActionSheet() {
        let actionController = UIAlertController.init(title: "Media message", message: "Choose one to demo", preferredStyle: .ActionSheet)
        
        let sendImageAction = UIAlertAction.init(title: "Send image", style: .Default){ [unowned self] action in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("Read album error!")
            }
        }
        
        actionController.addAction(sendImageAction)
        actionController.addAction(UIAlertAction.init(title: "Cancel", style: .Cancel) { [unowned self] action in
            self.inputToolbar.contentView?.inputTextView.becomeFirstResponder()
            })
        
        self.presentViewController(actionController, animated: true, completion: nil)
        
        
    }
    
    /*
    func presentActionSheet() {
        let actionController = UIAlertController.init(title: "Media message", message: "Choose one to demo", preferredStyle: .ActionSheet)
        
        let sendImageAction = UIAlertAction.init(title: "Send image", style: .Default){ [unowned self] action in
            let newMessage = MessageModel(image: UIImage(named:"dna")!, isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendVideoAction = UIAlertAction.init(title: "Send vidoe", style: .Default){ [unowned self] action in
            let newMessage = MessageModel(videoURL: "file://", previewImage: UIImage(named: "videoThumbnail"), isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendURLAction = UIAlertAction.init(title: "Send a link", style: .Default){ [unowned self] action in
            let newMessage = MessageModel(url: "https://onboardmag.com/videos/web-series/sixty-minute-sessions-karl-anton-svensson.html", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendFileAction = UIAlertAction.init(title: "Send a file", style: .Default){ [unowned self] action in
            let newMessage = MessageModel(fileURL: NSBundle.mainBundle().pathForResource("WWDC_419", ofType: "pdf")!, fileName: "WWDC_419.pdf", fileDescription: "Session 419 slide", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let dummyReceiving = UIAlertAction.init(title: "Simulate receiving message", style: .Default){ [unowned self] action in
            self.displayTypingIndicator = true
            self.scrollToBottom(true)
            
            var fakeReceivedMessage: MessageModel
            
            if let lastMessage = self.messageData.last as? MessageModel {
                fakeReceivedMessage = lastMessage
                fakeReceivedMessage.messageID += 1
                fakeReceivedMessage.isOutgoingMessage = false
            } else {
                fakeReceivedMessage = MessageModel.init(text: "Hi, this is your first received message", isOutgoing: false)
            }
            fakeReceivedMessage.senderIdentifier = "her"
            fakeReceivedMessage.senderDisplayName = "Jessica"
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
 */
}
