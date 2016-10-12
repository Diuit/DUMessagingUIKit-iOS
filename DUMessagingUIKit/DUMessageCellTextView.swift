//
//  DUMessageCellTextView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageCellTextView: UITextView {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        editable = false
        selectable = true
        userInteractionEnabled = true
        dataDetectorTypes = .None
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollEnabled = false
        backgroundColor = UIColor.clearColor()
        textContainerInset = UIEdgeInsetsZero
        textContainer.lineFragmentPadding = 0
        contentInset = UIEdgeInsetsZero
        scrollIndicatorInsets = UIEdgeInsetsZero
        contentOffset = CGPointZero
        let underline = NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternSolid.rawValue
        linkTextAttributes = [  NSForegroundColorAttributeName : GlobalUISettings.tintColor,
                                NSUnderlineStyleAttributeName: underline]
        
    }
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // ignore double tap to prevent unrelevatn menu showing
        if let gr = gestureRecognizer as? UITapGestureRecognizer {
            if gr.numberOfTapsRequired == 2 { return false }
        }
        return true
    }

}
