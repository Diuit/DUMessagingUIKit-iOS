//
//  DUMessagesViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/5.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessaging
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class DUMessagesViewController: UIViewController, UITextViewDelegate, DUMessagInputToolbarDelegate, DUMessageCollectionViewFlowLayoutDelegate, DUMessageCollectionViewDataSource {
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
                refreshControl!.addTarget(self, action: #selector(loadEarlierMessages), for: .valueChanged)
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
                self.collectionView?.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
                self.collectionView?.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    fileprivate let outgoingCellIdentifier = DUMessageOutgoingCollectionViewCell.cellReuseIdentifier
    fileprivate let outgoingMediaCellIdentifier = DUMessageOutgoingCollectionViewCell.mediaCellReuseIdentifier
    fileprivate let incomingCellIdentifier = DUMessageIncomingCollectionViewCell.cellReuseIdentifier
    fileprivate let incomingMediaCellIdentifier = DUMessageIncomingCollectionViewCell.mediaCellReuseIdentifier
    // Defualt bubble images
    fileprivate let defaultOutgoingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(color: GlobalUISettings.outgoingMessageBubbleBackgroundColor)
    fileprivate let defaultIncomingBubbleImage: UIImage = DUMessageBubbleImageFactory.makeMessageBubbleImage(color: GlobalUISettings.incomingMessageBubbleBackgroundColor)
    // Default avatar images cache, an easy way
    fileprivate var avatarImageCache: [String: UIImage] = [:]
    // Cache for cell top label. The first message of the date will have its cell top label display the date. Still this is an easy way.
    fileprivate var theseDatesHaveMessagesCache: [String] = []
    
    // save keyboard height 
    fileprivate var keyboardFinalFrame: CGRect? = CGRect.zero

    var refreshControl: UIRefreshControl? = nil

    // MARK: Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        DUMessagesViewController.nib.instantiate(withOwner: self, options: nil)
        adoptProtocolUIApperance()
        setupMessagesViewController()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForNotification()
        // FIXME: workaround for #1 https://github.com/Diuit/DUMessagingUIKit-iOS/issues/1
        let keyboardHeight: CGFloat = (keyboardFinalFrame != nil) ? keyboardFinalFrame!.height : self.inputToolbar.bounds.size.height
        updateCollectionViewInsets(top: self.collectionView!.contentInset.top, bottom: keyboardHeight)
    }
    
    
    // FIXME: we remove notification in viewDidDisappear for temporary
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearForNotification()
    }
    
    deinit {
        collectionView?.delegate = nil
        collectionView?.dataSource = nil

        inputToolbar.inputToolbarDelegate = nil
        inputToolbar.contentView?.inputTextView.delegate = nil
    }

    
    // MARK: Initialization
    fileprivate func setupMessagesViewController() {
        inputToolbar.inputToolbarDelegate = self
        inputToolbar.contentView?.inputTextView.delegate = self
        // To make inputToolbar no parent view, so that it can be added onto inputAccessoryView
        inputToolbar.removeFromSuperview()
        inputToolbar.toggleSendButtonEnabled()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        // add a tap gesture for colleciotnview
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(messageCollectionView:)))
        collectionView?.addGestureRecognizer(tapGesture)
        
        updateCollectionViewInsets(top: self.topLayoutGuide.length, bottom: collectionView!.frame.maxY - self.inputToolbar!.frame.minY)
    }
    
    // MARK: Input
    
    override open var inputAccessoryView: UIView? { return self.inputToolbar }
    
    override open var canBecomeFirstResponder : Bool { return true }
    
    // MARK: DUMessagInputToolbarDelegate
    /// This is the delegate from `DUMessageInputToolbar`, indicating that if the send button is tapped.
    func didPressSendButton(_ sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        guard toolbar.contentView?.inputTextView.text.du_trimingWhitespace().characters.count > 0 else {
            return
        }
        didPress(sendButton: sender, withText: toolbar.contentView!.inputTextView.text)
    }
    /// This is the delegate from `DUMessageInputToolbar`, indicating that if the accessory button is tapped.
    func didPressAccessorySendButton(_ sender: UIButton, ofToolbar toolbar: DUMessageInputToolbar) {
        didPress(accessoryButton:sender)
    }
    
    
    // MARK: UIcollectionView DataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageData.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
        let cell: DUMessageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DUMessageCollectionViewCell
        cell.delegate = self

        if messageItem.isMediaMessage {
            cell.messageMediaView = messageItem.mediaItem?.getMediaContentView() ?? messageItem.mediaItem?.placeholderView
            if let du_messagItem = messageItem as? DUMessage {
                if messageItem.mediaItem?.type == .Image && du_messagItem.localImage == nil {
                    du_messagItem.loadImage() { [weak self] in
                        du_messagItem.localImage = du_messagItem.imageValue
                        self?.collectionView?.reloadItems(at: [indexPath])
                    }
                }
            }
        } else {
            cell.cellTextView.text = messageItem.contentText
            cell.cellTextView.textColor = (messageItem.isOutgoingMessage) ? GlobalUISettings.outgoingMessageTextColor : GlobalUISettings.incomingMessageTextColor
            cell.cellTextView.dataDetectorTypes = .all
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
            cell.resendButton.isHidden = duDataSource.isHiddenForResendButton(atIndexPath: indexPath, forCollectionView: du_collectionView)
        } else {
            cell.messageBubbleTopLabel.textEdgeInsets = UIEdgeInsetsMake(0, messageBubbleTopLabelInset, 0, 0)
        }

        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let du_collectionView = collectionView as! DUMessageCollectionView
        return du_collectionView.dequeueTypingIndicatorFooterView(forIndexPath: indexPath)
    }
    
    // MARK: UICollectionView Delegate Flow Layout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let du_collectionViewLayout = collectionViewLayout as! DUMessageCollectionViewFlowLayout
        return du_collectionViewLayout.sizeForItem(atIndexPath: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let du_collectionViewLayout = collectionViewLayout as? DUMessageCollectionViewFlowLayout {
            if self.displayTypingIndicator {
                return CGSize(width: du_collectionViewLayout.itemWidth, height: DUTypingIndicatorFooterView.itemHeight)
            } else {
                return CGSize.zero
            }
        }
        
        return CGSize.zero
    }
    
    // MARK: UITextViewDelegate
    open func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.becomeFirstResponder()
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        inputToolbar.toggleSendButtonEnabled()
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == inputToolbar.contentView?.inputTextView else {
            return
        }
        textView.resignFirstResponder()
    }
    
    // MARK: DUMessageCollectionViewDataSource - Default behavior
    open func messageData(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> DUMessageData {
        return messageData[(indexPath as NSIndexPath).item]
    }
    
    open func messageBubbleImage(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if messageItem.isOutgoingMessage {
            return defaultOutgoingBubbleImage
        } else {
            return defaultIncomingBubbleImage
        }
    }
    
    open func avatarImage(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> UIImage? {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if messageItem.isOutgoingMessage {
            return nil
        } else {
            let senderName = messageItem.senderDisplayName
            let initial: String = String(senderName[senderName.startIndex]).uppercased()
            // chck if the image is cached
            if avatarImageCache[initial] != nil {
                return avatarImageCache[initial]
            } else {
                let avatar = DUAvatarImageFactory.makeTextAvatarImage(text: initial, font: .DUChatAvatarFont(), diameter: DUAvatarImageFactory.kAvatarImageDefualtDiameterInMessags)!
                avatarImageCache[initial] = avatar
                return avatar
            }
        }
        
    }
    
    open func attributedTextForCellTopLabel(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        return nil
    }
    
    open func attributedTextForMessageBubbleTopLabel(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if messageItem.isOutgoingMessage {
            return nil
        } else { // only display sender for received messages
            return NSAttributedString(string: messageItem.senderDisplayName)
        }
    }
    
    open func attributedTextForTiemLabel(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        var attributedString: NSAttributedString
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        let dateStr = messageItem.date?.messageTimeLabelString ?? Date().messageTimeLabelString
        // if DUMessage object and with status of `FailedToSend`, display warning
        if let du_message = messageItem as? DUMessage {
            attributedString = (du_message.status == .failedToSend) ? NSAttributedString.DUDeliverWarningAttributed("Not Delivered") : NSAttributedString(string: dateStr)
        } else {
            attributedString = NSAttributedString(string: dateStr)
        }
        
        return attributedString
    }
    
    open func attributedTextForReadLabel(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> NSAttributedString? {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if let reads = messageItem.reads {
            if reads.count == 0 { return nil }
            
            let readLabelString = (reads.count > 1) ? String(format: "Read by %d", reads.count) : "Read"
            return NSAttributedString(string: readLabelString)
        } else {
            return nil
        }
    }
    
    open func isHiddenForResendButton(atIndexPath indexPath: IndexPath, forCollectionView collectionView: DUMessageCollectionView) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as? DUMessageCollectionViewCell
        guard let _ = cell as? DUMessageOutgoingCollectionViewCell , cell != nil else {
            // not outgoing cell, always return true
            return true
        }
        
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if let du_message = messageItem as? DUMessage {
            // show button when not delivered
            return du_message.status != .notDelivered
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
    open func didPress(sendButton button: UIButton, withText: String) {
        assert(false, "Error! You must override this method: \(#function)")
    }
    /**
     This method is called when you clicked accessory button in the `inputToolbar`. Overriding this is required.
     
     - parameter sender: The accessory button clicked.
     */
    open func didPress(accessoryButton button: UIButton) {
        assert(false, "Error! You must override this method: \(#function)")
    }
    
    /**
     Override this function with your "loading earlier messages" method. This method is triggered by UIRefreshControl in the message collection view.
     
     - important: Make sure to call `endLoadingEarlierMessages` after you complete loading earlier messages to end animation of refresh control and reload the collection view.
     
     - seealso: `endLoadingEarlierMessages`
     */
    open func loadEarlierMessages() {
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
        
        collectionView?.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
        collectionView?.reloadData()
    }
    
    /**
     You must call this method after you sent a new message ( append the new message to your message data source ). This method does:
     1. Hide the typing indicator.
     3. Reload the collection view and layout.
     3. Scroll to the latest message location with or without animation, which can be decided by the animated parameter.
     
     - parameter animated: Specify the scrolling action to the latest message is anmiated or not. Default value is `true`.
     */
    final public func endSendingMessage(_ animated: Bool = true) {
        inputToolbar.contentView?.inputTextView.text = nil
        // FIXME: need to send a notification to input text view to change its frame after sending messages
        
        inputToolbar.toggleSendButtonEnabled()
        
        collectionView?.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
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
    final public func endReceivingMessage(_ animated: Bool = true) {
        displayTypingIndicator = false

        collectionView?.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
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
    final public func scrollToBottom(_ animated: Bool) {
        guard collectionView?.numberOfSections != 0 else { return }
        guard collectionView?.numberOfItems(inSection: 0) != 0 else { return }
        
        let lastIndexPath: IndexPath = IndexPath(item: collectionView!.numberOfItems(inSection: 0) - 1, section: 0)
        scrollTo(indexPath: lastIndexPath, animated: animated)
    }
    
    fileprivate func scrollTo(indexPath: IndexPath, animated: Bool) {
        guard collectionView?.numberOfSections > (indexPath as NSIndexPath).section else {
            return
        }
        
        // XXX: When the content height is smaller than collection view height, scoll to indexPath or recttovisible does not work well.(bug, huh?)
        //      So if the difference height is less than input toolbar height, we manually set the offset.
        //      If you know how to solve this, send a PR please.
        let layout = collectionView?.collectionViewLayout as! DUMessageCollectionViewFlowLayout
        if layout.collectionViewContentSize.height < collectionView?.bounds.size.height {
            // XXX: Also need to consider extraMessageCollectionViewBottomInset height
            if abs(collectionView!.bounds.size.height - layout.collectionViewContentSize.height) <= inputToolbar.bounds.height + GlobalUISettings.extraMessageCollectionViewBottomInset {
                collectionView?.setContentOffset(CGPoint(x: 0, y: inputToolbar.bounds.height + GlobalUISettings.extraMessageCollectionViewBottomInset - abs(collectionView!.bounds.size.height - layout.collectionViewContentSize.height)), animated: animated)
            } else {
                collectionView?.scrollRectToVisible(CGRect(x: 0, y: layout.collectionViewContentSize.height - 1, width: 1, height: 1), animated: animated)
            }
            return
        }
        
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: animated)
    }
    
    // MARK: DUMessageCollectionViewFlowLayout Delegate - Default behavior
    open func heightForCellTopLabel(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        return 0.0
    }
    
    open func heightForMessageBubbleTopLabel(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if messageItem.isOutgoingMessage { return 0.0 }
        else { return 20.0 }
    }
    
    open func diameterForAvatarContainer(at indexPath: IndexPath, with layout: DUMessageCollectionViewFlowLayout, collectionView: DUMessageCollectionView) -> CGFloat {
        let messageItem = messageData[(indexPath as NSIndexPath).item]
        if messageItem.isOutgoingMessage { return 0.0 }
        else { return DUAvatarImageFactory.kAvatarImageDefualtDiameterInMessags }
    }
    
    // MARK: DUMessageCollectionViewCell Delegate - default behavior
    open func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        assert(false, "tapped avatar, please implement '\(#function)' to deal with this event.")
    }
    
    open func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
        assert(false, "tapped message bubble, please implement '\(#function)' to deal with this event.")
    }
    
    open func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell) {
        assert(false, "tapped message cell, please implement '\(#function)' to deal with this event.")
    }
    
    // MARK: DUMessageCollectionView
    open func didTap(messageCollectionView view: DUMessageCollectionView) {
        print("Tapped messageCollectionView, please implemnt '\(#function)' to deal with this event.")
    }
}


// MARK: Class method
public extension DUMessagesViewController {
    /// Return UINib object of `DUMessagesViewController`.
    static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: Bundle.du_messagingUIKitBundle) }
}

// MARK: private helper
private extension DUMessagesViewController {
    func updateCollectionViewInsets(top: CGFloat, bottom: CGFloat) {
        let insets: UIEdgeInsets = UIEdgeInsetsMake(top, 0.0, bottom + GlobalUISettings.extraMessageCollectionViewBottomInset, 0.0)
        self.collectionView?.contentInset = insets
        self.collectionView?.scrollIndicatorInsets = insets
    }
    
    func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func clearForNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func didReceiveKeyboardWillChangeFrame(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        keyboardFinalFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        if keyboardFinalFrame == nil { return }
        
        var animateOption: UIViewAnimationOptions
        if let animationCurveInt = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            animateOption = UIViewAnimationOptions(rawValue: animationCurveInt<<16)
        } else {
            // XXX: I choosse a random default animate option here
            animateOption = UIViewAnimationOptions.curveEaseOut
        }
        
        let animateDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        UIView.animate(withDuration: animateDuration!, delay: 0.0, options: animateOption, animations: { [unowned self] in
            self.updateCollectionViewInsets(top: self.collectionView!.contentInset.top, bottom: self.keyboardFinalFrame!.height)
            }, completion: nil)
    }
}


// MARK: DUMessageCollectionViewCell Delegate - default behavior
extension DUMessagesViewController: DUMessageCollectionViewCellDelegate{
//    public func didTapAvatar(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
//        assert(false, "tapped avatar, please implement '\(#function)' to deal with this event.")
//    }
//
//    public func didTapMessageBubble(ofMessageCollectionViewCell cell: DUMessageCollectionViewCell) {
//        assert(false, "tapped message bubble, please implement '\(#function)' to deal with this event.")
//    }
//
//    public func didTap(messageCollectionViewCell cell: DUMessageCollectionViewCell) {
//        assert(false, "tapped message cell, please implement '\(#function)' to deal with this event.")
//    }
}

// MARK: DUMessageCollectionView - private method
extension DUMessagesViewController {
    fileprivate func messageCollectionViewTapHandler(_ sender: UITapGestureRecognizer) {
        if let _ = self.collectionView {
            didTap(messageCollectionView: self.collectionView!)
        }
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
    open var myBarTitle: String { return "Messages" }
    
    open var rightBarButtonText: String? { return nil }
    open var rightBarButtonImage: UIImage? { return UIImage.DUSettingsIcon() }
    open var myBarButtonType: UIBarButtonType { return .imageButton }
    open func didClick(rightBarButton: UIBarButtonItem?) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    public func adoptProtocolUIApperance() {
        // setup all inherited UI protocols
        setupInheritedProtocolUI()
    }
}
