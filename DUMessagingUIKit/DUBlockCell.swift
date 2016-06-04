//
//  DUBlockCell.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTModelStorage

/// Adoption this protocol to deal with the event of the block UISwitch from block cell
protocol DUBlockDelegate {
    func block()
    func unblock()
}

class DUBlockCell: UITableViewCell, ModelTransfer {
    
    @IBOutlet weak var blockSwitch: UISwitch!
    
    internal var delegate: DUBlockDelegate?
    
    @IBAction func stateChanged(switchState: UISwitch) {
        if blockSwitch.on {
            delegate?.block()
        } else {
            delegate?.unblock()
        }
    }
    func updateWithModel(model: Bool) {
        self.selectionStyle = .None
        blockSwitch.on = model
    }
}
