//
//  DUMessageOutGoingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTModelStorage

public class DUMessageOutGoingCollectionViewCell: DUMessageCollectionViewCell, ModelTransfer {
    public override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .Right
        cellBottomLabel.textAlignment = .Right
    }
    
    public func updateWithModel(model: DUMessageData) {
        self.cellTextView.text = "hi"
    }

}
