//
//  DUMessageCollectionViewFlowLayoutDelegate.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation


/// This delegate helps to manage all UILabels' layout infomration in `DUMessageCollectionViewCell`.
public protocol DUMessageCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    /**
        Ask for the height of `cellTopLabel` at certain collevtionView cell.
     
     - parameters:
        - indexPath: The indexPath to specify the cell location.
        - layout: The layout object
        - colletionView: The parent collectionView.
     
     - returns: A CGFlot value to specify the height of the label. Return `0.0` if you don't watn to display it.
     */
    func heightForCellTopLabel(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat
    /**
        Ask for the height of `messageBubbleTopLabel` at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - layout: The layout object
            - colletionView: The parent collectionView.
     
        - returns: A CGFlot value to specify the height of the label. Return `0.0` if you don't watn to display it.
     */
    func heightForMessageBubbleTopLabel(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat
    /**
        Ask for the diameter of `avatarContainer`, which holds an avatar image view at certain collevtionView cell.
     
        - parameters:
            - indexPath: The indexPath to specify the cell location.
            - layout: The layout object
            - colletionView: The parent collectionView.
     
        - returns: A CGFlot value to specify the diameter of avatar. Return `0.0` if you don't watn to display it.
     */
    func diameterForAvatarContainer(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat
}
