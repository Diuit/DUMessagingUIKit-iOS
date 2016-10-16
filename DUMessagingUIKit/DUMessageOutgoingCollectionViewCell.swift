//
//  DUMessageOutgoingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUMessageOutgoingCollectionViewCell: DUMessageCollectionViewCell {
    /// Button to resend the message.
    @IBOutlet weak var resendButton: UIButton!
    /// Label to indicate the status of message being read
    @IBOutlet weak var readLabel: UILabel!
    
    override open var backgroundColor: UIColor? {
        didSet {
            cellTopLabel.backgroundColor = backgroundColor
            messageBubbleTopLabel.backgroundColor = backgroundColor
            timeLabel.backgroundColor = backgroundColor
            readLabel.backgroundColor = backgroundColor
              
            bubbleImageView.backgroundColor = backgroundColor
            avatarImageView.backgroundColor = backgroundColor
            
            bubbleContainer.backgroundColor = backgroundColor
            avatarContainer.backgroundColor = backgroundColor
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .right
        timeLabel.textAlignment = .right
        readLabel.textAlignment = .right
        
        resendButton.isHidden = true
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        resendButton.isHidden = true
    }
}
