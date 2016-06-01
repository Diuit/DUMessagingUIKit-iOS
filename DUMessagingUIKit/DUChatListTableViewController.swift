//
//  DUChatListTableViewController.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/1.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DTTableViewManager
import DUMessaging

public class DUChatListTableViewController: UITableViewController, DTTableViewManageable, GlobalTheme, RightBarButton {

    // Gloabl Theme Protocol implementations
    public var myNavigationBarTitle: String { return "Chats" }

    // RightBarButton Protocol implementation
    public var myBarButtonType: UIBarButtonType { return .imageButton }
    public var rightBarButtonImage: UIImage? { return UIImage.DUNewChatButtonImage() }
    public var rightBarButtonText: String? { return nil }

    // pulic vars
    public var chatData: [DUChatData] = []
    // MARK: Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // adopt ui protocol 
        adoptProtocolUIApperance()

        // setup tableView
        self.tableView.rowHeight = 92.0
        self.tableView.tableFooterView = UIView()

        manager.startManagingWithDelegate(self)
        manager.viewBundle = NSBundle(identifier: Constants.bundleIdentifier)!
        manager.registerCellClass(DUChatCell)
        manager.registerNibNamed("DUChatCell", forCellClass: DUChatCell.self)
        
        /*
        DUMessaging.loginWithAuthToken("pofat_04") { error, result in
            guard error == nil else {
                print("login error")
                return
            }
            DUMessaging.listChatrooms() { [weak self] error, chats in
                guard let _: [DUChat] = chats where error == nil else {
                    print(" list error")
                    return
                }
                let chatDatas: [DUChatData] = chats!.map({$0})
                self?.manager.memoryStorage.addItems(chatDatas)
            }
        }
 */
        
    }
    
    // MARK: Chat List TableView controller
    /// Click event of rightBarButton, you must override this function
    public func rightBarButtonClickEvent(sender: UIBarButtonItem) {
        assert(false, "Error! You must override this function : \(#function)")
    }
    
    public final func finishGettingChatData() {
        manager.memoryStorage.addItems(chatData)
    }
}


// MARK: extensions
extension DUChatListTableViewController: DUMessagingUIProtocol {
    public func adoptProtocolUIApperance() {
        navigationItem.title = self.myNavigationBarTitle
        navigationController?.navigationBar.barTintColor = self.myBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.myNavigationBarTextColor]
        
        switch self.myBarButtonType {
        case .imageButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: self.rightBarButtonImage?.imageWithRenderingMode(.AlwaysOriginal) , style: .Plain, target: self, action: nil)
        case .textButton:
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: self.rightBarButtonText, style: .Plain, target: self, action: nil)
        default:
            navigationItem.rightBarButtonItem = nil
        }
        
        if navigationItem.rightBarButtonItem != nil {
            navigationItem.rightBarButtonItem?.action = #selector(rightBarButtonClickEvent(_:))
        }
    }
}
