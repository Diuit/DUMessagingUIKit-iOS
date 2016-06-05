//
//  ViewControllerProtocols.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/1.
//  Copyright © 2016年 duolC. All rights reserved.
//

import Foundation
import UIKit
import DTTableViewManager

// MARK: DUChatList View Controller Protocol

/**
    This protocol helps you build a chat room list by either an UITableViewController of an UIViewController with an UITableView inside it.
 
    - importatn: There is only one requirement of useing this protocol. You can either use it with an UITableViewController or an UIViewController with an UITableView property named `tableView`. As long as there is a property named `tableView`, the protocol will find it and do the rest.
 */
public protocol DUChatListProtocolForViewController: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle, RightBarButton, DTTableViewManageable {
    
    /**
        Pass an array of chat data source which conforms to protocol `DUChatData` to correctly display information of each chat room.
        
        - attention: Since protocol is ** not AnyObject-compatible **, you can not directly cast any array of class to array of `DUChatData`. Even though such class conforms to the protocol. It will arise a runtime crash while casting the array. To assign values to `chatData`, use map to mirror each elements:
                
                // must use map if your array is not declaired as [DUChatData]
                chatData = arrayOfClassConformsToDUChatData.map({$0})
     */
    var chatData: [DUChatData] { get set }
    
    /**
        Implement this method to deal with the event of chatCell getSelected.
        
        - parameter indexPath indexPath of cell which get selected
     */
    func didSelectCell(atIndexPath indexPath: NSIndexPath)
}
public extension DUChatListProtocolForViewController where Self: UIViewController {
    var myBarTitle: String { return "Chats" }
    
    var myBarButtonType: UIBarButtonType { return .imageButton }
    var rightBarButtonImage: UIImage? { return UIImage.DUNewChatButtonImage() }
    var rightBarButtonText: String? { return nil }
    
    func adoptProtocolUIApperance() {
        setupInheritedProtocolUI()
        
        // TODO: possible to customize NSBundle? register Cell? and register nibName?
        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        manager.registerCellClass(DUChatCell.self) { [weak self] (_, model, indexPath) in
            self?.didSelectCell(atIndexPath:indexPath)
        }
        manager.registerNibNamed("DUChatCell", forCellClass: DUChatCell.self)
        // FIXME: customizable?
        tableView.rowHeight = 92.0
        tableView.tableFooterView = UIView()
    }
    
    func didSelectCell(atIndexPath indexPath: NSIndexPath) {
        assert(false, "Error! You must implement method: \(#function)")
    }
    
    /// Execute this method after your data source is set to refresh UI
    final func finishGettingChatData() {
        manager.memoryStorage.setItems(chatData)
    }
}