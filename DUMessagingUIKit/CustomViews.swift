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
@IBDesignable open class TopAlignedLabel: UILabel {
    override open func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
                                                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: font],
                                                                            context: nil).size
            super.drawText(in: CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}

@IBDesignable open class DUAvatarImageView: UIImageView, CircleShapeView, DUImageResource {
    // Automatically load the image right after its url is set
    open var imagePath: String? = "" {
        didSet {
            if self.imagePath != "" {
                self.loadImage() { [weak self] in
                    self?.image = self?.imageValue
                }
            }
        }
    }
}

open class RoundUIView: UIView, CircleShapeView { }
