//
//  DUMediaContentView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

/// Content view to display media message's content
public class DUMediaContentView {
    
    public func initWith(mediaType: DUMediaItem.Type, frame: CGRect, data: String?) -> UIView? {
        guard data != nil else {
            return nil
        }
        let mediaView = UIImageView.init(frame: frame)
        
        
        return nil
    }

}
