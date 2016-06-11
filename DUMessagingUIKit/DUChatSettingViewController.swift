//
//  DUChatSettingViewController.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/30.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessaging
import DTTableViewManager

// global constant
public let DUTableViewCellReuseIdentifier = "DUTableViewCellReuseIdentifier"

/**
    The `DUChatSettingViewController` class is an abstract class for displaying information of a chat room and configuring chat data with customize methods.
 */
public class DUChatSettingViewController: UIViewController, DUChatSettingUIProtocol, DTTableViewManageable, DUBlockDelegate {

    @IBOutlet weak var chatAvatarImageView: DUAvatarImageView! {
        didSet {
            chatAvatarImageView.image = chatDataForSetting?.avatarPlaceholderImage ?? UIImage.DUDefaultPersonAvatarImage()
            // XXX(Pofat) set image path will load the image
            chatAvatarImageView.imagePath = chatDataForSetting?.imagePath
        }
    }
    @IBOutlet weak var chatNameLabel: UILabel! {
        didSet {
            // set text
            chatNameLabel.text = chatDataForSetting?.chatTitle ?? "Chat room"
            // add tap listener
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DUChatSettingViewController.didTapChatTitleLabel(_:)))
            chatNameLabel.addGestureRecognizer(recognizer)
            chatNameLabel.userInteractionEnabled = true
        }
    }
    @IBOutlet weak var leaveChatButton: UIButton! {
        didSet {
            leaveChatButton.addTarget(self, action: #selector(self.didPressLeaveChatButton(_:)), forControlEvents: .TouchUpInside)
            if chatDataForSetting?.chatSettingPageType == .Direct {
                leaveChatButton.hidden = true
            }
        }
    }
    @IBOutlet weak public var tableView: UITableView!
    
    public var chatDataForSetting: DUChatData? = nil
    static var nib: UINib { return UINib.init(nibName: String(DUChatSettingViewController), bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
    
    // MARK: life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        DUChatSettingViewController.nib.instantiateWithOwner(self, options: nil)
        // adopt ui protocol
        adoptProtocolUIApperance()

        // setup tableView
        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        
        if self.chatDataForSetting?.chatSettingPageType == .Direct {
            manager.registerCellClass(DUBlockCell.self)
            manager.registerNibNamed("DUBlockCell", forCellClass: DUBlockCell.self)
            manager.memoryStorage.setItems([chatDataForSetting?.isBlocked ?? false], forSectionIndex: 0)
            let c: DUBlockCell = manager.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! DUBlockCell
                //manager.itemForCellClass(DUBlockCell.self, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            c.delegate = self
        } else {
            manager.registerCellClass(DUUserCell.self)
            manager.registerNibNamed("DUUserCell", forCellClass: DUUserCell.self)
            let addUser: UserData = UserData.init(name: "Add People", imagePath: nil)
            addUser.placeholderImage = UIImage.DUAddUserImage()
            manager.memoryStorage.setItems([addUser], forSectionIndex: 0)
            var membersArray: [UserData] = []
            for member in self.chatDataForSetting!.chatMembers {
                membersArray.append(UserData.init(name: member, imagePath: nil))
            }
            manager.memoryStorage.setItems(membersArray, forSectionIndex: 1)
        }
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard self.chatDataForSetting?.chatSettingPageType == .Group && indexPath.section == 1 else {
            return nil
        }
        let block = UITableViewRowAction(style: .Normal, title: "Block") { [weak self] action, index in
            // TODO: protocol function here
            self?.didPressCellBlockAction(atIndexPath: indexPath)
        }
        block.backgroundColor = UIColor.lightGrayColor()
        
        let remove = UITableViewRowAction(style: .Normal, title: "Remove") { [weak self] action, index in
            // TODO: function here
            self?.didPressCellRemoveAction(atIndexPath: indexPath)
        }
        remove.backgroundColor = UIColor.redColor()
        
        return [remove, block]
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard self.chatDataForSetting?.chatSettingPageType == .Group && indexPath.section == 1 else {
            return false
        }
        return true
    }
    
    // MARK: Chat Setting view controller events

    /// Click event of Leave Group button
    public func didPressLeaveChatButton(sender: UIButton) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Block action of user tableViewCell in a group chat room
    public func didPressCellBlockAction(atIndexPath indexPath: NSIndexPath) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Remove action of user tableViewCell in a group chat room
    public func didPressCellRemoveAction(atIndexPath indexPath: NSIndexPath) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// OK alertAction in chat-title-changing AlertController
    public func didPressOKForChangingChatTitle() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Implement how to block this user
    public func block() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Implement how to unblock this user
    public func unblock() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    /// Tap gesture handler of chat title label
    public func didTapChatTitleLabel(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let alertController = UIAlertController(title: "Change Name", message: "Enter a name for this chat", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            // FIXME: replace with protocol
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { [weak self] alerAction in
                self?.didPressOKForChangingChatTitle()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.addTextFieldWithConfigurationHandler({ textField in
                textField.placeholder = "New name"
                textField.text = self.chatDataForSetting?.chatTitle ?? ""
            })
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: UI protocol for self
public protocol DUChatSettingUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle {
    var chatDataForSetting: DUChatData? { get set }
}
public extension DUChatSettingUIProtocol where Self: DUChatSettingViewController {
    var myBarTitle: String {
        if self.chatDataForSetting?.chatSettingPageType == .Direct {
            return "Detail"
        } else {
            return "Group"
        }
    }
    
    func adoptProtocolUIApperance() {
        // setup all inherited UI protocols
        setupInheritedProtocolUI()
    }
}