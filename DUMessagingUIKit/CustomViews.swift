//
//  CustomViews.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/3.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

/// This is a customized UILabel where their text alway align in top vertically
@IBDesignable public class TopAlignedLabel: UILabel {
    override public func drawTextInRect(rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), CGFloat.max),
                                                                            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: font],
                                                                            context: nil).size
            super.drawTextInRect(CGRectMake(0, 0, CGRectGetWidth(self.frame), ceil(labelStringSize.height)))
        } else {
            super.drawTextInRect(rect)
        }
    }
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackColor().CGColor
    }
}

@IBDesignable public class DUAvatarImageView: UIImageView, CircleShapeView, DUImageResource {
    // Automatically load the image right after its url is set
    public var imagePath: String? = "" {
        didSet {
            if self.imagePath != "" {
                self.loadImage() { [weak self] in
                    self?.image = self?.imageValue
                }
            }
        }
    }
}

public class RoundUIView: UIView, CircleShapeView { }