//
//  DUInputToolBarContentView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUInputToolBarContentView: UIView {
    @IBOutlet weak var accessorySendButton: UIButton!
    @IBOutlet weak var inputTextView: DUMessageInputTextView!
    @IBOutlet weak var sendButton: UIButton!
    
    static public let nib: UINib = UINib.init(nibName: String(DUInputToolBarContentView), bundle: NSBundle(identifier: Constants.bundleIdentifier))
    
}
