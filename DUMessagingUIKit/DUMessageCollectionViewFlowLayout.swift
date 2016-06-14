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

// TODO: 1. dynamically overrid super property collectionView? or use another way
//       2. automaticllay adopt to font changing

public class DUMessageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    /**
        Font to display message text in the message bubble 
        
        - warning: This value must not be `nil`. The defualt view is `DUChatBodyFriendFont`
     */
    public var messageBodyFont: UIFont = UIFont.DUChatBodyFriendFont() ?? UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    /**
        This value specifies the horizontal spacing betweeen the `messageBubbleContainerView` edge, which is opposite to the avatar side, and the edge of collectionView. 
     
        - For *outgoing* message, this is the amount of spacing from left edge of the message bubble to the left edge of the collectionView content view.
        - For *incoming* message, this is the amount of spacing from right edge of the message bubble to the right edge of the collectionView content view.
     
        - Important: The default value is `72.0`. This value may be the final result of the spacing when the layout procedure finishes, due to there's another constraint to verify.
                     You'd better regard this value as a recommendation.
     */
    public var messageBubbleHorizontalMargin: CGFloat = 72.0
    {
        didSet {
            invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
        }
    }
    /**
        This inset of the textView frame which lies in the bubble container view, default value is `UIEdgeInsetsZero`. The texView will exactly overrlap with the bubble container view.
     */
    public var messageBubbleTextViewFrameInsets = UIEdgeInsetsZero
    /**
        The inset of the text container in the textView which lies in the `messageBubbleContainerView`.
     */
    public var messageBubbleTextViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
    {
        didSet {
            if !UIEdgeInsetsEqualToEdgeInsets(oldValue, messageBubbleTextViewTextContainerInsets) {
                // TODO: do we need a customized context?
                invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
            }
        }
    }
    /**
        The diameter of the avatar image view for incoming messages
     
        - Note: Set to `0.0` to make avatar hidden
     */
    public var incomingAvatarImageViewDiameter: CGFloat = kDUMEssageCollectionViewCellAvatarSizeDefault
    {
        didSet {
            if incomingAvatarImageViewDiameter != oldValue {
                invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
            }
        }
    }
    /**
        The diameter of the avatar image view for outgoing messages
     
        - Note: Set to `0.0` to make avatar hidden. Default value is `0.0`.
     */
    public var outgoingAvatarImageViewDiameter: CGFloat = 0.0
    {
        didSet {
            if outgoingAvatarImageViewDiameter != oldValue {
                invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
            }
        }
    }
    /// Returns item's width in layout
    public var itemWidth: CGFloat {
        if collectionView == nil {
            return 0.0
        }
        
        return CGRectGetWidth(collectionView!.frame) - sectionInset.left - sectionInset.right
    }
    /// Message bubble size calculator
    var bubbleSizeCalculator: DUMessageSizeCalculator = DUMessageSizeCalculator()
    
    
    // MARK: Initialize
    override public init() {
        super.init()
        setupFlowLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupFlowLayout()
    }
    // return customized attributes class
    public override class func layoutAttributesClass() -> AnyClass {
        return DUCollectionViewLayouAttributes.self
    }
}


// UICollectionViewFlowLayout method
public extension DUMessageCollectionViewFlowLayout {
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let oldBounds: CGRect = self.collectionView!.bounds
        if CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds) {
            return true
        }
        
        return false
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesInRect = super.layoutAttributesForElementsInRect(rect)
        for attributesItem in attributesInRect! {
            if attributesItem.representedElementCategory == .Cell {
                let attr = attributesItem as! DUCollectionViewLayouAttributes
                configure(cellLayoutAttributes: attr)
            } else {
                attributesItem.zIndex = -1
            }
        }
    
        return attributesInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let myAttributes: DUCollectionViewLayouAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as! DUCollectionViewLayouAttributes
        if myAttributes.representedElementCategory == .Cell {
            configure(cellLayoutAttributes: myAttributes)
        }
        
        return myAttributes
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for item: UICollectionViewUpdateItem in updateItems {
            if item.updateAction == .Insert {
                let colletionViewHeight: CGFloat = CGRectGetHeight(collectionView!.bounds)
                let attributes: DUCollectionViewLayouAttributes = DUCollectionViewLayouAttributes(forCellWithIndexPath: item.indexPathAfterUpdate!)
                
                if attributes.representedElementCategory == .Cell {
                    configure(cellLayoutAttributes: attributes)
                }
                
                attributes.frame = CGRectMake(0.0, colletionViewHeight + CGRectGetHeight(attributes.frame), CGRectGetWidth(attributes.frame), CGRectGetHeight(attributes.frame))
            }
        }
    }
    
    func messageBubbleSizeForItem(atIndexPath indexPath: NSIndexPath) -> CGSize {
        guard self.collectionView != nil else {
            print("collectionView does not exist")
            return CGSizeZero
        }
        
        guard self.collectionView!.isKindOfClass(DUMessageCollectionView) else {
            print("The collectionView this layout belongs to is not an instance of `DUMessageCollectionView`")
            return CGSizeZero
        }
        
        let du_collectionView = self.collectionView as! DUMessageCollectionView
        let du_dataSource = du_collectionView.dataSource as! DUMessageCollectionViewDataSource
        let messageItem = du_dataSource.messageData(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        return bubbleSizeCalculator.messageBubbleSize(forMessageData: messageItem, atIndexPath: indexPath, withLayout: self)
    }
    
    func sizeForItem(atIndexPath indexPath: NSIndexPath) -> CGSize {
        let messageBubbleSize = self.messageBubbleSizeForItem(atIndexPath: indexPath)
        
        let attributes: DUCollectionViewLayouAttributes = self.layoutAttributesForItemAtIndexPath(indexPath) as! DUCollectionViewLayouAttributes
        let finalHeight = messageBubbleSize.height + attributes.cellTopLabelHeight + attributes.messageBubbleTopLabelHeight
        
        return CGSizeMake(itemWidth, finalHeight)
    }
}

// message cell layouts

// MARK: Private methods
private extension DUMessageCollectionViewFlowLayout {
    func setupFlowLayout() {
        // TODO: delete itemSize later
        itemSize = CGSizeMake(250.0, 154.0)
        scrollDirection = .Vertical
        sectionInset = UIEdgeInsetsMake(10.0, 15.0, 10.0, 15.0)
        minimumLineSpacing = 15.0
    }
    
    func configure(cellLayoutAttributes attrs: DUCollectionViewLayouAttributes) {
        
        let indexPath = attrs.indexPath
        // XXX: This is why we need cache, right after getting the size, layou configure will be executed. And we need to calculate it again!
        let messageBubbleSize: CGSize = messageBubbleSizeForItem(atIndexPath: indexPath)
        
        attrs.messageBubbleContainerViewWidth = messageBubbleSize.width
        attrs.cellTextViewFrameInset = messageBubbleTextViewFrameInsets
        attrs.textViewTextContainerInsets = messageBubbleTextViewTextContainerInsets
        attrs.incomingAvatarImageViewDiameter = self.incomingAvatarImageViewDiameter
        attrs.outgoingAvatarImageViewDiameter = self.outgoingAvatarImageViewDiameter
        attrs.messageBubbleFont = self.messageBodyFont
        
        // from delegate
        if let du_collectionView = self.collectionView as? DUMessageCollectionView {
            if let delegate = du_collectionView.delegate {
                let delegate = delegate as! DUMessageCollectionViewFlowLayoutDelegate
                attrs.cellTopLabelHeight = delegate.heightForCellTopLabel(atIndexPath: indexPath, withLayout: self, inCollectionView: du_collectionView)
                attrs.messageBubbleTopLabelHeight = delegate.heightForMessageBubbleTopLabel(atIndexPath: indexPath, withLayout: self, inCollectionView: du_collectionView)
            }
        }
    }
}