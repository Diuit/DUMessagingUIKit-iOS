//
//  DUMessageIncomingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageIncomingCollectionViewCell: DUMessageCollectionViewCell {
    public override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .Left
        timeLabel.textAlignment = .Left
        readLabel.textAlignment = .Left
    }

}
