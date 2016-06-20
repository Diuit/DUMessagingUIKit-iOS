//
//  DUMediaContentViewFactory.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMediaContentViewFactory {
    public static func makeImageContentView(image: UIImage, frame: CGRect?) -> UIImageView {
        let imageView = UIImageView.init(frame: frame ?? CGRectMake(0,0, 212, 158))
        imageView.layer.cornerRadius = 14.0
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }
}
