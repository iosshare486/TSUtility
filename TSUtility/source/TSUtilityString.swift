//
//  TSUtilityString.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
public final class TSUtilityString {
    
    private let base: String
    public init (_ base: String) {
        self.base = base
    }
    
    public func color() -> UIColor {
        
        return self.stringToColor(1.0)
    }
    
    public func color(_ alpha: CGFloat) -> UIColor {
        
        return self.stringToColor(alpha)
    }
    
    public func substring(_ startIndex: Int, _ endIndex: Int) -> String {
        
        if endIndex < startIndex {
            
            debugPrint("endIndex < startIndex")
            return ""
        }
        
        if startIndex >= self.base.count  {
            debugPrint("startIndex >= string.count")
            return ""
        }
        
        if endIndex >= self.base.count  {
            debugPrint("endIndex >= string.count")
            return ""
        }
        
        let startIndex = self.base.index(self.base.startIndex, offsetBy: startIndex)
        let endIndex = self.base.index(self.base.startIndex, offsetBy: endIndex)
        return String(self.base[startIndex...endIndex])
    }
    
    
}

extension TSUtilityString {
    
    private func stringToColor(_ alpha: CGFloat) -> UIColor {
        
        let rgbValue: String = self.base
        var cString: String = rgbValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0x") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        if cString.hasPrefix("#") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        } else {
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        }
    }
}

extension String: TSUtilityCompatible {
    
    public var ts: TSUtilityString {
        get { return TSUtilityString(self) }
    }
}
