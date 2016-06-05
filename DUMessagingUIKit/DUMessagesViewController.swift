//
//  DUMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessagesViewController: UIViewController, UITextViewDelegate, DUMessagInputToolBarDelegate {

    public static var nib: UINib { return UINib.init(nibName: String(DUMessagesViewController), bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
    
    @IBOutlet weak var inputToolBar: DUMessageInputToolBar!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        DUMessagesViewController.nib.instantiateWithOwner(self, options: nil)
        setupMessagesViewController()

    }
    
    deinit {
        inputToolBar.delegate = self
        inputToolBar.contentView?.inputTextView.delegate = nil
    }
    
    // MARK: Initialization
    private func setupMessagesViewController() {
        inputToolBar.delegate = self
        inputToolBar.contentView?.inputTextView.delegate = self
        // To make inputToolBar has no parent view, so that it can be added onto inputAccessoryView
        self.inputToolBar.removeFromSuperview()
    }
    
    // MARK: Input
    override public var inputAccessoryView: UIView? { return self.inputToolBar }
    override public func canBecomeFirstResponder() -> Bool { return true }
}
