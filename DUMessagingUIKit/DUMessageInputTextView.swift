//
//  DUMessageInputTextView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageInputTextView: UITextView {
    
    // TODO: add localization here and to be customizable
    let placeholder: String = "Write a message..."
    
    private weak var heightConstraint: NSLayoutConstraint? = nil
    private weak var minHeightConstraint: NSLayoutConstraint? = nil
    private weak var maxHeightConstraint: NSLayoutConstraint? = nil
    
    
    // MARK: UITextView
    override public var text: String! {
        get {
            return self.text
        }
        set {
            self.text = newValue
            self.setNeedsDisplay()
        }
    }
    
    override public func hasText() -> Bool {
        return (text.du_trimingWhitespace().characters.count > 0)
    }
    // MARK: UIView life cycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    // draw placeholder if no text in textView
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if text == "" {
            let p = placeholder as NSString
            p.drawInRect(CGRectInset(rect, 7.0, 3.0), withAttributes: placeholderAttributes)
        }
    }
    
    override public func layoutSubviews() {
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
    private func setupTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.whiteColor()
        textContainerInset = UIEdgeInsetsMake(4.0, 2.0, 4.0, 2.0)
        contentInset = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
        scrollEnabled = true
        scrollsToTop = false
        userInteractionEnabled = true
        
        font = UIFont.DUChatBodyFriendFont()
        textColor = UIColor.blueColor()
        textAlignment = .Natural
        
        dataDetectorTypes = .None
        keyboardAppearance = .Default
        keyboardType = .Default
        returnKeyType = .Default
        
        text = ""
    }
    
    // iterate all constraints in xib and link variable with correct constrains
    private func linkConstraints() {
        for c in constraints {
            if c.firstAttribute == .Height {
                switch c.relation {
                case .Equal:
                    heightConstraint = c
                case .GreaterThanOrEqual:
                    minHeightConstraint = c
                case .LessThanOrEqual:
                    maxHeightConstraint = c
                }
            }
        }
    }
    
    // MARK: private helper
    private var placeholderAttributes: [String: AnyObject] {
        get {
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .ByTruncatingTail
            paragraphStyle.alignment = textAlignment
            
            return [NSFontAttributeName: UIFont.DUBodyFont()!, NSForegroundColorAttributeName: UIColor.DUDarkGreyColor(), NSParagraphStyleAttributeName: paragraphStyle]
        }
    }
    
    // MARK: UIMenuController
    override public func canBecomeFirstResponder() -> Bool {
        return super.canBecomeFirstResponder()
    }
    
    override public func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override public func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        UIMenuController.sharedMenuController().menuItems = nil
        
        if text.characters.count == 0 {
            if action == #selector(NSObject.paste(_:)) {
                return true
            }
        } else {
            if selectedRange.length > 0 {
                if action == #selector(NSObject.cut(_:)) || action == #selector(NSObject.copy(_:))
                || action == #selector(NSObject.select(_:)) || action == #selector(NSObject.selectAll(_:))
                || action == #selector(NSObject.paste(_:)) || action == #selector(NSObject.delete(_:)) {
                    return true
                }
            } else {
                if action == #selector(NSObject.select(_:)) || action == #selector(NSObject.selectAll(_:))
                    || action == #selector(NSObject.paste(_:)) {
                    return true
                }
            }
        }
        
        return false
    }
}
