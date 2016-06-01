//
//  ViewController.swift
//  DUMessagingDemo
//
//  Created by Pofat Diuit on 2016/6/1.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessagingUIKit
import DUMessaging

class ViewController: DUChatListTableViewController {
    override var myNavigationBarTitle: String { return "custom from client" }

    override func viewDidLoad() {
        super.viewDidLoad()
        DUMessaging.loginWithAuthToken("pofat_04") { error, result in
            guard error == nil else {
                print("aut error:\(error!.localizedDescription)")
                return
            }
            DUMessaging.listChatrooms() { [weak self] error, chats in
                guard let _:[DUChat] = chats where error == nil else {
                    print("list error:\(error!.localizedDescription)")
                    return
                }
                print("fetch chat list from client")
                self?.chatData = chats!.map({$0 as DUChatData})
                self?.finishGettingChatData()
            }
        }
    }
}

