//
//  TSRecurClick+UIButton.swift
//  TSUtility
//
//  Created by 洪利 on 2018/8/16.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import Foundation
import UIKit

private var key: Void?
public extension UIButton {
    
    var time_interval : TimeInterval? {
        get {
            return (objc_getAssociatedObject(self, &key) as? TimeInterval) ?? nil
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents, clickTimeInterval:TimeInterval) {
        if clickTimeInterval > Double(0) {
            self.time_interval = clickTimeInterval
        }
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    
    //手指抬起
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //根据需要设置按钮是否可以点击
        
        guard let time_interval = self.time_interval else {
            
            super.touchesEnded(touches, with: event)
            return
            
        }
        
        if time_interval > 0 {
            self.isUserInteractionEnabled = false
            self.perform(#selector(restoreUserActivityStateOfButton), with: nil, afterDelay: time_interval)
        }
        super.touchesEnded(touches, with: event)
    }
    
    @objc func restoreUserActivityStateOfButton() {
        self.isUserInteractionEnabled = true
    }
}
