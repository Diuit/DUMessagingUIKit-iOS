//
//  DUMessageCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet public weak var cellTopLabel: UILabel!
    @IBOutlet public weak var messageBubbleTopLabel: UILabel!
    @IBOutlet public weak var cellBottomLabel: UILabel!
    
    @IBOutlet public weak var avatarContainer: UIView!
    @IBOutlet public weak var avatarImageView: UIImageView!
    
    @IBOutlet public weak var bubbleContainer: UIView!
    @IBOutlet public weak var bubbleImageView: UIImageView!
    @IBOutlet public weak var cellTextView: DUMessageCellTextView!
    
    @IBOutlet public weak var timeLabel: UILabel!
    @IBOutlet public weak var resendButton: UILabel!
    
    // constraints
    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellBottomHeightConstraint: NSLayoutConstraint!
    
    public static var cellReuseIdentifier: String { return DUMessageCollectionViewCell.nameOfClass }
    public static var mediaCellReuseIdentifier: String { return DUMessageCollectionViewCell.nameOfClass + "_Media" }
    
    private weak var tapGestureRecognize: UITapGestureRecognizer?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupCellViews()
        
    }
    
    // MARK: private helper
    private func setupCellViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.whiteColor()
        
        cellTopLabelHeightConstraint.constant = 0.0
        bubbleTopLabelHeightConstraint.constant = 0.0
        cellBottomHeightConstraint.constant = 0.0
        
        cellTopLabel.textAlignment = .Center
        cellTopLabel.font = UIFont.DUChatroomDateFont()
        cellTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        messageBubbleTopLabel.font = UIFont.DUMessageSenderFont()!
        messageBubbleTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        cellBottomLabel.font = UIFont.DUChatroomDateFont()
        cellBottomLabel.textColor = UIColor.DUDarkGreyColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(du_handleTapGesture(_:)))
        self.addGestureRecognizer(tap)
        tapGestureRecognize = tap
    }
    
    // Check where the tap gesture happened
    @objc private func du_handleTapGesture(tap: UITapGestureRecognizer) {
        let touchPoint: CGPoint = tap.locationInView(self)
        
        if CGRectContainsPoint(avatarContainer.frame, touchPoint) {
            // call tap avatar method of delegate
        } else if CGRectContainsPoint(bubbleContainer.frame, touchPoint) {
            // call message bubble tap method of delegate
        } else {
            // call cell tap method of delegate
        }
    }
}
