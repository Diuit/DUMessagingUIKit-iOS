//
//  DUMessageCollectionViewCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

/**
    Protocol `DUMessageCollectionViewCellDelegate` defines the interface of what you can interact with the collection view cell
 */
public protocol DUMessageCollectionViewCellDelegate {
    /**
        AvatarImageView of the cell has been tapped.
    
        - parameters:
            - cell: The cell that received tap event
     */
    func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell)
    /**
        Message bubble of the cell has been tapped.
     
        - parameters:
            - cell: The cell that received tap event
     */
    func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell)
    /**
     Message cell has been tapped.
     
        - parameters:
            - cell: The cell that received tap event
     
        - Note: This event only is *only* sent when the tap takes place out of the bounds of avatar image view or message bubble image view. Thus, there will only one event sent between `didTapAvatr`, `didTapMessageBubble` and `didTap`.
     
        - seealso: `didTapAvatar:`, `didTapMessageBubble:`
     */
    func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell)
}

/**
    Base class of collection view cell to display a single message data.
    
    - seealos: `DUMessageOutgoingCollectionViewCell` and `DUMessageIncomingCollectionViewCell`
 */
public class DUMessageCollectionViewCell: UICollectionViewCell {
    /// The label locates at the top of the cell, normally for timestamp display.
    @IBOutlet public weak var cellTopLabel: UILabel!
    /// The label beneath `cellTopLabel` and above message bubble container view, normally for sender information display.
    @IBOutlet public weak var messageBubbleTopLabel: UILabel!
    /// Container view for avatarImageView of the cell. This view is highly related to the layout, you should not do layout-related operation with the view.
    @IBOutlet public weak var avatarContainer: UIView!
    /// ImageView which displays avatar image.
    @IBOutlet public weak var avatarImageView: UIImageView!
    /// Container view for message bubble image and cell textView
    @IBOutlet public weak var bubbleContainer: UIView!
    /// ImageView for bubble image.
    @IBOutlet public weak var bubbleImageView: UIImageView!
    /// TextView contains the message text.
    @IBOutlet public weak var cellTextView: DUMessageCellTextView!
    /// Label which displays timestamp information.
    @IBOutlet public weak var timeLabel: UILabel!
    
    /// Delegate for all cell tap events.
    public var delegate: DUMessageCollectionViewCellDelegate?
    
    public var messageMediaView: UIView {
        didSet {
            bubbleImageView.removeFromSuperview()
            cellTextView.removeFromSuperview()
            
            messageMediaView.frame = bubbleContainer.bounds
            messageMediaView.translatesAutoresizingMaskIntoConstraints = false
            
            bubbleContainer.addSubview(messageMediaView)
            bubbleContainer.pingAlledge(ofSubview: messageMediaView)
            
            // For the reason of cell reuse, there may already be an antoher media view. Remove all message media subviews except current one.
            dispatch_async(dispatch_get_main_queue(), {[weak self] in
                if let _ = self?.bubbleContainer.subviews {
                    for sv in self!.bubbleContainer.subviews {
                        if sv != self?.messageMediaView {
                            sv.removeFromSuperview()
                        }
                    }
                }
            })
            
        }
    }

    override public var backgroundColor: UIColor? {
        didSet {
            cellTopLabel.backgroundColor = backgroundColor
            messageBubbleTopLabel.backgroundColor = backgroundColor
            timeLabel.backgroundColor = backgroundColor
            
            bubbleImageView.backgroundColor = backgroundColor
            avatarImageView.backgroundColor = backgroundColor
            
            bubbleContainer.backgroundColor = backgroundColor
            avatarContainer.backgroundColor = backgroundColor
        }
    }
    // constraints
    @IBOutlet private weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    
    private weak var tapGestureRecognize: UITapGestureRecognizer?
    
    // MARK: life cycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupCellViews()
        
    }
    
    deinit {
        delegate = nil
        tapGestureRecognize?.removeTarget(nil, action: nil)
        tapGestureRecognize = nil
    }
}

// Class method
public extension DUMessageCollectionViewCell {
    
    static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
    
    public static var cellReuseIdentifier: String { return self.nameOfClass }
    
    public static var mediaCellReuseIdentifier: String { return self.nameOfClass + "_Media" }
    
}

// Collection view cell
public extension DUMessageCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTopLabel.text = nil
        messageBubbleTopLabel.text = nil
        timeLabel.text = nil
        readLabel.text = nil
        
        cellTextView.dataDetectorTypes = .None
        cellTextView.text = nil
        cellTextView.attributedText = nil
        
        avatarImageView.image = nil
    }

    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let duLayoutAttributes = layoutAttributes as! DUCollectionViewLayouAttributes
        
        if cellTextView.font != duLayoutAttributes.messageBubbleFont {
            cellTextView.font = duLayoutAttributes.messageBubbleFont
        }
        
        cellTextView.textContainerInset = duLayoutAttributes.textViewTextContainerInsets
        
        update(layoutConstraint: cellTopLabelHeightConstraint, withConstant: duLayoutAttributes.cellTopLabelHeight)
        update(layoutConstraint: bubbleTopLabelHeightConstraint, withConstant: duLayoutAttributes.messageBubbleTopLabelHeight)
        update(layoutConstraint: bubbleContainerViewWidthConstraint, withConstant: duLayoutAttributes.messageBubbleContainerViewWidth)
        
        if self.isKindOfClass(DUMessageOutGoingCollectionViewCell) {
            update(layoutConstraint: avatarContainerViewWidthConstraint, withConstant: duLayoutAttributes.outgoingAvatarImageViewDiameter)
        } else {
            update(layoutConstraint: avatarContainerViewWidthConstraint, withConstant: duLayoutAttributes.incomingAvatarImageViewDiameter)
        }
        
    }

}

// Private methods
private extension DUMessageCollectionViewCell {
    func setupCellViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.whiteColor()
        
        cellTopLabelHeightConstraint.constant = 0.0
        bubbleTopLabelHeightConstraint.constant = 0.0
        
        cellTopLabel.textAlignment = .Center
        cellTopLabel.font = UIFont.DUChatroomDateFont()
        cellTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        messageBubbleTopLabel.font = UIFont.DUMessageSenderFont()!
        messageBubbleTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGestureOf(_:)))
        self.addGestureRecognizer(tap)
        tapGestureRecognize = tap
    }
    
    func update(layoutConstraint constraint: NSLayoutConstraint, withConstant constant: CGFloat) {
        if constraint.constant == constant { return }
        
        constraint.constant = constant
    }
    
    // Check where the tap gesture happened
    @objc func handleGestureOf(tap: UITapGestureRecognizer) {
        let touchPoint: CGPoint = tap.locationInView(self)
        
        if CGRectContainsPoint(avatarContainer.frame, touchPoint) {
            delegate?.didTapAvatar(ofMessageCollectionViewCell: self)
        } else if CGRectContainsPoint(bubbleContainer.frame, touchPoint) {
            delegate?.didTapMessageBubble(ofMessageCollectionViewCell: self)
        } else {
            delegate?.didTap(messageCollectionViewCell: self)
        }
    }
}
