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
    //暂时弃用。
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
    
    public func versionCompare(_ compareVersion: String) -> ComparisonResult {
        
        //将两个版本号以“.”拆分成数组
        let currentVersions = self.base.components(separatedBy: ".")
        let compareVersions = compareVersion.components(separatedBy: ".")
        //分别比较每一位的大小
        let count = (currentVersions.count < compareVersions.count) ? currentVersions.count : compareVersions.count
        
        for i in 0..<count {
            
            if let current = Int(currentVersions[i]), let compare = Int(compareVersions[i]) {
             
                if current > compare {
                    return ComparisonResult.orderedDescending
                }else if current < compare {
                    return ComparisonResult.orderedAscending
                }
            }
        }
        //经过上面的for后还没有比较出来，说明两者相同位的版本号都相同，剩下的则看谁的版本号更长，长的则表示版本号大。例：11.0.1 < 11.0.1.1
        if currentVersions.count < compareVersions.count {
            return ComparisonResult.orderedAscending
        }else if currentVersions.count > compareVersions.count {
            return ComparisonResult.orderedDescending
        }else {
            return ComparisonResult.orderedSame
        }
    }
    //计算文本宽和高
    public func boundingSize(font:UIFont,limitSize:CGSize,lineSpace : CGFloat)->CGSize{
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpace
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
        
        let rect = self.base.boundingRect(with: limitSize, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size
        
    }
    
}

extension TSUtilityString {
    
    var length: Int {
        return self.base.count
    }
    
    /// 回去字符串内指定字符
    ///
    /// - Parameter i: 指定字符
    open subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    /// 截取字符串
    ///
    /// - Parameter fromIndex: 从该位置截取
    /// - Returns: 截取后字符串
    public func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    /// 截取字符串
    ///
    /// - Parameter toIndex: 截取到位置
    /// - Returns: 截取后字符串
    public func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    /// 截图字符串
    ///
    /// - Parameter r: 截取后的字符串
    open subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        
        let start = self.base.index(self.base.startIndex, offsetBy: range.lowerBound)
        let end = self.base.index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self.base[start ..< end])
    }
    
}

extension TSUtilityString {
    
    /// 删除字符串后几位操作
    ///
    /// - Parameter n: 删除位数
    /// - Returns: 删除后字符串
    public func dropLast(_ n: Int = 1) -> String {
        return String(self.base.dropLast(n))
    }
    
    /// 删除字符串最后一位
    public var dropLast: String {
        return dropLast()
    }
}

extension TSUtilityString {
    
    /// 是否为纯数字
    ///
    /// - Returns: 是否合法
    public func isOnlyNumber() -> Bool {
        return predicateLimit("^[0-9]+$")
    }
    
    /// 是字母或是数字
    ///
    /// - Returns: 是否合法
    public func isWordOrNumber() -> Bool {
        return predicateLimit("^[A-Za-z0-9]+$")
    }
    
    /// 是汉子
    ///
    /// - Returns: 是否合法
    public func isChinese() -> Bool {
        return predicateLimit("^[\u{4e00}-\u{9fa5}]+$")
    }
    
    /// 是否为手机号
    ///
    /// - Returns: 是否合法
    public func isPhoneNumber() -> Bool {
        return predicateLimit("^1[0-9]{10}+$")
    }
    
    /// 是否为邮箱
    ///
    /// - Returns: 是否合法
    public func isValidateEmail() -> Bool {
        return predicateLimit("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    /// 是否是身份证
    ///
    /// - Returns: 是否合法
    public func isCardCode() -> Bool {
        return predicateLimit("[0-9]{15}([0-9][0-9][0-9xX])?")
    }
    
    /// 去掉所有空格
    ///
    /// - Returns: 是否合法
    public func removeSpace() -> String {
        return self.base.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
}

extension TSUtilityString {
    
    private func stringToColor(_ alpha: CGFloat) -> UIColor {
        
        let rgbValue: String = self.base
        var cString: String = rgbValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.hasPrefix("0x") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        if cString.hasPrefix("#") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        
        if cString.count == 1 {
            cString = String(format: "%@%@%@%@%@%@", cString, cString, cString, cString, cString, cString)
        }else if cString.count == 2 {
            cString = String(format: "%@%@%@", cString, cString, cString)
        }else if cString.count == 3 {
            cString = String(format: "%@%@", cString, cString)
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
    
    private func predicateLimit(_ predicateString : String) -> Bool {
        if self.base.count == 0 {
            return false
        }
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",predicateString)
        return regextestmobile.evaluate(with: self.base)
    }
    
}

extension String: TSUtilityCompatible {
    
    public var ts: TSUtilityString {
        get { return TSUtilityString(self) }
    }
}
