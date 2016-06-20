//
//  DUMediaPlaceholderView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUMediaPlaceholderView: UIView, PlaceholderStyle {
    public init() {
        let frame = CGRectMake(0, 0, 212, 158)
        super.init(frame: frame)
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
        self.addSubview(spinner)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

