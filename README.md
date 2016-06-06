# DUMessaging UI Kit Beta


DUMessaging UI Kit is an open source framework of customizable UI components for using Diuit Messaging API, which is designed to build messaging feature into any mobile apps quickly. This repository contains the entire UI library for modern messaging apps. Note that this is a beta version, at this phase we only support limited features -- the UI in chat list and chat setting. More features will be released every week. Please bear with us and stay tuned.

## Requirements

* Xcode 7 and higher
* iOS 8.0 and higher
* Swift 2

## Installation

[CocoaPods](http://www.cocoapods.org):

    pod 'DUMessagingUIKit', '~> 0.1.0'
    
## Features

- [x] Flexible UI protocol to build a chat list UI based on UITableView or UITableViewController
- [x] Able to display chat information and hook up your setup method with UI easily


## Quick Start

`DUMessagingUIKit` now has one UI protocol `DUChatListProtocolForViewController` and one UIViewController subclass `DUChatSettingViewController`.

First, let's build a viewController to display and manage your chat list by using protocol `DUChatListProtocolForViewController`. Here's what you need to do:

* Create a subclass of UITableViewController or UIViewController. If you choose UIViewController, you have to contain an UITableView named tableView. Just make sure that there is one `tableView` property of UITableView type and adopt the protocol

	```swift
	import DUMessagingUIKit
	
	class MyViewController: UITableViewController, DUChatListProtocolForViewController {
		// conforms to protocol by implementing following three
		var chatData: [DUChatData] = []
		
		func didClickRightBarButton(sender: UIBarButtonItem?) {
        // handle righbtBarButton click event
    	}
    
    	func didSelectCell(atIndexPath indexPath: NSIndexPath) {
        	// handle cell selection event
    	}
	}
	```
* Execute `adoptProtocolUIAppearance()` in `viewDidLoad()`

	```swift
	override func viewDidLoad() {
		super.viewDidLoad()
		// adopt UI protocol, this is where the magic happens
		adoptProtocolUIAppearance()
	}
	```

	
* After you get your chat list, assign it to `chatData` and execute `finishGettingChatData()`. Here we use DUMessaging API as our data source. Note that you ** CAN NOT ** directly assign the array of class to `chatData`. For chatData is declared as an array of protocol, which is not AnyObject-compatible. Directly assign will force the array to be casted and thus raise a runtime crash.

	```swift
	DUMessaging.listChatrooms() { [weak self] error, chats in
		// You must assign value in this way
		self?.chatData = chats!.map({$0})
		// Refresh UI
		self?.finishGettingChatData()
	}
	``` 
That's it! Easy!

* You can use your own chat data class as long as it conforms to `DUChatData` protocol
* It's also easy to use `DUChatSettingViewController`, just assign the chat data source to `chatDataForSetting` and voila! Please check our example code in the project.
