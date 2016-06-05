//
//  DUMessageInputToolBar.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public protocol DUMessagInputToolBarDelegate {
    func didPressSendButton()
    func didPressAccessorySendButton()
}

public class DUMessageInputToolBar: UIToolbar {
    
    public internal(set) weak var contentView: DUInputToolBarContentView?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = NSBundle(identifier: Constants.bundleIdentifier)?.loadNibNamed(String(DUInputToolBarContentView), owner: nil, options: nil).first as? DUInputToolBarContentView
        
        guard contentView != nil else {
            assert(false, "contentView has loaded failed")
            return
        }
        contentView?.frame = frame
        addSubview(contentView!)
        pingAlledge(ofSubview: contentView!)
        setNeedsUpdateConstraints()
    }
    
    // MARK: tool bar button
    private func toggleSendButtonEnabled() {
        let hasText: Bool = contentView?.inputTextView.hasText() ?? false
        contentView?.sendButton.enabled = hasText
    }
}



