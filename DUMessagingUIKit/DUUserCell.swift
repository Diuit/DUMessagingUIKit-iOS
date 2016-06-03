//
//  DUUserCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTModelStorage

class DUUserCell: UITableViewCell, ModelTransfer {

    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    func updateWithModel(model: DUUserData) {
        if model.displayName != "Add People" {
            self.selectionStyle = .None
        }
        userNameLabel.text = model.displayName
        userAvatarImage.layer.cornerRadius = userAvatarImage.frame.width/2
        userAvatarImage.clipsToBounds = true
        userAvatarImage.image = model.placeholderImage
    }
    
}
