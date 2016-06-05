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

class ViewController: UITableViewController, DUChatListProtocolForViewController {
    // MARK: followings are propeties and methods that you should implement
    var chatData: [DUChatData] = []
    
    func didClickRightBarButton(sender: UIBarButtonItem?) {
        // handle righbtBarButton click event
        self.performSegueWithIdentifier("toMessagesSegue", sender: nil)
    }
    func didSelectCell(atIndexPath indexPath: NSIndexPath) {
        // handle cell selection event
        selectedChat = chatData[indexPath.row]
        //self.performSegueWithIdentifier("toSettingSegue", sender: nil)
         self.performSegueWithIdentifier("toMessagesSegue", sender: nil)
    }
    
    var selectedChat: DUChatData? = nil
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // adopt UI protocol
        adoptProtocolUIApperance()
        
        // retrieve chat list
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
                // You must use .map to assign array, for Swift still cannot check type one by one in an array before bridging to NSArray
                self?.chatData = chats!.map({$0 as DUChatData})
                self?.finishGettingChatData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DUChatSettingViewController {
            vc.chatDataForSetting = selectedChat
        }
    }
    
}

