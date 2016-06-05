//
//  DUMessageOutGoingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageOutGoingCollectionViewCell: DUMessageCollectionViewCell {
    public override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .Right
        cellBottomLabel.textAlignment = .Right
    }

}
