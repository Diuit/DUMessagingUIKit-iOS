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
public protocol DUChatListViewController: GlobalUIProtocol, UIProtocolAdoption, NavigationBarTitle, RightBarButton, BarButtonReaction, DTTableViewManageable {
    var chatData: [DUChatData] { get set }
    func didSelectCell(atIndexPath indexPath: NSIndexPath)
}
public extension DUChatListViewController where Self: UIViewController {
    var myBarTitle: String { return "Chats" }
    
    var myBarButtonType: UIBarButtonType { return .imageButton }
    var rightBarButtonImage: UIImage? { return UIImage.DUNewChatButtonImage() }
    var rightBarButtonText: String? { return nil }
    
    func adoptProtocolUIApperance() {
        navigationController?.navigationBar.barTintColor = self.myBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.myNavigationBarTextColor, NSFontAttributeName: self.myNavigationBartTextFont]
        navigationItem.title = self.myBarTitle
        
        switch self.myBarButtonType {
        case .imageButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: self.rightBarButtonImage?.imageWithRenderingMode(.AlwaysOriginal) , style: .Plain, target: self, action: nil)
        case .textButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: self.rightBarButtonText, style: .Plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = self.myTintColor
        default:
            navigationItem.rightBarButtonItem = nil
        }
        
        if navigationItem.rightBarButtonItem != nil {
            navigationItem.rightBarButtonItem?.action = #selector(Self.didClickRightBarButton(_:))
        }
        // set global tint color
        UIApplication.sharedApplication().delegate?.window??.tintColor = self.myTintColor
        
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
        manager.memoryStorage.addItems(chatData)
    }
}