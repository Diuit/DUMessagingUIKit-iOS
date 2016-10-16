//
//  DUMessageInputToolbar.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import MisterFusion

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
    func didPressSendButton(_ sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar)
    /**
        Tells the delegate that toolar's `accessorySendButton` has been pressed.
     
     - paramters:
        - sender: The pressed button
        - toolbar: The toolbar sending the information
     */
    func didPressAccessorySendButton(_ sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar)
}


open class DUMessageInputToolbar: UIToolbar {
    
    public weak var contentView: DUInputToolbarContentView?
    public var hideAccessorySendButton: Bool = false {
        didSet {
            contentView?.hideAccessorySendButton = hideAccessorySendButton
        }
    }
    var inputToolbarDelegate: DUMessagInputToolbarDelegate?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let loadedNib = Bundle.du_messagingUIKitBundle.loadNibNamed(String(describing: DUInputToolbarContentView.self), owner: nil, options: nil)
        
        guard loadedNib != nil else {
            assert(false, "Nib of \(String(describing: DUInputToolbarContentView.self)) not loaded")
            return
        }
        
        let toolbarContentView = loadedNib!.first as? DUInputToolbarContentView
        
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
        contentView?.sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        contentView?.accessorySendButton.addTarget(self, action: #selector(accessorySendButtonPressed(_:)), for: .touchUpInside)
        
        // upper border view
        let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5))
        topBorderView.backgroundColor = UIColor(white: 180/255.0, alpha: 1.0)
        addSubview(topBorderView)
    }


    // MARK: tool bar button & Actions
    internal func toggleSendButtonEnabled() {
        let hasText: Bool = contentView?.inputTextView.hasText ?? false
        contentView?.sendButton.isEnabled = hasText
    }
    
    @objc fileprivate func sendButtonPressed(_ sender: UIButton) {
        self.inputToolbarDelegate?.didPressSendButton(sender, ofToolbar: self)
    }
    
    @objc fileprivate func accessorySendButtonPressed(_ sender: UIButton) {
        self.inputToolbarDelegate?.didPressAccessorySendButton(sender, ofToolbar: self)
    }

}



