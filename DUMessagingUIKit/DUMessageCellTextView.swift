//
//  DUMessageCellTextView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUMessageCellTextView: UITextView {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        isEditable = false
        isSelectable = true
        isUserInteractionEnabled = true
        dataDetectorTypes = UIDataDetectorTypes()
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = UIColor.clear
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
        contentOffset = CGPoint.zero
        let underline = NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternSolid.rawValue
        linkTextAttributes = [  NSForegroundColorAttributeName : GlobalUISettings.tintColor,
                                NSUnderlineStyleAttributeName: underline]
        
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // ignore double tap to prevent unrelevatn menu showing
        if let gr = gestureRecognizer as? UITapGestureRecognizer {
            if gr.numberOfTapsRequired == 2 { return false }
        }
        return true
    }

}
