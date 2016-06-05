//
//  DUMessageData.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/6.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import DUMessaging

/**
    `DUMessageData` protocol defines the interface between your message data source objects and `DUMessagesViewController`.
    
    You must implement all interfaces to correctly display messages within a `DUMessageCollectionViewCell`
 */
public protocol DUMessageData {
    /**
     - returns: An unique string identifier of the user who sent the message
     */
    var senderIdentifier: String { get }
    
    /**
     - returns: The display name of the sender
     */
    var senderDisplayName: String { get }
    
    /**
     - returns: The NSDate instance indicating when the message createdg
     */
    var messageCreationDate: NSDate { get }
    
    
}
