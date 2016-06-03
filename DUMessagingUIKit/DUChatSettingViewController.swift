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

public class DUChatSettingViewController: UIViewController, DUChatSettingUIProtocol {

    @IBOutlet weak var chatAvatarImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DUChatSettingViewController.didTapChatTitleLabel(_:)))
            chatNameLabel.addGestureRecognizer(recognizer)
            chatNameLabel.userInteractionEnabled = true
        }
    }
    @IBOutlet weak var leaveChatButton: UIButton!
    
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

        chatNameLabel.text = chatDataForSetting?.chatTitle ?? "Chat room"
        leaveChatButton.addTarget(self, action: #selector(self.didPressLeaveChatButton(_:)), forControlEvents: .TouchUpInside)
        if chatDataForSetting?.chatSettingPageType == .Direct {
            leaveChatButton.hidden = true
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // adopt geometry-dependent ui
        adoptProtocolUIWithGeometry()
    }
    
    // MARK: Chat Setting view controller
    /// Click event of group-leaving button
    public func didPressLeaveChatButton(sender: UIButton) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    /// Tap gesture (Click event) of chat title label
    public func didTapChatTitleLabel(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let alertController = UIAlertController(title: "Change Name", message: "Enter a name for this chat", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            // FIXME: replace with protocol
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
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

public protocol DUChatSettingUIProtocol: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle, DTTableViewManageable {
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
        setupInheritedProtocolUI()
        
        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        
        if self.chatDataForSetting?.chatSettingPageType == .Direct {
            manager.registerCellClass(DUBlockCell.self)
            manager.registerNibNamed("DUBlockCell", forCellClass: DUBlockCell.self)
            manager.memoryStorage.setItems([chatDataForSetting?.isBlocked ?? false], forSectionIndex: 0)
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
        // uitable view
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    /// Views adopt here are gemoetry-dependent
    public func adoptProtocolUIWithGeometry() {
        chatAvatarImageView.layer.cornerRadius = chatAvatarImageView.frame.size.width/2
        chatAvatarImageView.clipsToBounds = true
        chatAvatarImageView.image = chatDataForSetting?.avatarPlaceholderImage ?? UIImage.DUDefaultPersonAvatarImage()
        // async load image
        chatDataForSetting?.loadImage() { [weak self] in
            self?.chatAvatarImageView.image = self?.chatDataForSetting?.imageValue ?? UIImage.DUDefaultPersonAvatarImage()
        }
    }
}