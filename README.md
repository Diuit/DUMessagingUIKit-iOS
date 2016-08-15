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


## Quick Start of Demo APP

1. Clone this git repo to local.
2. Execute `pod install` to install all dependencies in the project folder.
3. Open `DUMessagingUIKit.xcworkspace` and select target `DUMessagingUIKit`. Hit `command+B` to build the framework
4. Select target `DUMessagingDemo` and hit `command+R` to run demo app on your simulator or real device.