//
//  DUEdgeInsetableLabel.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/13.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUEdgeInsetableLabel: UILabel {
    
    public var textEdgeInsets: UIEdgeInsets {
        didSet {
            if !UIEdgeInsetsEqualToEdgeInsets(textEdgeInsets, oldValue) { setNeedsDisplay() }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override public init(frame: CGRect) {
        textEdgeInsets = UIEdgeInsets.zero
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        textEdgeInsets = UIEdgeInsets.zero
        super.init(coder: aDecoder)
        
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textEdgeInsets))
    }

}
