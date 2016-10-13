//
//  DUMessageCollectionView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/11.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit


/// This collection view holds and displays message items with given customized layout.
open class DUMessageCollectionView: UICollectionView {
    
    //public weak var du_dataSource: DUMessageCollectionViewDataSource?
    //public weak var layoutDelegate: DUMessageCollectionViewFlowLayoutDelegate?

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
}

// MARK: Typing indicator
public extension DUMessageCollectionView {
    /**
     Returns a `DUTypingIndicatorFooterView` object at given indexPath.
     
     - parameter indexPath: The indexPath specifies the location of supplementary footer view.
     
     - returns: A `DUTypingIndicatorFooterView` object.
     */
    public func dequeueTypingIndicatorFooterView(forIndexPath indexPath: IndexPath) -> DUTypingIndicatorFooterView {
        let footerView: DUTypingIndicatorFooterView = super.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: DUTypingIndicatorFooterView.footerViewReuseIdentifier, for: indexPath) as! DUTypingIndicatorFooterView
        
        return footerView
    }
}

private extension DUMessageCollectionView {
    func configureCollectionView() {
        backgroundColor = UIColor.white
        keyboardDismissMode = .interactive
        alwaysBounceVertical = true
        bounces = true
        
        register(DUMessageOutgoingCollectionViewCell.nib, forCellWithReuseIdentifier: DUMessageOutgoingCollectionViewCell.cellReuseIdentifier)
        register(DUMessageOutgoingCollectionViewCell.nib, forCellWithReuseIdentifier: DUMessageOutgoingCollectionViewCell.mediaCellReuseIdentifier)
        
        register(DUMessageIncomingCollectionViewCell.nib, forCellWithReuseIdentifier: DUMessageIncomingCollectionViewCell.cellReuseIdentifier)
        register(DUMessageIncomingCollectionViewCell.nib, forCellWithReuseIdentifier: DUMessageIncomingCollectionViewCell.mediaCellReuseIdentifier)
        
        register(DUTypingIndicatorFooterView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: DUTypingIndicatorFooterView.footerViewReuseIdentifier)
    }
}
