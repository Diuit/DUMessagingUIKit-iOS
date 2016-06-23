//
//  DUMessageInputToolbar.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

private var kDUMessageInputToolbarKeyValueObserverContext = 0
/**
    This protocol defines methods for interacting with a `DUMessageInputToolbarDelegate` object
 */
protocol DUMessagInputToolbarDelegate {
    /**
        Tells the delegate that toolar's `sendButton` has been pressed.
     
     - paramters:
        - sender: The pressed button
        - toolbar: The toolbar sending the information
     */
    func didPressSendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar)
    /**
        Tells the delegate that toolar's `accessorySendButton` has been pressed.
     
     - paramters:
        - sender: The pressed button
        - toolbar: The toolbar sending the information
     */
    func didPressAccessorySendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar)
}


public class DUMessageInputToolbar: UIToolbar {
    
    public internal(set) weak var contentView: DUInputToolbarContentView?
    var inputToolbarDelegate: DUMessagInputToolbarDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbarContentView = NSBundle(identifier: Constants.bundleIdentifier)?.loadNibNamed(String(DUInputToolbarContentView), owner: nil, options: nil).first as? DUInputToolbarContentView
        
        guard toolbarContentView != nil else {
            assert(false, "contentView has loaded failed")
            return
        }
        toolbarContentView?.frame = bounds
        addSubview(toolbarContentView!)
        pingAlledge(ofSubview: toolbarContentView!)
        setNeedsUpdateConstraints()
        contentView = toolbarContentView
        //TODO: should let user customize in the future
        contentView?.sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), forControlEvents: .TouchUpInside)
        contentView?.accessorySendButton.addTarget(self, action: #selector(accessorySendButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }


    // MARK: tool bar button & Actions
    internal func toggleSendButtonEnabled() {
        let hasText: Bool = contentView?.inputTextView.hasText() ?? false
        contentView?.sendButton.enabled = hasText
    }
    
    @objc private func sendButtonPressed(sender: UIButton) {
        self.inputToolbarDelegate?.didPressSendButton(sender, ofToolbar: self)
    }
    
    @objc private func accessorySendButtonPressed(sender: UIButton) {
        self.inputToolbarDelegate?.didPressAccessorySendButton(sender, ofToolbar: self)
    }
}



