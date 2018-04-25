//
//  TSUtility.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/17.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import Foundation
/// 声明协议 增加属性
public protocol TSUtilityCompatible {
    
    associatedtype Compatible
    var ts: Compatible { get }
    
}



