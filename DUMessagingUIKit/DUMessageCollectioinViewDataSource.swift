//
//  DUMessageCollectioinViewDataSource.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation


/// This dataSource requests for the data for each UI elements in the `DUMessageCollectionViewCell`.
public protocol DUMessageCollectionViewDataSource: UICollectionViewDataSource {

    /**
        Ask for the message data corresponding to the ginve location.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The collectionView which contains the message data.

        - returns: The message data instance which conforms to the protocol `DUMessageData`
     
        - seeaslo: `DUMessageData`
     */
    func messageData(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> DUMessageData
    /**
        Ask for the image that is used as the bubble image of the message cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An UIImage instance. Return `nil` to use default setting.
     
        - Note: It's highly recommended to use `DUBubbleImageFactory` to create bubble message image.
     */
    func messageBubbleImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage?
    /**
        Ask for the image that is used as the avatar image of the message cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An UIImage instance. Return `nil` to use default setting.
     
        - Note: It's highly recommended to use `DUAvatarImageFactory` to create avatar image.
     */
    func avatarImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage?
    /**
        Ask for the attributed text to be displayed in `cellTopLabel` at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An attributed string to be displayed. Return `nil` if you don't watn to display.

     */
    func attributedTextForCellTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString?
    /**
        Ask for the attributed text to be displayed in `messageBubbleTopLabel` at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An attributed string to be displayed. Return `nil` if you don't watn to display.
     
     */
    func attributedTextForMessageBubbleTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString?
    /**
        Ask for the attributed text to be displayed in `timeLabel` at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An attributed string to be displayed. Return `nil` if you don't watn to display.
     
     */
    func attributedTextForTiemLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString?
    /**
        Ask for the attributed text to be displayed in `readLabel` at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - colletionView: The parent collectionView.
     
        - returns: An attributed string to be displayed. Return `nil` if you don't watn to display.
     
     */
    func attributedTextForReadLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString?
    
    /**
     Ask for hidden value of `resendButton` in **outgoing** message cell. Just return true if the target cell is `DUMessagingIncomingCollectionViewCell`.
     
     - parameter indexPath: The indexPath to specify the cell location.
     - parameter collectionView: The parent collectionView
     
     - returns: A Bool value to determine that `resendButton` is hideen or not.
     
     - note: This property only works for `DUMessageOutgoingCollectionViewCell`.
     */
    func isHiddenForResendButton(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> Bool
}