//
//  DUChatCell.swift
//  DUMessagingUI
//
//  Created by Pofat Diuit on 2016/5/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit
import DUMessaging
import DTModelStorage

/// Custom UITableViewCell for displaying information of a DUChat instance
public class DUChatCell: UITableViewCell, ModelTransfer {
    @IBOutlet weak var chatAvatarImageView: UIImageView!
    @IBOutlet weak var chatTitleLabel: UILabel!
    @IBOutlet weak var chatDetailLabel: UILabel!
    @IBOutlet weak var chatAccessoryLabel: UILabel!
    @IBOutlet weak var unreadView: UIImageView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setSelectedBackgroundView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSelectedBackgroundView()
    }
    
    public func updateWithModel(model: DUChatData) {
        //self.textLabel?.text = model.chatTitle
        
        self.chatAvatarImageView.layer.cornerRadius = self.chatAvatarImageView.frame.size.width/2
        self.chatAvatarImageView.clipsToBounds = true
        self.chatAvatarImageView.image = model.avatarPlaceholderImage
        // async load image
        model.loadImage() { [ weak self ] in
            self?.chatAvatarImageView.image = model.imageValue
        }
        
        // set up data
        self.chatTitleLabel.text = model.chatTitle
        self.chatDetailLabel.text = model.chatDetailText
        self.chatAccessoryLabel.text = model.chatAccessoryText
        
        if model.hasUnreadMessage {
            self.chatTitleLabel.font = UIFont.DUUnreadTitleFont()
            // FIXME: switch to use global main color
            self.chatTitleLabel.textColor = UIColor.DUUnreadBlackColor()
            
            self.chatAccessoryLabel.font = UIFont.DUBodyTimeUnreadFont()
            self.chatAccessoryLabel.textColor = UIColor.DUWaterBlueColor()
            
            self.unreadView.hidden = false
            self.unreadView.layer.cornerRadius = self.unreadView.frame.size.width/2
            self.unreadView.clipsToBounds = true
            self.unreadView.image = UIImage.imageWithColor(UIColor.DUWaterBlueColor())
        } else {
            self.chatTitleLabel.font = UIFont.DUSubheadFont()
            self.chatTitleLabel.textColor = UIColor.blackColor()
            
            self.chatAccessoryLabel.font = UIFont.DUBodyTimeFont()
            self.chatAccessoryLabel.textColor = UIColor.DUDarkGreyColor()
            
            self.unreadView.hidden = true
        }
 
    }
    
    /*
    public func bindChat(chatItem:DUChatData) {
        self.hasUnread = chatItem.hasUnreadMessage

        self.chatAvatarImageView.layer.cornerRadius = self.chatAvatarImageView.frame.size.width/2
        self.chatAvatarImageView.clipsToBounds = true
        self.chatAvatarImageView.image = chatItem.avatarPlaceholderImage
        // async load image
        chatItem.loadImage() { [ weak self ] in
            self?.chatAvatarImageView.image = chatItem.imageValue
        }
        
        // set up data
        self.chatTitleLabel.text = chatItem.chatTitle
        self.chatDetailLabel.text = chatItem.chatDetailText
        self.chatAccessoryLabel.text = chatItem.chatAccessoryText
        
        if self.hasUnread {
            self.chatTitleLabel.font = UIFont.DUUnreadTitleFont()
            // FIXME: switch to use global main color
            self.chatTitleLabel.textColor = UIColor.DUUnreadBlackColor()
            
            self.chatAccessoryLabel.font = UIFont.DUBodyTimeUnreadFont()
            self.chatAccessoryLabel.textColor = UIColor.DUWaterBlueColor()
            
            self.unreadView.hidden = false
            self.unreadView.layer.cornerRadius = self.unreadView.frame.size.width/2
            self.unreadView.clipsToBounds = true
            self.unreadView.image = UIImage.imageWithColor(UIColor.DUWaterBlueColor())
        } else {
            self.chatTitleLabel.font = UIFont.DUSubheadFont()
            self.chatTitleLabel.textColor = UIColor.blackColor()
            
            self.chatAccessoryLabel.font = UIFont.DUBodyTimeFont()
            self.chatAccessoryLabel.textColor = UIColor.DUDarkGreyColor()
            
            self.unreadView.hidden = true
        }
    }
    */
    // MARK: private method
    private func setSelectedBackgroundView() {
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor.DULightgreyColor()
        self.selectedBackgroundView = selectedBgView
    }
    
}
