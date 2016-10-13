//
//  DUMediaPlaceholderView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

open class DUMediaPlaceholderView: UIView, PlaceholderStyle {
    var spinner: UIActivityIndicatorView
    
    public override init(frame: CGRect) {
        spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        adoptProtocolUIApperance()
        self.addSubview(spinner)
        spinner.center = self.center
        spinner.startAnimating()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = self.center
    }

}

