//
//  DUUserCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTModelStorage

/// Display user information
class DUUserCell: UITableViewCell, ModelTransfer {

    @IBOutlet weak var userAvatarImage: DUAvatarImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    func updateWithModel(model: DUUserData) {
        if model.userDisplayName != "Add People" {
            self.selectionStyle = .None
        }
        userNameLabel.text = model.userDisplayName
        if model.imagePath != nil {
            userAvatarImage.imagePath = model.imagePath
        }
    }
    
}
