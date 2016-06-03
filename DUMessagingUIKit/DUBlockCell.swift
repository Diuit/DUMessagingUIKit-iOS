//
//  DUBlockCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTModelStorage

class DUBlockCell: UITableViewCell, ModelTransfer {
    
    @IBOutlet weak var blockSwitch: UISwitch!
    
    func updateWithModel(model: Bool) {
        self.selectionStyle = .None
        blockSwitch.on = model
    }
}
