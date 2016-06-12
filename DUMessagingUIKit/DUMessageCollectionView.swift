//
//  DUMessageCollectionView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/11.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit


/// This collection view holds and displays message items with given customized layout.
public class DUMessageCollectionView: UICollectionView {

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
}

private extension DUMessageCollectionView {
    func configureCollectionView() {
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = .Interactive
        alwaysBounceVertical = true
        bounces = true
        
        // TODO: register nib for all cell class
        
        
    }
}
