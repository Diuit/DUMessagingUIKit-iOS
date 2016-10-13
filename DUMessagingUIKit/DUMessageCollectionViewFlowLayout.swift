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

open class DUMessageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    /**
        Font to display message text in the message bubble 
        
        - warning: This value must not be `nil`. The defualt view is `DUChatBodyFriendFont`
     */
    public var messageBodyFont: UIFont = UIFont.DUChatBodyFriendFont()
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
            invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
        }
    }
    /**
        This inset of the textView frame which lies in the bubble container view, default value is `UIEdgeInsetsZero`. The texView will exactly overrlap with the bubble container view.
     */
    public var messageBubbleTextViewFrameInsets = UIEdgeInsets.zero
    /**
        The inset of the text container in the textView which lies in the `messageBubbleContainerView`.
     */
    public var messageBubbleTextViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
    {
        didSet {
            if !UIEdgeInsetsEqualToEdgeInsets(oldValue, messageBubbleTextViewTextContainerInsets) {
                // TODO: do we need a customized context?
                invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
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
                invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
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
                invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
            }
        }
    }
    /// Returns item's width in layout
    public var itemWidth: CGFloat {
        if collectionView == nil {
            return 0.0
        }
        
        return collectionView!.frame.width - sectionInset.left - sectionInset.right
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
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupFlowLayout()
    }
    // return customized attributes class
    open override class var layoutAttributesClass : AnyClass {
        return DUCollectionViewLayouAttributes.self
    }
    
    
    // MARK: UICollectionViewFlowLayout
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds: CGRect = self.collectionView!.bounds
        if newBounds.width != oldBounds.width {
            return true
        }
        
        return false
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesInRect = super.layoutAttributesForElements(in: rect)
        for attributesItem in attributesInRect! {
            if attributesItem.representedElementCategory == .cell {
                let attr = attributesItem as! DUCollectionViewLayouAttributes
                configure(cellLayoutAttributes: attr)
            } else {
                attributesItem.zIndex = -1
            }
        }
        
        return attributesInRect
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let myAttributes: DUCollectionViewLayouAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! DUCollectionViewLayouAttributes
        if myAttributes.representedElementCategory == .cell {
            configure(cellLayoutAttributes: myAttributes)
        }
        
        return myAttributes
    }
    
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for item: UICollectionViewUpdateItem in updateItems {
            if item.updateAction == .insert {
                let colletionViewHeight: CGFloat = collectionView!.bounds.height
                let attributes: DUCollectionViewLayouAttributes = DUCollectionViewLayouAttributes(forCellWith: item.indexPathAfterUpdate!)
                
                if attributes.representedElementCategory == .cell {
                    configure(cellLayoutAttributes: attributes)
                }
                
                attributes.frame = CGRect(x: 0.0, y: colletionViewHeight + attributes.frame.height, width: attributes.frame.width, height: attributes.frame.height)
            }
        }
    }
    
    func messageBubbleSizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        guard self.collectionView != nil else {
            print("collectionView does not exist")
            return CGSize.zero
        }
        
        guard self.collectionView!.isKind(of: DUMessageCollectionView.self) else {
            print("The collectionView this layout belongs to is not an instance of `DUMessageCollectionView`")
            return CGSize.zero
        }
        
        let du_collectionView = self.collectionView as! DUMessageCollectionView
        let du_dataSource = du_collectionView.dataSource as! DUMessageCollectionViewDataSource
        let messageItem = du_dataSource.messageData(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        return bubbleSizeCalculator.messageBubbleSize(forMessageData: messageItem, atIndexPath: indexPath, withLayout: self)
    }
    
    func sizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        let messageBubbleSize = self.messageBubbleSizeForItem(atIndexPath: indexPath)
        
        let attributes: DUCollectionViewLayouAttributes = self.layoutAttributesForItem(at: indexPath) as! DUCollectionViewLayouAttributes
        let finalHeight = messageBubbleSize.height + attributes.cellTopLabelHeight + attributes.messageBubbleTopLabelHeight
        
        return CGSize(width: itemWidth, height: finalHeight)
    }
    
}


// MARK: Private methods
private extension DUMessageCollectionViewFlowLayout {
    func setupFlowLayout() {
        // TODO: delete itemSize later
        itemSize = CGSize(width: 250.0, height: 154.0)
        scrollDirection = .vertical
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
                attrs.cellTopLabelHeight = delegate.heightForCellTopLabel(at: indexPath, with: self, collectionView: du_collectionView)
                attrs.messageBubbleTopLabelHeight = delegate.heightForMessageBubbleTopLabel(at: indexPath, with: self, collectionView: du_collectionView)
            }
        }
    }
}
