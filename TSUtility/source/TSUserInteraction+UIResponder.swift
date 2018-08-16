//
//  TSUserInteraction+UIResponder.swift
//  TSUtility
//
//  Created by 洪利 on 2018/8/16.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import Foundation
import UIKit
@objc public protocol TS_UserInteraction_DataTransition {
    @objc func ts_userInteraction(info:AnyObject)
}
public extension UIResponder{
    func ts_transitionInfo(info:AnyObject?) {
        if self.conforms(to: TS_UserInteraction_DataTransition.self) {
            (self as! TS_UserInteraction_DataTransition).ts_userInteraction(info:info!)
        }else{
            self.next?.ts_transitionInfo(info:info!)
        }
    }
}
