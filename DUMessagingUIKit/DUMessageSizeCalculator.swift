//
//  DUMessageSizeCalculator.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

// XXX: Minimum width is total horizontal text container edge insets
private let defaultMinimumBubbleWidth: CGFloat = 28.0
// XXX: Minimum width can not be less than avatar, otherwise avatar will be cut. Set to default avatar size 32.0
private let defaultMinimumBubbleHeight: CGFloat = 32.0


open class DUMessageSizeCalculator: NSObject {
    
    // FIXME: use this cache to store calculated results
    fileprivate var sizeCache: NSCache<AnyObject, AnyObject>
    fileprivate var minBubbleWidth: CGFloat
    fileprivate var minBubbleHeight: CGFloat
    
    public init(cache: NSCache<AnyObject, AnyObject>, minimumBubbleWidth: CGFloat, minimumBubbleHeight: CGFloat) {
        assert(minimumBubbleWidth > 0, "minimum message bubble width can not be less than 0")
        
        sizeCache = cache
        minBubbleWidth = minimumBubbleWidth
        minBubbleHeight = minimumBubbleHeight
        super.init()
    }
    
    override convenience init() {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "DUMessageSizeCalculator.cache"
        cache.countLimit = 200
        self.init(cache: cache, minimumBubbleWidth: defaultMinimumBubbleWidth, minimumBubbleHeight: defaultMinimumBubbleHeight)
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
    func messageBubbleSize(forMessageData messageData: DUMessageData, atIndexPath indexPath: IndexPath, withLayout layout: DUMessageCollectionViewFlowLayout) -> CGSize {
//        let cachedSize = sizeCache.object(forKey: messageData.hashValue as AnyObject)
//        if cachedSize != nil {
//            return cachedSize!
//        }
        
        var finalSize = CGSize.zero
        let avatarImageDiameter: CGFloat = (messageData.isOutgoingMessage) ? layout.outgoingAvatarImageViewDiameter : layout.incomingAvatarImageViewDiameter
        
        if messageData.isMediaMessage {
            finalSize = messageData.mediaItem!.mediaDisplaySize
        } else {
            // Avatar container is 8.0 point away from bubble container view in horizontal, check xib for detail. But seems we don't need that
            let spacingBetweenAvatarAndBubble: CGFloat = 0.0
            let totalTextFrameHorizontalInsets: CGFloat = layout.messageBubbleTextViewFrameInsets.left + layout.messageBubbleTextViewFrameInsets.right
            let totalTextContainerHorizontalInsets: CGFloat = layout.messageBubbleTextViewTextContainerInsets.left + layout.messageBubbleTextViewTextContainerInsets.right
            
            let totalHorizontalInsets = spacingBetweenAvatarAndBubble + totalTextFrameHorizontalInsets + totalTextContainerHorizontalInsets
            // XXX:(Pofat) - need to fix evaluate result of String. The offset it +10. However, consider the case that may exceed maxWidth, we minus this 10 pt before we evaluate the string size. And add that 10 back.
            let maxTextWidth = layout.itemWidth - avatarImageDiameter - layout.messageBubbleHorizontalMargin - totalHorizontalInsets
            
            let textRect = messageData.contentText!.rectWithConstrainedWidth(maxTextWidth, font: layout.messageBodyFont)
            let textSize = CGSize(width: textRect.size.width, height: textRect.size.height)
            
            let totalTextFrameVerticalInsets: CGFloat = layout.messageBubbleTextViewFrameInsets.top + layout.messageBubbleTextViewFrameInsets.bottom
            let totalTextContainerVerticalInsets: CGFloat = layout.messageBubbleTextViewTextContainerInsets.top + layout.messageBubbleTextViewTextContainerInsets.bottom
            
            let totalVerticalInsets = totalTextFrameVerticalInsets + totalTextContainerVerticalInsets
            let finalWidth: CGFloat = max(textSize.width + totalHorizontalInsets, self.minBubbleWidth)
            let finalHeight: CGFloat = max(textSize.height + totalVerticalInsets, self.minBubbleHeight)
            finalSize = CGSize(width: finalWidth, height: finalHeight)
        }
        
        return finalSize
    }
}

extension DUMessageSizeCalculator {
    override open var description: String { return String(format: "[%@ uses cache: %@, with minimumBubbleWidth: %@]", self.nameOfClass, self.sizeCache, self.minBubbleWidth) }
}
