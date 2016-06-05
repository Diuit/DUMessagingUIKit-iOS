//
//  DUMessageInputToolBar.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public protocol DUMessagInputToolBarDelegate: UIToolbarDelegate {
    func didPressSendButton()
    func didPressAccessorySendButton()
}

public class DUMessageInputToolBar: UIToolbar {
    
    //public internal(set) weak var contentView: DUInputToolBarContentView?
    dynamic public weak var delegate: DUMessagInputToolBarDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        let toolBarContentView = NSBundle(identifier: Constants.bundleIdentifier)?.loadNibNamed(String(DUInputToolBarContentView), owner: nil, options: nil).first as? DUInputToolBarContentView
        
        guard toolBarContentView != nil else {
            assert(false, "contentView has loaded failed")
            return
        }
        toolBarContentView?.frame = bounds
        addSubview(toolBarContentView!)
        pingAlledge(ofSubview: toolBarContentView!)
        setNeedsUpdateConstraints()
        contentView = toolBarContentView
    }
    
    // MARK: tool bar button
    private func toggleSendButtonEnabled() {
        let hasText: Bool = contentView?.inputTextView.hasText() ?? false
        contentView?.sendButton.enabled = hasText
    }
}



