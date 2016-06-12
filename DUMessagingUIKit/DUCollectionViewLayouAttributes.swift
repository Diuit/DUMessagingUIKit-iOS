//
//  DUCollectionViewLayouAttributes.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/11.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

/**
    This class holds all layout attributes related in `DUMessageCollectionView`
 */
public class DUCollectionViewLayouAttributes: UICollectionViewLayoutAttributes {
    /**
        This value defines the height of top label for the message cell in the collectionView
     
        - warning: This value must be no less than `0`
     */
    public var cellTopLabelHeight: CGFloat = 20.0
    {
        willSet {
            assert(newValue >= 0.0, "cell top label height can not be less than 0")
        }
    }
    /**
         This value defines the height of message bubble top label for the message cell in the collectionView
         
         - warning: This value must be no less than `0`
     */
    public var messageBubbleTopLabelHeight: CGFloat = 20.0
    {
        willSet {
            assert(newValue >= 0.0, "message bubble top label height can not be less than 0")
        }
    }
    /**
        This value indicates the width of bubble container view.
     
        - warning: This value must be greater than `0.0`
     */
    public var messageBubbleContainerViewWidth: CGFloat = 230.0
    {
        willSet {
            assert(newValue > 0.0, "message bubble container view width must be greater than 0.0")
        }
    }
    /**
        This value defines specifies the diameter of outgoing avatar imageView
     
        - warning: This value must be no less than `0`
     
        - note: Set to zero to hide the avatar imageView
     */
    public var outgoingAvatarImageViewDiameter: CGFloat = 32.0
    {
        willSet {
            assert(newValue >= 0.0, "outgoing avatar imageView diameter can not be less than 0")
        }
    }
    /**
         This value defines specifies the diameter of incoming avatar imageView
         
         - warning: This value must be no less than `0`
         
         - note: Set to zero to hide the avatar imageView
     */
    public var incomingAvatarImageViewDiameter: CGFloat = 32.0
    {
        willSet {
            assert(newValue >= 0.0, "incoming avatar imageView diameter can not be less than 0")
        }
    }
    /// The font of textView within the message cell.
    public var messageBubbleFont: UIFont = UIFont.DUChatBodyFriendFont()!
    /// The inset of the frame of the textView in `DUMessageCollectionViewCell`
    public var cellTextViewFrameInset: UIEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
    /// The inset of the text container in textView of `DUMessageCollectionViewCell`
    public var textViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
}

