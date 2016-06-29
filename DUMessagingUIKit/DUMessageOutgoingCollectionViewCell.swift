//
//  DUMessageOutgoingCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageOutgoingCollectionViewCell: DUMessageCollectionViewCell {
    /// Button to resend the message.
    @IBOutlet weak var resendButton: UIButton!
    /// Label to indicate the status of message being read
    @IBOutlet weak var readLabel: UILabel!
    
    override public var backgroundColor: UIColor? {
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

    public override func awakeFromNib() {
        super.awakeFromNib()
        messageBubbleTopLabel.textAlignment = .Right
        timeLabel.textAlignment = .Right
        readLabel.textAlignment = .Right
        cellTextView.textColor = GlobalUISettings.outgoingMessageTextColor
        
        resendButton.hidden = true
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        resendButton.hidden = true
        cellTextView.textColor = GlobalUISettings.outgoingMessageTextColor
    }
}
