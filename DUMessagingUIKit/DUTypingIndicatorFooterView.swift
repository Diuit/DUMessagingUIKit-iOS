//
//  DUTypingIndicatorFooterView.swift
//  DUMessagingUIKit
//
//  Created by Pofat Diuit on 2016/6/22.
//  Copyright © 2016年 duolC. All rights reserved.
//

import UIKit

public class DUTypingIndicatorFooterView: UICollectionReusableView {
    @IBOutlet weak var dot1: RoundUIView!
    @IBOutlet weak var dot2: RoundUIView!
    @IBOutlet weak var dot3: RoundUIView!
    @IBOutlet weak var messageBubbleView: DUMediaContentView!
    
    static let itemHeight: CGFloat = 44

    override public func awakeFromNib() {
        super.awakeFromNib()
        super.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = false
        self.messageBubbleView.backgroundColor = GlobalUISettings.incomingMessageBubbleBackgroundColor
        // run animation repeatedly
        UIView.animateKeyframesWithDuration(2, delay: 0, options: .Repeat, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.4) {
                self.dot1.alpha = 0
                self.dot1.frame.origin = CGPointMake(self.dot1.frame.origin.x, self.dot1.frame.origin.y - 5)
            }
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.4) {
                self.dot2.alpha = 0
                self.dot2.frame.origin = CGPointMake(self.dot2.frame.origin.x, self.dot2.frame.origin.y - 5)
            }
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.4) {
                self.dot3.alpha = 0
                self.dot3.frame.origin = CGPointMake(self.dot3.frame.origin.x, self.dot3.frame.origin.y - 5)
            }
            
            
            UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 0.1) {
                self.dot1.frame.origin = CGPointMake(self.dot1.frame.origin.x, self.dot1.frame.origin.y + 5)
                
            }
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.3) {
                self.dot1.alpha = 1
            }
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.1) {
                self.dot2.frame.origin = CGPointMake(self.dot2.frame.origin.x, self.dot2.frame.origin.y + 5)
                
            }
            UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.3) {
                self.dot2.alpha = 1
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.1) {
                self.dot3.frame.origin = CGPointMake(self.dot3.frame.origin.x, self.dot3.frame.origin.y + 5)
                
            }
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3) {
                self.dot3.alpha = 1
            }
        }, completion: nil)
        
    }
    
}


public extension DUTypingIndicatorFooterView {
    /// Return UINib object of `DUTypingIndicatorFooterView` for collection reusable footer view.
    public static var nib: UINib { return UINib.init(nibName: self.nameOfClass, bundle: NSBundle(identifier: Constants.bundleIdentifier)) }
    /// Return the string to identify reuable footer view.
    public static var footerViewReuseIdentifier: String { return self.nameOfClass }
}