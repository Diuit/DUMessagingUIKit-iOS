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
open class DUChatSettingViewController: UIViewController, DUChatSettingUIProtocol, DTTableViewManageable, DUBlockDelegate {

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
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DUChatSettingViewController.didTapChatTitleLabel(sender:)))
            chatNameLabel.addGestureRecognizer(recognizer)
            chatNameLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var leaveChatButton: UIButton! {
        didSet {
            leaveChatButton.addTarget(self, action: #selector(self.didPressLeaveChatButton(_:)), for: .touchUpInside)
            if chatDataForSetting?.chatSettingPageType == .direct {
                leaveChatButton.isHidden = true
            }
        }
    }
    @IBOutlet weak public var tableView: UITableView!
    
    public var chatDataForSetting: DUChatData? = nil
    static var nib: UINib { return UINib.init(nibName: String(describing: DUChatSettingViewController.self), bundle: Bundle.du_messagingUIKitBundle) }
    
    // MARK: life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        DUChatSettingViewController.nib.instantiate(withOwner: self, options: nil)
        // adopt ui protocol
        adoptProtocolUIApperance()

        // setup tableView
        manager.startManaging(withDelegate: self)
        
        
        if self.chatDataForSetting?.chatSettingPageType == .direct {
            manager.register(DUBlockCell.self)
            manager.registerNibNamed("DUBlockCell", for: DUBlockCell.self)
            manager.memoryStorage.setItems([chatDataForSetting?.isBlocked ?? false], forSection: 0)
            let c: DUBlockCell = manager.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! DUBlockCell
                //manager.itemForCellClass(DUBlockCell.self, atIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            c.delegate = self
        } else {
            manager.register(DUUserCell.self)
            manager.registerNibNamed("DUUserCell", for: DUUserCell.self)
            var addUser: UserData = UserData.init(name: "Add People", imagePath: nil)
            addUser.placeholderImage = UIImage.DUAddUserImage()
            manager.memoryStorage.setItems([addUser], forSection: 0)
            var membersArray: [UserData] = []
            for member in self.chatDataForSetting!.chatMembers {
                membersArray.append(UserData.init(name: member, imagePath: nil))
            }
            manager.memoryStorage.setItems(membersArray, forSection: 1)
        }
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard self.chatDataForSetting?.chatSettingPageType == .group && indexPath.section == 1 else {
            return nil
        }
        let block = UITableViewRowAction(style: .normal, title: "Block") { [weak self] action, index in
            // TODO: protocol function here
            self?.didPressCellBlockAction(atIndexPath: indexPath)
        }
        block.backgroundColor = UIColor.lightGray
        
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { [weak self] action, index in
            // TODO: function here
            self?.didPressCellRemoveAction(atIndexPath: indexPath)
        }
        remove.backgroundColor = UIColor.red
        
        return [remove, block]
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        guard self.chatDataForSetting?.chatSettingPageType == .group && indexPath.section == 1 else {
            return false
        }
        return true
    }
    
    // MARK: Chat Setting view controller events

    /// Click event of Leave Group button
    open func didPressLeaveChatButton(_ sender: UIButton) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Block action of user tableViewCell in a group chat room
    open func didPressCellBlockAction(atIndexPath indexPath: IndexPath) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Remove action of user tableViewCell in a group chat room
    open func didPressCellRemoveAction(atIndexPath indexPath: IndexPath) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// OK alertAction in chat-title-changing AlertController
    open func didPressOKForChangingChatTitle() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Implement how to block this user
    open func block() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    /// Implement how to unblock this user
    open func unblock() {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    /// Tap gesture handler of chat title label
    open func didTapChatTitleLabel(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let alertController = UIAlertController(title: "Change Name", message: "Enter a name for this chat", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            // FIXME: replace with protocol
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] alerAction in
                self?.didPressOKForChangingChatTitle()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.addTextField(configurationHandler: { textField in
                textField.placeholder = "New name"
                textField.text = self.chatDataForSetting?.chatTitle ?? ""
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: UI protocol for self
public protocol DUChatSettingUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle {
    var chatDataForSetting: DUChatData? { get set }
}
public extension DUChatSettingUIProtocol where Self: DUChatSettingViewController {
    var myBarTitle: String {
        if self.chatDataForSetting?.chatSettingPageType == .direct {
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
