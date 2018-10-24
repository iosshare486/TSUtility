//
//  UIButton+HitTest.swift
//  TSUtility
//
//  Created by 任鹏杰 on 2018/8/31.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

extension UIButton {
    
    // 提供多个运行时的key
    struct TSButtonRuntimeKey {
        static let btnHitTestKey = UnsafeRawPointer.init(bitPattern: "btnHitTestKey".hashValue)
    }
    
    /**
     设置按钮额外点击区域
     */
    public var ts_hitTestEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, TSButtonRuntimeKey.btnHitTestKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return (objc_getAssociatedObject(self, TSButtonRuntimeKey.btnHitTestKey!) as? UIEdgeInsets) ?? UIEdgeInsets.zero
        }
    }
    ///重写点是否包含在view的区域内
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if (ts_hitTestEdgeInsets! == UIEdgeInsets.zero) || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }
        let relativeFrame = bounds
        //修复swift 4.2
        let hitFrame = relativeFrame.inset(by: ts_hitTestEdgeInsets!)
        return hitFrame.contains(point)
    }
}
