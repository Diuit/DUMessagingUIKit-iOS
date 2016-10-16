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
        dismissKeyboard()
    }
    
    override func didTap(messageCollectionView view: DUMessageCollectionView) {
        print("did tap message collectionview")
        dismissKeyboard()
    }

    override func didClick(rightBarButton: UIBarButtonItem?) {
        self.performSegue(withIdentifier: "toSettingSegue", sender: nil)
    }

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableRefreshControl = false
        // cast chat data to get last message
        let chatModel = self.chat as! MockChatModel
        self.messageData = chatModel.messageDatas
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.endReceivingMessage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DemoChatSettingViewController {
            vc.chatDataForSetting = self.chat
        }
    }
}

// MARK: UIImagePickerDelegate
extension DemoMessagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageURL = info[UIImagePickerControllerReferenceURL] as! URL
        var meta:[String: AnyObject] = [String:AnyObject]()
        
        if let imageName = imageURL.getAssetFullFileName() {
            print("choose image name: \(imageName)")
            meta["name"] = imageName as AnyObject
        } else {
            meta["name"] = "Unnamed image" as AnyObject
        }
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true) {
            let newMessage = MockMessageModel(image: image, isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
    }
}

// MARK: private methods
private extension DemoMessagesViewController {
    func dismissKeyboard() {
        guard inputToolbar.contentView?.inputTextView != nil else {
            return
        }
        
        if inputToolbar.contentView!.inputTextView.isFirstResponder {
            inputToolbar.contentView!.inputTextView.resignFirstResponder()
        }
    }
    
    // present action sheet
    func presentActionSheet() {
        let actionController = UIAlertController.init(title: NSLocalizedString("MEDIA_MESSAGE", comment: "Media message"), message: NSLocalizedString("CHOOSE_TO_DEMO", comment: "Choose to demo"), preferredStyle: .actionSheet)
        
        let sendImageAction = UIAlertAction.init(title: NSLocalizedString("SEND_IMAGE", comment: "Send image"), style: .default){ [unowned self] action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                print("Read album error!")
            }
        }
        
        let sendVideoAction = UIAlertAction.init(title: NSLocalizedString("SEND_VIDEO", comment: "Send video"), style: .default){ [unowned self] action in
            let newMessage = MockMessageModel(videoURL: "file://", previewImage: UIImage(named: "videoThumbnail"), isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendURLAction = UIAlertAction.init(title: NSLocalizedString("SEND_LINK", comment: "Send a link"), style: .default){ [unowned self] action in
            let newMessage = MockMessageModel(url: "http://www.nytimes.com/2016/08/14/sports/olympics/michael-phelps-23-gold-medals-swimming-4x100-relay.html?_r=0", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let sendFileAction = UIAlertAction.init(title: NSLocalizedString("SEND_FILE", comment: "Send file"), style: .default){ [unowned self] action in
            let newMessage = MockMessageModel(fileURL: Bundle.main.path(forResource: "WWDC_419", ofType: "pdf")!, fileName: "WWDC_419.pdf", fileDescription: "Session 419 slide", isOutgoing: true)
            self.messageData.append(newMessage)
            self.endSendingMessage()
        }
        
        let dummyReceiving = UIAlertAction.init(title: NSLocalizedString("SIMULATE_RECEIVING", comment: "Simulate Receiving"), style: .default){ [unowned self] action in
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
            fakeReceivedMessage.date = Date()
            
            self.messageData.append(fakeReceivedMessage)
            
            // For showing typing indicator
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.endReceivingMessage()
            }
            
        }

        actionController.addAction(sendImageAction)
        actionController.addAction(sendVideoAction)
        actionController.addAction(sendURLAction)
        actionController.addAction(sendFileAction)
        actionController.addAction(dummyReceiving)
        actionController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel) { [unowned self] action in
            self.inputToolbar.contentView?.inputTextView.becomeFirstResponder()
        })
        
        self.present(actionController, animated: true, completion: nil)
    }

}
