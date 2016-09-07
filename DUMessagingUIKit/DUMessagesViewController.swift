//
//  DUMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessaging

public class DUMessagesViewController: UIViewController, UITextViewDelegate, DUMessagInputToolbarDelegate, DUMessageCollectionViewFlowLayoutDelegate, DUMessageCollectionViewDataSource {
    /// Input tool bar object
    @IBOutlet public weak var inputToolbar: DUMessageInputToolbar!
    /// Messages collection view object
    @IBOutlet public weak var collectionView: DUMessageCollectionView?
    /// Chat room object, must conform to protocol `DUChatData`
    public var chat: DUChatData? = nil
    /// Message data array. You may put the messages you want to display in this array.
    public var messageData: [DUMessageData] = []
    /// Set to `true` if you want to enable pull to refresh function. Default value is false.
    /// - important: If you enable this, you also have to override `loadEarlierMessages` with your custome method to load earlier messages
    public var enableRefreshControl: Bool = false
    {
        didSet {
            if enableRefreshControl {
                refreshControl = UIRefreshControl()
                refreshControl?.tintColor = UIColor.DUDarkGreyColor()
                refreshControl!.attributedTitle = NSAttributedString(string: "Loading earlier messages", attributes: [NSFontAttributeName: UIFont.DUChatroomDateFont(), NSForegroundColorAttributeName: UIColor.DUDarkGreyColor()])
                refreshControl!.addTarget(self, action: #selector(loadEarlierMessages), forControlEvents: .ValueChanged)
                collectionView?.addSubview(refreshControl!)
            } else {
                refreshControl?.removeFromSuperview()
                refreshControl = nil
            }
            
        }
    }
    
    /// Set to `true` to show typing indicator and `false` to hide it.
    public var displayTypingIndicator: Bool = false
    {
        didSet {
            if displayTypingIndicator != oldValue {
                self.collectionView?.collectionViewLayout.invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    private let outgoingCellIdentifier = DUMessageOutgoingCollectionViewCell.cellReuseIdentifier
    private let outgoingMediaCellIdentifier = DUMessageOutgoingCollectionViewCell.mediaCellReuseIdentifier
    private let incomingCellIdentifier = DUMessageIncomingCollectionViewCell.cellReuseIdentifier
    private let incomingMediaCellIdentifier = DUMessageIncomingCollectionViewCell.mediaCellReuseIdentifier
    // Defualt bubble images
    private let defaultOutgoingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(GlobalUISettings.outgoingMessageBubbleBackgroundColor)
    private let defaultIncomingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(GlobalUISettings.incomingMessageBubbleBackgroundColor)
    // Default avatar images cache, an easy way
    private var avatarImageCache: [String: UIImage] = [:]
    // Cache for cell top label. The first message of the date will have its cell top label display the date. Still this is an easy way.
    private var theseDatesHaveMessagesCache: [String] = []

    var refreshControl: UIRefreshControl? = nil

    // MARK: Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        DUMessagesViewController.nib.instantiateWithOwner(self, options: nil)
        adoptProtocolUIApperance()
        setupMessagesViewController()
        registerForNotification()
    }
    
    
    // FIXME: for current controller can not be released due to unfound retain cycle, we remove notification in viewDidDisappear for temporary
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        clearForNotification()
    }
    deinit {
        collectionView?.delegate = nil
        collectionView?.dataSource = nil

        inputToolbar.inputToolbarDelegate = self
        inputToolbar.contentView?.inputTextView.delegate = nil
    }
    
    // MARK: Initialization
    private func setupMessagesViewController() {
        inputToolbar.inputToolbarDelegate = self
        inputToolbar.contentView?.inputTextView.delegate = self
        // To make inputToolbar no parent view, so that it can be added onto inputAccessoryView
        inputToolbar.removeFromSuperview()
        inputToolbar.toggleSendButtonEnabled()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        updateCollectionViewInsets(top: self.topLayoutGuide.length, bottom: CGRectGetMaxY(collectionView!.frame) - CGRectGetMinY(self.inputToolbar!.frame))
    }
    
    // MARK: Input
    
    override public var inputAccessoryView: UIView? { return self.inputToolbar }
    
    override public func canBecomeFirstResponder() -> Bool { return true }
    
    // MARK: DUMessagInputToolbarDelegate
    /// This is the delegate from `DUMessageInputToolbar`, indicating that if the send button is tapped.
    func didPressSendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        guard toolbar.contentView?.inputTextView.text.du_trimingWhitespace().characters.count > 0 else {
            return
        }
        didPress(sendButton: sender, withText: toolbar.contentView!.inputTextView.text)
    }
    /// This is the delegate from `DUMessageInputToolbar`, indicating that if the accessory button is tapped.
    func didPressAccessorySendButton(sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        didPress(accessoryButton:sender)
    }
    
    
    // MARK: UIcollectionView DataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageData.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let _ = collectionView as? DUMessageCollectionView else {
            assert(false, "Error collectionView class : \(collectionView.nameOfClass), supposed to be \(DUMessageCollectionView.nameOfClass)")
            return UICollectionViewCell() // this line will not be executed for previous assertion
        }
        
        let du_collectionView = collectionView as! DUMessageCollectionView
        let du_collectionViewLayout = du_collectionView.collectionViewLayout as! DUMessageCollectionViewFlowLayout
        
        var messageItem = messageData(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        var cellIdentifier: String = ""
        if messageItem.isOutgoingMessage {
            if messageItem.isMediaMessage {
                cellIdentifier = self.outgoingMediaCellIdentifier
            } else {
                cellIdentifier = self.outgoingCellIdentifier
            }
        } else {
            if messageItem.isMediaMessage {
                cellIdentifier = self.incomingMediaCellIdentifier
            } else {
                cellIdentifier = self.incomingCellIdentifier
            }
        }
        
        let cell: DUMessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! DUMessageCollectionViewCell
        cell.delegate = self

        if messageItem.isMediaMessage {
            cell.messageMediaView = messageItem.mediaItem?.getMediaContentView() ?? messageItem.mediaItem?.placeholderView
        } else {
            cell.cellTextView.text = messageItem.contentText
            cell.cellTextView.textColor = (messageItem.isOutgoingMessage) ? GlobalUISettings.outgoingMessageTextColor : GlobalUISettings.incomingMessageTextColor
            cell.cellTextView.dataDetectorTypes = .All
        }
        
        assert(du_collectionView.dataSource != nil, "DataSource is nil, couldn't get correct layout attributes")
        let duDataSource = du_collectionView.dataSource as! DUMessageCollectionViewDataSource
        cell.bubbleImageView?.image = duDataSource.messageBubbleImage(atIndexPath: indexPath, forCollectionView: du_collectionView)
        
        var hasAvatar: Bool = true
        if messageItem.isOutgoingMessage && du_collectionViewLayout.outgoingAvatarImageViewDiameter == 0.0 {
            hasAvatar = false
        } else if !messageItem.isOutgoingMessage && du_collectionViewLayout.incomingAvatarImageViewDiameter == 0.0 {
            hasAvatar = false
        }
        
        // To make the text in message bubble top labl align to the edge (which closest to the avatar) of bubble conatiner
        var messageBubbleTopLabelInset: CGFloat = 0

        if hasAvatar {
            cell.avatarImageView.image = duDataSource.avatarImage(atIndexPath: indexPath, forCollectionView: du_collectionView)
            
            messageBubbleTopLabelInset += (messageItem.isOutgoingMessage) ? du_collectionViewLayout.outgoingAvatarImageViewDiameter : du_collectionViewLayout.incomingAvatarImageViewDiameter
            // XXX: 8 is the space between avatar container and bubble container (if there has avatar). Check the collection view cell nib.
            messageBubbleTopLabelInset += 8.0
        } else {
            cell.avatarImageView.image = nil
        }
        
        // to align the text in message bubble text view
        messageBubbleTopLabelInset += (messageItem.isOutgoingMessage) ?
            (du_collectionViewLayout.messageBubbleTextViewFrameInsets.right + du_collectionViewLayout.messageBubbleTextViewTextContainerInsets.right) :
            (du_collectionViewLayout.messageBubbleTextViewFrameInsets.left + du_collectionViewLayout.messageBubbleTextViewTextContainerInsets.left)

        cell.cellTopLabel.attributedText = duDataSource.attributedTextForCellTopLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
        cell.messageBubbleTopLabel.attributedText = duDataSource.attributedTextForMessageBubbleTopLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
        cell.timeLabel.attributedText = duDataSource.attributedTextForTiemLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)

        if messageItem.isOutgoingMessage {
            let cell = cell as! DUMessageOutgoingCollectionViewCell
            cell.readLabel.attributedText = duDataSource.attributedTextForReadLabel(atIndexPath: indexPath, forCollectionView: du_collectionView)
            cell.messageBubbleTopLabel.textEdgeInsets = UIEdgeInsetsMake(0, 0, 0, messageBubbleTopLabelInset)
            cell.resendButton.hidden = duDataSource.isHiddenForResendButton(atIndexPath: indexPath, forCollectionView: du_collectionView)
        } else {
            cell.messageBubbleTopLabel.textEdgeInsets = UIEdgeInsetsMake(0, messageBubbleTopLabelInset, 0, 0)
        }

        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let du_collectionView = collectionView as! DUMessageCollectionView
        return du_collectionView.dequeueTypingIndicatorFooterView(forIndexPath: indexPath)
    }
    
    // MARK: UICollectionView Delegate Flow Layout
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let du_collectionViewLayout = collectionViewLayout as! DUMessageCollectionViewFlowLayout
        return du_collectionViewLayout.sizeForItem(atIndexPath: indexPath)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let du_collectionViewLayout = collectionViewLayout as? DUMessageCollectionViewFlowLayout {
            if self.displayTypingIndicator {
                return CGSizeMake(du_collectionViewLayout.itemWidth, DUTypingIndicatorFooterView.itemHeight)
            } else {
                return CGSizeZero
            }
        }
        
        return CGSizeZero
    }
    
    // MARK: UITextViewDelegate
    public func textViewDidBeginEditing(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.becomeFirstResponder()
    }
    
    public func textViewDidChange(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        inputToolbar.toggleSendButtonEnabled()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.resignFirstResponder()
    }
    
    // MARK: DUMessageCollectionViewDataSource - Default behavior
    public func messageData(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> DUMessageData {
        return messageData[indexPath.item]
    }
    
    public func messageBubbleImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[indexPath.item]
        if messageItem.isOutgoingMessage {
            return defaultOutgoingBubbleImage
        } else {
            return defaultIncomingBubbleImage
        }
    }
    
    public func avatarImage(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[indexPath.item]
        if messageItem.isOutgoingMessage {
            return nil
        } else {
            let senderName = messageItem.senderDisplayName
            let initial: String = String(senderName[senderName.startIndex]).uppercaseString
            // chck if the image is cached
            if avatarImageCache[initial] != nil {
                return avatarImageCache[initial]
            } else {
                let avatar = DUAvatarImageFactory.makeAvatarImage(initial, font: UIFont.DUChatAvatarFont(), diameter: DUAvatarImageFactory.kAvatarImageDefualtDiameterInMessags)!
                avatarImageCache[initial] = avatar
                return avatar
            }
        }
        
    }
    
    public func attributedTextForCellTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        return nil
    }
    
    public func attributedTextForMessageBubbleTopLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[indexPath.item]
        if messageItem.isOutgoingMessage {
            return nil
        } else { // only display sender for received messages
            return NSAttributedString(string: messageItem.senderDisplayName)
        }
    }
    
    public func attributedTextForTiemLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        var attributedString: NSAttributedString
        let messageItem = messageData[indexPath.item]
        let dateStr = messageItem.date?.messageTimeLabelString ?? ""
        // if DUMessage object and with status of `FailedToSend`, display warning
        if let du_message = messageItem as? DUMessage {
            attributedString = (du_message.status == .FailedToSend) ? NSAttributedString.DUDeliverWarningAttributed("Not Delivered") : NSAttributedString(string: dateStr)
        } else {
            attributedString = NSAttributedString(string: dateStr)
        }
        
        return attributedString
    }
    
    public func attributedTextForReadLabel(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[indexPath.item]
        if let reads = messageItem.reads {
            if reads.count == 0 { return nil }
            
            let readLabelString = (reads.count > 1) ? String(format: "Read by %d", reads.count) : "Read"
            return NSAttributedString(string: readLabelString)
        } else {
            return nil
        }
    }
    
    public func isHiddenForResendButton(atIndexPath indexPath: NSIndexPath, forCollectionView collectionView: DUMessageCollectionView) -> Bool {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DUMessageCollectionViewCell
        guard let _ = cell as? DUMessageOutgoingCollectionViewCell where cell != nil else {
            // not outgoing cell, always return true
            return true
        }
        
        let messageItem = messageData[indexPath.item]
        if let du_message = messageItem as? DUMessage {
            // show button when not delivered
            return du_message.status != .NotDelivered
        } else {
            // not a DUMessage object, cannot parse
            return true
        }
        
    }
    // MARK: DUMessages ViewController
    /**
     This method is called when you clicked send text button in the `inputToolbar`. Overriding this is required.
     
     - parameter sender:   The send button clicked.
     - parameter withText: The text contnet in `inputTextView`.
     */
    public func didPress(sendButton button: UIButton, withText: String) {
        assert(false, "Error! You must override this method: \(#function)")
    }
    /**
     This method is called when you clicked accessory button in the `inputToolbar`. Overriding this is required.
     
     - parameter sender: The accessory button clicked.
     */
    public func didPress(accessoryButton button: UIButton) {
        assert(false, "Error! You must override this method: \(#function)")
    }
    
    /**
     Override this function with your "loading earlier messages" method. This method is triggered by UIRefreshControl in the message collection view.
     
     - important: Make sure to call `endLoadingEarlierMessages` after you complete loading earlier messages to end animation of refresh control and reload the collection view.
     
     - seealso: `endLoadingEarlierMessages`
     */
    public func loadEarlierMessages() {
        print("loading earlier messages")
        endLoadingEarlierMessages()
    }
    
    /**
     You must call this method after you complete loading earlier messages. This method does:
     1. Hide the refresh control.
     2. Reload the collection view and layout.

     - important: If you don't do this after loading, the refresh control will always be visibel.
     */
    final public func endLoadingEarlierMessages() {
        refreshControl?.endRefreshing()
        
        collectionView?.collectionViewLayout.invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
        collectionView?.reloadData()
    }
    
    /**
     You must call this method after you sent a new message ( append the new message to your message data source ). This method does:
     1. Hide the typing indicator.
     3. Reload the collection view and layout.
     3. Scroll to the latest message location with or without animation, which can be decided by the animated parameter.
     
     - parameter animated: Specify the scrolling action to the latest message is anmiated or not. Default value is `true`.
     */
    final public func endSendingMessage(animated: Bool = true) {
        inputToolbar.contentView?.inputTextView.text = nil
        // FIXME: need to send a notification to input text view to change its frame after sending messages
        
        inputToolbar.toggleSendButtonEnabled()
        
        collectionView?.collectionViewLayout.invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
        collectionView?.reloadData()
        
        // set last message if using duchat object
        if let du_hcat = chat as? DUChat  {
            if let du_message = messageData.last as? DUMessage {
                du_hcat.lastMessage = du_message
            }
        }
        scrollToBottom(animated)
    }
    
    /**
     You must call this method after you receive a new message ( append the new message to your message data source ). This method does:
     1. Hide the typing indicator.
     3. Reload the collection view and layout.
     3. Scroll to the latest message location with or without animation, which can be decided by the animated parameter.
     
     - parameter animated: Specify the scrolling action to the latest message is anmiated or not. Default value is `true`.
     */
    final public func endReceivingMessage(animated: Bool = true) {
        displayTypingIndicator = false

        collectionView?.collectionViewLayout.invalidateLayoutWithContext(UICollectionViewFlowLayoutInvalidationContext())
        collectionView?.reloadData()
        
        // update last message if useing duchat
        if let du_chat = chat as? DUChat {
            if let du_message = messageData.last as? DUMessage {
                du_chat.lastMessage = du_message
            }
        }
        
        scrollToBottom(animated)
    }
    
    /// Scroll to the bottom of message collection view with or without animation.
    /// - parameter animated: Set this value to enable or disable animation
    final public func scrollToBottom(animated: Bool) {
        guard collectionView?.numberOfSections() != 0 else { return }
        guard collectionView?.numberOfItemsInSection(0) != 0 else { return }
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: collectionView!.numberOfItemsInSection(0) - 1, inSection: 0)
        scrollTo(indexPath: lastIndexPath, animated: animated)
    }
    
    private func scrollTo(indexPath indexPath: NSIndexPath, animated: Bool) {
        guard collectionView?.numberOfSections() > indexPath.section else {
            return
        }
        
        // XXX: When the content height is smaller than collection view height, scoll to indexPath or recttovisible does not work well.(bug, huh?)
        //      So if the difference height is less than 44 (navigation bar height), we manually set the offset.
        //      If you know how to solve this, send a PR please.
        let layout = collectionView?.collectionViewLayout as! DUMessageCollectionViewFlowLayout
        if layout.collectionViewContentSize().height < collectionView?.bounds.size.height {
            if abs(collectionView!.bounds.size.height - layout.collectionViewContentSize().height) <= 44 {
                collectionView?.setContentOffset(CGPointMake(0, 44 - abs(collectionView!.bounds.size.height - layout.collectionViewContentSize().height)), animated: animated)
            } else {
                collectionView?.scrollRectToVisible(CGRectMake(0, layout.collectionViewContentSize().height - 1, 1, 1), animated: animated)
            }
            return
        }
        
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: animated)
    }
}


// MARK: Class method
public extension DUMessagesViewController {
    /// Return UINib object of `DUMessagesViewController`.
    static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: NSBundle.du_messagingUIKitBundle) }
}

// MARK: private helper
private extension DUMessagesViewController {
    func updateCollectionViewInsets(top top: CGFloat, bottom: CGFloat) {
        let insets: UIEdgeInsets = UIEdgeInsetsMake(top, 0.0, bottom, 0.0)
        self.collectionView?.contentInset = insets
        self.collectionView?.scrollIndicatorInsets = insets
    }
    
    func registerForNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceiveKeyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func clearForNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func didReceiveKeyboardWillChangeFrame(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFinalFrame: CGRect? = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        if keyboardFinalFrame == nil { return }
        
        var animateOption: UIViewAnimationOptions
        if let animationCurveInt = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.unsignedIntegerValue {
            animateOption = UIViewAnimationOptions(rawValue: animationCurveInt<<16)
        } else {
            // XXX: I choosse a random default animate option here
            animateOption = UIViewAnimationOptions.CurveEaseOut
        }
        
        let animateDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        UIView.animateWithDuration(animateDuration!, delay: 0.0, options: animateOption, animations: { [unowned self] in
            self.updateCollectionViewInsets(top: self.collectionView!.contentInset.top, bottom: CGRectGetHeight(keyboardFinalFrame!))
            }, completion: nil)
    }
}


// MARK: DUMessageCollectionViewFlowLayout Delegate - Default behavior
public extension DUMessageCollectionViewFlowLayoutDelegate where Self: DUMessagesViewController {
    public func heightForCellTopLabel(at indexPath: NSIndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        return 0.0
    }
    
    public func heightForMessageBubbleTopLabel(at indexPath: NSIndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        let messageItem = messageData[indexPath.item]
        if messageItem.isOutgoingMessage { return 0.0 }
        else { return 20.0 }
    }
    
    public func diameterForAvatarContainer(at indexPath: NSIndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        let messageItem = messageData[indexPath.item]
        if messageItem.isOutgoingMessage { return 0.0 }
        else { return DUAvatarImageFactory.kAvatarImageDefualtDiameterInMessags }
    }
}


// MARK: DUMessageCollectionViewCell Delegate - default behavior
extension DUMessagesViewController: DUMessageCollectionViewCellDelegate{
    public func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        //print("tapped avatar, please implement '\(#function)' to deal with this event.")
    }

    public func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        //print("tapped message bubble, please implement '\(#function)' to deal with this event.")
    }

    public func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell) {
        //print("tapped message cell, please implement '\(#function)' to deal with this event.")
    }
}

// MARK: message data helper
public extension DUMessageData {
    var isOutgoingMessage: Bool {
        if self is DUMessage {
            guard DUMessaging.currentUser != nil else {
                return false
            }
            
            let mySelf = self as! DUMessage
            guard mySelf.senderUser != nil else {
                return false
            }
            
            if mySelf.senderUser!.serial == DUMessaging.currentUser!.serial {
                return true
            }
        }
        return false
    }
}

// MARK: Gathering UI Protocol
public protocol DUMessagesUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle, RightBarButton {}
extension DUMessagesViewController: DUMessagesUIProtocol {
    public var myBarTitle: String { return "Messages" }
    
    public var rightBarButtonText: String? { return nil }
    public var rightBarButtonImage: UIImage? { return UIImage.DUSettingsIcon() }
    public var myBarButtonType: UIBarButtonType { return .imageButton }
    public func didClickRightBarButton(sender: UIBarButtonItem?) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    public func adoptProtocolUIApperance() {
        // setup all inherited UI protocols
        setupInheritedProtocolUI()
    }
}