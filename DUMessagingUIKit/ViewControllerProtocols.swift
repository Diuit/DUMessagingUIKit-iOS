//
//  ViewControllerProtocols.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/1.
//  Copyright © 2016年 duolC. All rights reserved.
//

// TODO: add documentation

import Foundation
import UIKit
import DTTableViewManager

// MARK: DUChatList View Controller Protocol
public protocol DUChatListProtocolForViewController: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle, RightBarButton, DTTableViewManageable {
    var chatData: [DUChatData] { get set }
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
    
    final func finishGettingChatData() {
        manager.memoryStorage.setItems(chatData)
    }
}