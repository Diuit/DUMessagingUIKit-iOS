//
//  DemoChatListViewController.swift
//  DUMessagingDemo
//
//  Created by Pofat Diuit on 2016/6/1.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit
import DUMessagingUIKit
import DUMessaging

class DemoChatListViewController: UITableViewController, DUChatListProtocolForViewController {
    // MARK: followings are propeties and methods that you should implement
    var chatData: [DUChatData] = []
    // For hint localizations
    private let hints: [String] = ["FIRST_HINT", "SECOND_HINT", "THIRD_HINT", "FORTH_HINT", "FIFTH_HINT"]
    
    func didClick(rightBarButton: UIBarButtonItem?) {
        // handle righbtBarButton click event
        print("Right bar button clicked")
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        // handle cell selection event
        selectedChat = chatData[indexPath.row]
        self.performSegue(withIdentifier: "toMessagesSegue", sender: nil)
    }
    
    var selectedChat: DUChatData? = nil
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // adopt UI protocol
        adoptProtocolUIApperance()
        
        var hintMessages: [DUMessageData] = []
        for hint in hints {
            var mockHinMessage = MockMessageModel(text: NSLocalizedString(hint, comment: "hint"), isOutgoing: false)
            mockHinMessage.senderIdentifier = "her"
            mockHinMessage.senderDisplayName = "Bot"
            hintMessages.append(mockHinMessage)
        }
        self.chatData.append(MockChatModel.init(withMessages: hintMessages))
        self.endGettingChatData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DemoMessagesViewController {
            vc.chat = selectedChat
        }
    }
    
}

