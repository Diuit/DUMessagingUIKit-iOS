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
open class DUChatCell: UITableViewCell, ModelTransfer {
    @IBOutlet weak var chatAvatarImageView: DUAvatarImageView!
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
    
    open func update(with model: DUChatData) {
        self.chatAvatarImageView.image = model.avatarPlaceholderImage
        self.chatAvatarImageView.imagePath = model.imagePath

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
            
            self.unreadView.isHidden = false
            self.unreadView.layer.cornerRadius = self.unreadView.frame.size.width/2
            self.unreadView.clipsToBounds = true
            self.unreadView.image = UIImage.imageWith(backgroundColor: UIColor.DUWaterBlueColor())
        } else {
            self.chatTitleLabel.font = UIFont.DUSubheadFont()
            self.chatTitleLabel.textColor = UIColor.black
            
            self.chatAccessoryLabel.font = UIFont.DUMessageTimeLabelFont()
            self.chatAccessoryLabel.textColor = UIColor.DUDarkGreyColor()
            
            self.unreadView.isHidden = true
        }
 
    }
    
    // MARK: private method
    fileprivate func setSelectedBackgroundView() {
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor.DULightgreyColor()
        self.selectedBackgroundView = selectedBgView
    }
    
}
