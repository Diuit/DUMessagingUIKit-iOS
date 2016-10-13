//
//  DUInputToolbarContentView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUInputToolbarContentView: UIView {
    @IBOutlet public weak var accessorySendButton: UIButton!
    @IBOutlet public weak var inputTextView: DUMessageInputTextView!
    @IBOutlet public weak var sendButton: UIButton! {
        didSet {
            sendButton.tintColor = GlobalUISettings.tintColor
        }
    }
    
    @IBOutlet weak var accessoryBtnWidthConstraint: NSLayoutConstraint!

    var hideAccessorySendButton: Bool = false {
        didSet {
            if hideAccessorySendButton {
                accessoryBtnWidthConstraint.constant = 0
                accessorySendButton.isHidden = true
            } else {
                accessoryBtnWidthConstraint.constant = 32
                accessorySendButton.isHidden = false
            }
        }
    }
    
    static public let nib: UINib = UINib.init(nibName: String(describing: DUInputToolbarContentView.self), bundle: Bundle.du_messagingUIKitBundle)
    
}
