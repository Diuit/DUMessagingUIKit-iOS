//
//  DUMessageSizeCalculator.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

private let defaultMinBubbleWidth: CGFloat = 48.0

public class DUMessageSizeCalculator: NSObject {
    
    private var sizeCache: NSCache
    private var minBubbleWidth: CGFloat
    
    public init(cache: NSCache, minimumBubbleWidth: CGFloat) {
        assert(minimumBubbleWidth > 0, "minimum message bubble width can not be less than 0")
        
        sizeCache = cache
        minBubbleWidth = minimumBubbleWidth
        super.init()
    }
    
    override convenience init() {
        let cache = NSCache()
        cache.name = "DUMessageSizeCalculator.cache"
        cache.countLimit = 200
        self.init(cache: cache, minimumBubbleWidth: defaultMinBubbleWidth)
    }
}

public extension DUMessageSizeCalculator {
    /// clear all layout results stored in cache.
    func clearCachedLayouts() {
        self.sizeCache.removeAllObjects()
    }
    /**
        Return computed size of message bubble container view size of `DUMessageCollectionViewCell`, with given message data, indexPath and layout.
     
        - parameters:
            - data: Message data to display
            - indexPath: The indexPath of the cell corresponded to the message.
            - layout: The object of collection view cell layouts.
     
        - returns: A CGSize which specifies the size of message bubble container view
     
        - Note: This is not the size of entier collectionViewCell, just the message bubble.
     */
    func messageBubbleSize(forMessageData messageData: DUMessageData, atIndexPath indexPath: NSIndexPath, withLayout layout: DUMessageCollectionViewFlowLayout) -> CGSize {
        let cachedSize = sizeCache.objectForKey(messageData.hashValue) as? CGSize
        if cachedSize != nil {
            return cachedSize!
        }
        
        var finalSize = CGSizeZero
        // TODO: add media message calculation
        let avatarImageDiameter: CGFloat = (messageData.isOutgoingMessage) ? layout.outgoingAvatarImageViewDiameter : layout.incomingAvatarImageViewDiameter
        // Avatar container is 8.0 point away from bubble container view in horizontal, check xib for detail.
        let spacingBetweenAvatarAndBubble: CGFloat = 8.0
        let totalTextFrameHorizontalInsets: CGFloat = layout.messageBubbleTextViewFrameInsets.left + layout.messageBubbleTextViewFrameInsets.right
        let totalTextContainerHorizontalInsets: CGFloat = layout.messageBubbleTextViewTextContainerInsets.left + layout.messageBubbleTextViewTextContainerInsets.right
        
        let totalHorizontalInsets = spacingBetweenAvatarAndBubble + totalTextFrameHorizontalInsets + totalTextContainerHorizontalInsets
        let maxTextWidth = layout.itemWidth - avatarImageDiameter - layout.messageBubbleHorizontalMargin - totalHorizontalInsets
        
        let textRect = messageData.contentText.rectWithConstrainedWidth(maxTextWidth, font: layout.messageBodyFont)
        let textSize = CGRectIntegral(textRect).size
        
        let totalTextFrameVerticalInsets: CGFloat = layout.messageBubbleTextViewFrameInsets.top + layout.messageBubbleTextViewFrameInsets.bottom
        let totalTextContainerVerticalInsets: CGFloat = layout.messageBubbleTextViewTextContainerInsets.top + layout.messageBubbleTextViewTextContainerInsets.bottom
        
        // TODO: may need to fix the size offset caused by `bouncingRectWithSize`
        let totalVerticalInsets = totalTextFrameVerticalInsets + totalTextContainerVerticalInsets
        
        let finalWidth: CGFloat = max(textSize.width, self.minBubbleWidth)
        finalSize = CGSizeMake(finalWidth, textRect.height + totalVerticalInsets)
        
        return finalSize
    }
}

extension DUMessageSizeCalculator {
    override public var description: String { return String(format: "[%@ uses cache: %@, with minimumBubbleWidth: %@]", self.nameOfClass, self.sizeCache, self.minBubbleWidth) }
}