//
//  DUMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessagesViewController: UIViewController, UITextViewDelegate, DUMessagInputToolbarDelegate, DUMessagesUIProtocol, DUMessageCollectionViewFlowLayoutDelegate, DUMessageCollectionViewDataSource, DUMessageCollectionViewCellDelegate {
    
    @IBOutlet weak var inputToolbar: DUMessageInputToolbar!
    @IBOutlet public weak var collectionView: DUMessageCollectionView?
    
    public var messageData: [DUMessageData] = []
    
    private let outgoingCellIdentifier = DUMessageOutGoingCollectionViewCell.cellReuseIdentifier
    private let incomingCellIdentifier = DUMessageIncomingCollectionViewCell.cellReuseIdentifier
    // Defualt bubble images
    private let defaultOutgoingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(GlobalUISettings.outgoingMessageBubbleBackgroundColor)
    private let defaultIncomingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(GlobalUISettings.incomingMessageBubbleBackgroundColor)
    // Default avatar images cache, an easy way
    private var avatarImageCache: [String: UIImage] = [:]
    // Cache for cell top label. The first message of the date will have its cell top label display the date. Still this is an easy way.
    private var theseDatesHaveMessagesCache: [String] = []


    // MARK: Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        DUMessagesViewController.nib.instantiateWithOwner(self, options: nil)
        setupMessagesViewController()

    }
    
    deinit {
        collectionView?.delegate = nil
        collectionView?.dataSource = nil

        inputToolbar.pressEventDelegate = self
        inputToolbar.contentView?.inputTextView.delegate = nil
    }
    
    // MARK: Initialization
    private func setupMessagesViewController() {
        inputToolbar.pressEventDelegate = self
        inputToolbar.contentView?.inputTextView.delegate = self
        // To make inputToolbar no parent view, so that it can be added onto inputAccessoryView
        inputToolbar.removeFromSuperview()
        inputToolbar.toggleSendButtonEnabled()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    // MARK: Input
    override public var inputAccessoryView: UIView? { return self.inputToolbar }
    override public func canBecomeFirstResponder() -> Bool { return true }
    
    // MARK: DUMessagInputToolbarDelegate
    public func didPressSendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        guard toolbar.contentView?.inputTextView.text.du_trimingWhitespace().characters.count > 0 else {
            return
        }
        didPressSendButton(sender, withText: toolbar.contentView!.inputTextView.text)
    }
    
    public func didPressAccessorySendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        didPressAccessorySendButton(sender)
    }
    
    
    // MARK: UIcollectionView DataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageData.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let messageItem = messageData[indexPath.item]
        guard let _ = collectionView as? DUMessageCollectionView else {
            assert(false, "Error collectionView class : \(collectionView.nameOfClass), supposed to be \(DUMessageCollectionView.nameOfClass)")
            return UICollectionViewCell() // this line will not be executed for previous assertion
        }
        
        let du_collectionView = collectionView as! DUMessageCollectionView
        
        var cellIdentifier: String = ""
        if messageItem.isOutgoingMessage {
            cellIdentifier = self.outgoingCellIdentifier
        } else {
            cellIdentifier = self.incomingCellIdentifier
        }
        
        let cell: DUMessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! DUMessageCollectionViewCell
        cell.delegate = self
        // TODO: add media cell
        cell.cellTextView.text = messageItem.contentText
        cell.cellTextView.dataDetectorTypes = .All
        
        assert(du_collectionView.du_dataSource != nil, "DataSource is nil, couldn't get correct layout attributes")
        let duDataSource = du_collectionView.du_dataSource!
        cell.bubbleImageView.image = duDataSource.messageBubbleImage(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        // Do not show avatar of outgoing messages
        if messageItem.isOutgoingMessage {
            cell.avatarImageView.image = nil
        } else {
            cell.avatarImageView.image = duDataSource.avatarImage(atIndexPath: indexPath, forCollectionView: du_collectionView)
        }
        
        cell.cellTopLabel.attributedText = duDataSource.attributedTextForCellTopLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
        cell.messageBubbleTopLabel.attributedText = duDataSource.attributedTextForMessageBubbleTopLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
        cell.timeLabel.attributedText = duDataSource.attributedTextForTiemLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        if messageItem.isOutgoingMessage {
            let cell = cell as! DUMessageOutGoingCollectionViewCell
            cell.readLabel.attributedText = duDataSource.attributedTextForReadLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
            // FIXME: make this work when API supports
            cell.resendButton.hidden = true
        }

        return cell
    }
    
    // MARK: UICollectionView Delegate Flow Layout
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let du_collectionViewLayout = collectionViewLayout as! DUMessageCollectionViewFlowLayout
        return du_collectionViewLayout.sizeForItem(atIndexPath: indexPath)
    }

    
    // MARK: UITextViewDelegate
    public func textViewDidBeginEditing(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.becomeFirstResponder()
    }
    
    public func textViewDidChange(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        inputToolbar.toggleSendButtonEnabled()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.resignFirstResponder()
    }
    
    // MARK: DUMessages ViewController
    public func didPressSendButton(sender: UIButton, withText: String) {
        assert(false, "Error! You must implement method: \(#function)")
    }
    
    public func didPressAccessorySendButton(sender: UIButton) {
        assert(false, "Error! You must implement method: \(#function)")
    }
}


// MARK: Class method
public extension DUMessagesViewController {
    static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
}


// MARK: DUMessageCollectionViewFlowLayout Delegate - Default behavior
public extension DUMessageCollectionViewFlowLayoutDelegate where Self: DUMessagesViewController {
    public func heightForCellTopLabel(atIndexPath indexPath: NSIndexPath, withLayout layout: DUMessageCollectionViewFlowLayout, inCollectionView collectionView: DUMessageCollectionView) -> CGFloat {
        return 0.0
    }
    
    public func heightForMessageBubbleTopLabel(atIndexPath indexPath: NSIndexPath, withLayout layout: DUMessageCollectionViewFlowLayout, inCollectionView collectionView: DUMessageCollectionView) -> CGFloat {
        let messageItem = messageData[indexPath.row]
        if messageItem.isOutgoingMessage { return 0.0 }
        else { return 20.0 }
    }
}


// MARK: DUMessageCollectionView DataSource - Default behavior
public extension DUMessageCollectionViewDataSource where Self: DUMessagesViewController {
    public func messageData(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> DUMessageData {
        return messageData[indexPath.row]
    }
    
    public func messageBubbleImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[indexPath.row]
        if messageItem.isOutgoingMessage {
            return defaultOutgoingBubbleImage
        } else {
            return defaultIncomingBubbleImage
        }
    }
    
    public func avatarImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[indexPath.row]
        if messageItem.isOutgoingMessage {
            return nil
        } else {
            let senderName = messageItem.senderDisplayName
            let initial: String = String(senderName[senderName.startIndex]).uppercaseString
            // chck if the image is cached
            if avatarImageCache[initial] != nil {
                return avatarImageCache[initial]
            } else {
                let avatar = DUAvatarImageFactory.makeAvatarImage(initial, font: UIFont.DUChatAvatarFont()!, diameter: DUAvatarImageFactory.kAvatarImageDefualtDiameterInMessags)!
                avatarImageCache[initial] = avatar
                return avatar
            }
        }
        
    }
    
    public func attributedTextForCellTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        return nil
    }
    
    public func attributedTextForMessageBubbleTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[indexPath.row]
        if messageItem.isOutgoingMessage {
            return nil
        } else { // only display sender for received messages
            return NSAttributedString(string: messageItem.senderDisplayName)
        }
    }
    
    public func attributedTextForTiemLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[indexPath.row]
        return NSAttributedString(string: messageItem.date.messageTimeLabelString)
    }
    // TODO: complete this when API support read function
    public func attributedTextForReadLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        return nil
    }
}

// MARK: DUMessageCollectionViewCell Delegate - default behavior
public extension DUMessageCollectionViewCellDelegate where Self: DUMessagesViewController {
    func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print("tapped avatar, please implement '\(#function)' to deal with this event.")
    }

    func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print("tapped message bubble, please implement '\(#function)' to deal with this event.")
    }

    func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell) {
        print("tapped message cell, please implement '\(#function)' to deal with this event.")
    }
}


// MARK: UI Protocol
public protocol DUMessagesUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle {}
extension DUMessagesUIProtocol {
    public var myBarTitle: String { return "Messages" }
    
    public func adoptProtocolUIApperance() {
        // setup all inherited UI protocols
        setupInheritedProtocolUI()
    }
}