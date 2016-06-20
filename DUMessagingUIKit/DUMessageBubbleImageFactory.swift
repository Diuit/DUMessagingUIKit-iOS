//
//  DUMessageBubbleImageFactory.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/12.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit

/// This factory is in charge of generating UIImage instance for message bubble image.
public class DUMessageBubbleImageFactory: NSObject {
    /// Build a message bubble image with given color
    /// - parameter color: Background color of the message bubble
    public static func makeMessageBubbleImage(color:UIColor) -> UIImage {
        return UIImage.imageWith(backgroundColor: color)
    }
}
