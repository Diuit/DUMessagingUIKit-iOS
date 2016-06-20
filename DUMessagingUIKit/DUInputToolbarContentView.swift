//
//  DUInputToolbarContentView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUInputToolbarContentView: UIView {
    @IBOutlet weak var accessorySendButton: UIButton!
    @IBOutlet weak var inputTextView: DUMessageInputTextView!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.tintColor = GlobalUISettings.tintColor
        }
    }
    
    static public let nib: UINib = UINib.init(nibName: String(DUInputToolbarContentView), bundle: NSBundle(identifier: Constants.bundleIdentifier))
    
}