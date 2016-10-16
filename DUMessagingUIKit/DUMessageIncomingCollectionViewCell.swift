//
//  DUMessageIncomingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUMessageIncomingCollectionViewCell: DUMessageCollectionViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .left
        timeLabel.textAlignment = .left
        cellTextView.textColor = GlobalUISettings.incomingMessageTextColor
    }

}
