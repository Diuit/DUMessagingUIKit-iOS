//
//  DUMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTCollectionViewManager

public class DUMessagesViewController: UIViewController, UITextViewDelegate, DUMessagInputToolbarDelegate, DUMessagesUIProtocol, DTCollectionViewManageable {

    public static var nib: UINib { return UINib.init(nibName: String(DUMessagesViewController), bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
    
    @IBOutlet weak var inputToolbar: DUMessageInputToolbar!
    @IBOutlet public weak var collectionView: UICollectionView?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        DUMessagesViewController.nib.instantiateWithOwner(self, options: nil)
        setupMessagesViewController()
        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        manager.registerCellClass(DUMessageOutGoingCollectionViewCell)
        manager.registerNibNamed("DUMessageOutGoingCollectionViewCell", forCellClass: DUMessageOutGoingCollectionViewCell.self)
        let messages = [MessageData(), MessageData(), MessageData()]
        manager.memoryStorage.addItems(messages)
    }
    
    deinit {
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


// MARK: UI Protocol
public protocol DUMessagesUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle {}
extension DUMessagesUIProtocol {
    public var myBarTitle: String { return "Messages" }
    
    public func adoptProtocolUIApperance() {
        // setup all inherited UI protocols
        setupInheritedProtocolUI()
    }
}