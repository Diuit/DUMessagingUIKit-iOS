//
//  DUMessageCollectionViewFlowLayout.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/6.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

internal let kDUMessageCollectionViewCellLabelHeightDefault: CGFloat = 20.0
internal let kDUMEssageCollectionViewCellAvatarSizeDefault: CGFloat = 32.0

public class DUMessageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    public var messageBodyFont: UIFont = UIFont.DUChatBodyFriendFont() ?? UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    public var messageBubbleHorizontalMargin: CGFloat = 50.0
    public var messageBubbleTextViewFrameInsets = UIEdgeInsetsZero
    public var messageBubbleTextViewTextContainerInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
    
    // MARK: Initialization
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupFlowLayout()
    }
    
    private func setupFlowLayout() {
        scrollDirection = .Vertical
        sectionInset = UIEdgeInsetsMake(10.0, 15.0, 10.0, 15.0)
        minimumLineSpacing = 4.0
    }
    
}
