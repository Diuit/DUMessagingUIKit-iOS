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

public protocol DUChatListViewController: GlobalUISetting, UIProtocolAdoption, NavigationBarTitle, RightBarButton, DTTableViewManageable {
    var chatData: [DUChatData] { get set }
}
public extension DUChatListViewController where Self: UIViewController {
    var myBarTitle: String { return "Chats from protocol" }
    
    var myBarButtonType: UIBarButtonType { return .imageButton }
    var rightBarButtonImage: UIImage? { return UIImage.DUNewChatButtonImage() }
    var rightBarButtonText: String? { return nil }
    // FIXME: find a correct way to implement click event
    var didClickRightBarButton: Void->Void { return { assert(false, "please over") }}
    
    
    func adoptProtocolUIApperance() {
        navigationController?.navigationBar.barTintColor = self.myBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.myNavigationBarTextColor, NSFontAttributeName: self.myNavigationBartTextFont]
        navigationItem.title = self.myBarTitle
        
        switch self.myBarButtonType {
        case .imageButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: self.rightBarButtonImage?.imageWithRenderingMode(.AlwaysOriginal) , style: .Plain, target: self, action: nil)
        case .textButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: self.rightBarButtonText, style: .Plain, target: self, action: nil)
        default:
            navigationItem.rightBarButtonItem = nil
        }
        
        if navigationItem.rightBarButtonItem != nil {
            // FIXME: implement click event
            //navigationItem.rightBarButtonItem?.action = didClickRightBarButton
        }
        // FIXME: how to setup all tint color?
        view.tintColor = self.myTintColor
        
        // do tableview setup
        if tableView == nil {
            assert(false, "You either user an UITableViewController or an UITableView in an UIViewController")
        }
        // FIXME: customize?
        tableView.rowHeight = 92.0
        tableView.tableFooterView = UIView()
        
        // FIXME: possible to customize NSBundle? register Cell? and register nibName?
        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        manager.registerCellClass(DUChatCell)
        manager.registerNibNamed("DUChatCell", forCellClass: DUChatCell.self)
    }
    
    final func finishGettingChatData() {
        manager.memoryStorage.addItems(chatData)
    }
}