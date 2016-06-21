//
//  DUMediaContentView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/20.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

/// Content view to display media message's content
public class DUMediaContentView: UIView, MediaContentStyle {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        adoptProtocolUIApperance()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adoptProtocolUIApperance()
    }
}
/// Content view to display an image message
public class DUMediaContentImageView: UIImageView, MediaContentStyle {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        adoptProtocolUIApperance()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adoptProtocolUIApperance()
    }
}
/// Content view for URL preview display.
public class DUURLMediaContentView: UIView, URLMediaContentStyle {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        adoptProtocolUIApperance()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adoptProtocolUIApperance()
    }
}
