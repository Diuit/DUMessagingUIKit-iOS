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
public protocol DUMessageCollectionViewCellDelegate: class {
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
open class DUMessageCollectionViewCell: UICollectionViewCell {
    /// The label locates at the top of the cell, normally for timestamp display.
    @IBOutlet public weak var cellTopLabel: UILabel!
    /// The label beneath `cellTopLabel` and above message bubble container view, normally for sender information display.
    @IBOutlet public weak var messageBubbleTopLabel: DUEdgeInsetableLabel!
    /// Container view for avatarImageView of the cell. This view is highly related to the layout, you should not do layout-related operation with the view.
    @IBOutlet public weak var avatarContainer: UIView!
    /// ImageView which displays avatar image.
    @IBOutlet public weak var avatarImageView: DUAvatarImageView!
    /// Container view for message bubble image and cell textView
    @IBOutlet public weak var bubbleContainer: UIView!
    /// ImageView for bubble image.
    @IBOutlet public weak var bubbleImageView: UIImageView!
    {
        // Default corner radius value
        didSet {
            bubbleImageView.layer.cornerRadius = 14.0
            bubbleImageView.clipsToBounds = true
        }
    }
    /// TextView contains the message text.
    @IBOutlet public weak var cellTextView: DUMessageCellTextView!
    /*
    {
        didSet {
            if self.isKindOfClass(DUMessageOutgoingCollectionViewCell) {
                cellTextView.textColor = GlobalUISettings.outgoingMessageTextColor
            } else {
                cellTextView.textColor = GlobalUISettings.incomingMessageTextColor
            }
        }
    }
 */
    /// Label which displays timestamp information.
    @IBOutlet public weak var timeLabel: UILabel!
    
    /// Delegate for all cell tap events.
    open weak var delegate: DUMessageCollectionViewCellDelegate?
    /// This view weill be displayed when the message is a media message.
    public var messageMediaView: UIView? = nil
    {
        didSet {
            if messageMediaView != nil {
                bubbleImageView?.removeFromSuperview()
                cellTextView?.removeFromSuperview()
                
                messageMediaView!.frame = bubbleContainer.bounds
                messageMediaView!.translatesAutoresizingMaskIntoConstraints = false
                
                bubbleContainer.addSubview(messageMediaView!)
                bubbleContainer.pingAlledge(ofSubview: messageMediaView!)
                
                // For the reason of cell reuse, there may already be an antoher media view. Remove all message media subviews except current one.
                DispatchQueue.main.async(execute: {[weak self] in
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
    }

    override open var backgroundColor: UIColor?
    {
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
    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate weak var tapGestureRecognize: UITapGestureRecognizer?
    
    // MARK: life cycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        setupCellViews()
        
    }
    
    deinit {
        delegate = nil
        tapGestureRecognize?.removeTarget(nil, action: nil)
        tapGestureRecognize = nil
    }
    
    
    // Collection view cell
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        cellTopLabel.text = nil
        messageBubbleTopLabel.text = nil
        messageBubbleTopLabel.textEdgeInsets = UIEdgeInsets.zero
        timeLabel.text = nil
        
        cellTextView?.dataDetectorTypes = UIDataDetectorTypes()
        cellTextView?.text = nil
        cellTextView?.attributedText = nil
        
        avatarImageView.image = nil
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let duLayoutAttributes = layoutAttributes as! DUCollectionViewLayouAttributes
        
        if cellTextView?.font != duLayoutAttributes.messageBubbleFont {
            cellTextView?.font = duLayoutAttributes.messageBubbleFont
        }
        
        cellTextView?.textContainerInset = duLayoutAttributes.textViewTextContainerInsets
        
        update(layoutConstraint: cellTopLabelHeightConstraint, withConstant: duLayoutAttributes.cellTopLabelHeight)
        update(layoutConstraint: bubbleTopLabelHeightConstraint, withConstant: duLayoutAttributes.messageBubbleTopLabelHeight)
        update(layoutConstraint: bubbleContainerViewWidthConstraint, withConstant: duLayoutAttributes.messageBubbleContainerViewWidth)
        
        if self.isKind(of: DUMessageOutgoingCollectionViewCell.self) {
            update(layoutConstraint: avatarContainerViewWidthConstraint, withConstant: duLayoutAttributes.outgoingAvatarImageViewDiameter)
        } else {
            update(layoutConstraint: avatarContainerViewWidthConstraint, withConstant: duLayoutAttributes.incomingAvatarImageViewDiameter)
        }
        
    }
}

// Class method
public extension DUMessageCollectionViewCell {
    
    static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: Bundle.du_messagingUIKitBundle) }
    
    public static var cellReuseIdentifier: String { return self.nameOfClass }
    
    public static var mediaCellReuseIdentifier: String { return self.nameOfClass + "_Media" }
    
}

// Private methods
private extension DUMessageCollectionViewCell {
    func setupCellViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        
        cellTopLabelHeightConstraint.constant = 0.0
        bubbleTopLabelHeightConstraint.constant = 0.0
        
        cellTopLabel.textAlignment = .center
        cellTopLabel.font = UIFont.DUChatroomDateFont()
        cellTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        messageBubbleTopLabel.font = UIFont.DUMessageSenderFont()
        messageBubbleTopLabel.textColor = UIColor.DUDarkGreyColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGestureOf(tap:)))
        self.addGestureRecognizer(tap)
        tapGestureRecognize = tap
    }
    
    func update(layoutConstraint constraint: NSLayoutConstraint, withConstant constant: CGFloat) {
        if constraint.constant == constant { return }
        
        constraint.constant = constant
    }
    
    // Check where the tap gesture happened
    @objc func handleGestureOf(tap: UITapGestureRecognizer) {
        let touchPoint: CGPoint = tap.location(in: self)
        
        if avatarContainer.frame.contains(touchPoint) {
            delegate?.didTapAvatar(ofMessageCollectionViewCell: self)
        } else if bubbleContainer.frame.contains(touchPoint) {
            delegate?.didTapMessageBubble(ofMessageCollectionViewCell: self)
        } else {
            delegate?.didTap(messageCollectionViewCell: self)
        }
    }
}
