//
//  DUMessageInputTextView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUMessageInputTextView: UITextView {
    
    // TODO: add localization here and to be customizable
    let placeholder: String = "Write a message..."
    
    fileprivate weak var heightConstraint: NSLayoutConstraint? = nil
    fileprivate weak var minHeightConstraint: NSLayoutConstraint? = nil
    fileprivate weak var maxHeightConstraint: NSLayoutConstraint? = nil
    
    
    // MARK: UITextView
    override open var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override open var hasText : Bool {
        return (text.du_trimingWhitespace().characters.count > 0)
    }
    // MARK: UIView life cycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    // draw placeholder if no text in textView
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text == "" {
            let p = placeholder as NSString
            p.draw(in: rect.insetBy(dx: 7.0, dy: 7.0), withAttributes: placeholderAttributes)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let sizeThatFits = self.sizeThatFits(frame.size)
        var newHeight: CGFloat = sizeThatFits.height
        
        // if max constraint is set, we have to use that
        if maxHeightConstraint != nil {
            newHeight = min(newHeight, maxHeightConstraint!.constant)
        }
        
        // if min constraint is set, we have to use that
        if minHeightConstraint != nil {
            newHeight = max(newHeight, minHeightConstraint!.constant)
        }
        
        // setup final height value
        heightConstraint?.constant = newHeight
    }
    
    // MARK: UI methods
    fileprivate func setupTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        textContainerInset = UIEdgeInsetsMake(5.0, 2.0, 5.0, 2.0)
        contentInset = UIEdgeInsetsMake(2.0, 0.0, 2.0, 0.0)
        isScrollEnabled = true
        scrollsToTop = false
        isUserInteractionEnabled = true
        
        font = UIFont.DUChatBodyFriendFont()
        textColor = UIColor.black
        textAlignment = .natural
        
        dataDetectorTypes = UIDataDetectorTypes()
        keyboardAppearance = .default
        keyboardType = .default
        returnKeyType = .default
        
        text = nil
        
        // add notifiction for events
        addTextViewNotificationObservers()
        
        bindConstraints()
    }
    
    deinit {
        removeTextViewNotificationObservers()
    }
    
    // iterate all constraints in xib and link variable with correct constrains
    fileprivate func bindConstraints() {
        for c in constraints {
            if c.firstAttribute == .height {
                switch c.relation {
                case .equal:
                    heightConstraint = c
                case .greaterThanOrEqual:
                    minHeightConstraint = c
                case .lessThanOrEqual:
                    maxHeightConstraint = c
                }
            }
        }
    }
    
    // MARK: NSNotifications
    fileprivate func addTextViewNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(DUMessageInputTextView.didReceiveTextViewNotification), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(DUMessageInputTextView.didReceiveTextViewNotification), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(DUMessageInputTextView.didReceiveTextViewNotification), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    fileprivate func removeTextViewNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    @objc fileprivate func didReceiveTextViewNotification() {
        setNeedsDisplay()
    }
    
    // MARK: private helper
    fileprivate var placeholderAttributes: [String: AnyObject] {
        get {
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.alignment = textAlignment
            
            return [NSFontAttributeName: UIFont.DUBodyFont(), NSForegroundColorAttributeName: UIColor.DUDarkGreyColor(), NSParagraphStyleAttributeName: paragraphStyle]
        }
    }
}
