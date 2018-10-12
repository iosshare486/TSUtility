//
//  TSDateTransferString.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/9/29.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

/// 时间与昨今明的转换（包括年月日）
///
/// - last: 前一(年月日)
/// - now: 当前(年月日)
/// - next: 下一(年月日)
public enum TSDateNickname {
    case last
    case now
    case next
    case none
}

public enum TSWeekName {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, None
}

/// 时间字符串转换后的对应的时间结构体
public struct TSDateObject {
    
    /// 原始数据
    private(set) var originDateString: String
    /// 原始数据的格式
    private(set) var originDateFormat: String
    /// 原始数据的时区
    private(set) var originDateTimeZone: TimeZone
    
    public var year: String?
    public var month: String?
    public var day: String?
    public var hour: String?
    public var minute: String?
    public var second: String?
    ///一下必须有年与日才可有值
    /// 距离当前时间秒数间隔
    public var timeOffset: TimeInterval?
    /// 周几
    public var week: TSWeekName?
    /// 表示是今年明年去年
    public var yearNickname: TSDateNickname?
    /// 表示是当月上月下月
    public var monthNickname: TSDateNickname?
    /// 表示是今天明天昨天
    public var dayNickname: TSDateNickname?
    
    /// 根据对应格式转换对应时间结构体
    /// - warning: timeZone的单位为秒
    /// - Parameters:
    ///   - date: 时间字符串
    ///   - format: 时间字符格式
    ///   - timeZone: 单位为秒的时区  北京为28800 = 60 * 8 * 60
    public init(date: String, format: String = "yyyy-MM-dd HH:mm:ss zzz" , timeZone: Int = 28800) {
        
        self.originDateString = date
        self.originDateFormat = format
        
        if let zone = TimeZone.init(secondsFromGMT: timeZone) {
            self.originDateTimeZone = zone
        }else {
            TSLog("TSDate: timeZoneh格式错误")
            self.originDateTimeZone = TimeZone.current
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = self.originDateFormat
        dateFormat.timeZone = self.originDateTimeZone
        //部分属性初始化
        if let timeDate = dateFormat.date(from: date) {
            let calendar = Calendar.current
            let dateComponets = calendar.dateComponents(in: self.originDateTimeZone, from: timeDate)
            let nowDate = Date()
            let nowComponets = calendar.dateComponents(in: self.originDateTimeZone, from: nowDate)
            if self.originDateFormat.contains("yyyy") {
                self.year = String("\(dateComponets.year ?? 0)")
            }
            if self.originDateFormat.contains("MM") {
                self.month = String("\(dateComponets.month ?? 0)")
            }
            if self.originDateFormat.contains("dd") {
                self.day = String("\(dateComponets.day ?? 0)")
            }
            if self.originDateFormat.contains("HH") {
                self.hour = String("\(dateComponets.hour ?? 0)")
            }
            if self.originDateFormat.contains("mm") {
                self.minute = String("\(dateComponets.minute ?? 0)")
            }
            if self.originDateFormat.contains("ss") {
                self.second = String("\(dateComponets.second ?? 0)")
            }
            // 是否有 yyyy MM dd
            if self.originDateFormat.contains("yyyy") && self.originDateFormat.contains("MM") && self.originDateFormat.contains("dd") {
                self.week = TSDateObject.weekObject(dateComponets.weekday ?? 0)
                self.timeOffset = timeDate.timeIntervalSince(nowDate)
                ///今年 去年 明年
                if calendar.isDateInTomorrow(timeDate) {
                    //明天
                    self.dayNickname = .next
                    self.yearNickname = .now
                    //当月判断
                    if let dateMonth = dateComponets.month , let nowMonth = nowComponets.month {
                        self.monthNickname = TSDateObject.timeCompare(dateMonth, nowMonth)
                    } else {
                        self.monthNickname = TSDateNickname.none
                    }
                } else if calendar.isDateInYesterday(timeDate) {
                    //昨天
                    self.dayNickname = .last
                    self.yearNickname = .now
                    //当月判断
                    if let dateMonth = dateComponets.month , let nowMonth = nowComponets.month {
                        self.monthNickname = TSDateObject.timeCompare(dateMonth, nowMonth)
                    } else {
                        self.monthNickname = TSDateNickname.none
                    }
                } else if calendar.isDateInToday(timeDate) {
                    //今天
                    self.yearNickname = .now
                    self.monthNickname = .now
                    self.dayNickname = .now
                } else {
                    self.dayNickname = TSDateNickname.none
                    //当年判断
                    //当月判断
                    if let dateYear = dateComponets.year , let nowYear = nowComponets.year {
                        if dateYear == nowYear {
                            self.yearNickname = .now
                            if let dateMonth = dateComponets.month , let nowMonth = nowComponets.month {
                                self.monthNickname = TSDateObject.timeCompare(dateMonth, nowMonth)
                            } else {
                                self.monthNickname = TSDateNickname.none
                            }
                        } else if dateYear - 1 == nowYear {
                            self.yearNickname = .next
                            self.monthNickname = TSDateNickname.none
                        } else if dateYear + 1 == nowYear {
                            self.yearNickname = .last
                            self.monthNickname = TSDateNickname.none
                        } else {
                            self.yearNickname = TSDateNickname.none
                            self.monthNickname = TSDateNickname.none
                        }
                    } else {
                        self.yearNickname = TSDateNickname.none
                        self.monthNickname = TSDateNickname.none
                    }
                }
            }
        }
    }
    
    /// 当前时间
    init() {
        /// 获取当前时间
        let date = Date()
        self.originDateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        self.originDateTimeZone = TimeZone.current
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = self.originDateFormat
        dateFormat.timeZone = self.originDateTimeZone
        self.originDateString = dateFormat.string(from: date)
        /// 将date分别解析出 年月日时分秒
        self.year = TSDateTransferStringTools.assignData(date: date, format: "yyyy")
        self.month = TSDateTransferStringTools.assignData(date: date, format: "MM")
        self.day = TSDateTransferStringTools.assignData(date: date, format: "dd")
        self.hour = TSDateTransferStringTools.assignData(date: date, format: "HH")
        self.minute = TSDateTransferStringTools.assignData(date: date, format: "mm")
        self.second = TSDateTransferStringTools.assignData(date: date, format: "MM")
        self.yearNickname = .now
        self.monthNickname = .now
        self.dayNickname = .now
        let calendar = Calendar.current
        let dateComponets = calendar.dateComponents(in: self.originDateTimeZone, from: date)
        self.week = TSDateObject.weekObject(dateComponets.weekday ?? 0)
    }
    /// get week
    private static func weekObject(_ weekNum : Int) -> TSWeekName {
        if weekNum < 1 || weekNum > 7 {
            return .None
        } else {
            switch weekNum {
            case 1 : return .Sunday;
            case 2 : return .Monday;
            case 3 : return .Tuesday;
            case 4 : return .Wednesday;
            case 5 : return .Thursday;
            case 6 : return .Friday;
            case 7 : return .Saturday;
            default : return .None
            }
        }
    }
    ///时间比较
    private static func timeCompare (_ timeCurrent : Int , _ nowTime : Int) -> TSDateNickname {
        if timeCurrent == nowTime {
            return .now
        } else if timeCurrent - 1 == nowTime {
            //下个
            return .next
        } else if timeCurrent + 1 == nowTime {
            //上个
             return .last
        } else {
            return .none
        }
    }
}

// MARK: - 私有方法 格式转换的操作
fileprivate class TSDateTransferStringTools {
    
    /// 数据处理 赋值初始化
    static func switchTimeToCurrentTimeZone(timeStr: String) -> Date? {
        guard let tempTimeStr = self.timeFormate(time: timeStr) else {
            TSLog("TSDate: 时间格式不正确")
            return nil
        }
        /// 将传入的时间戳string转换成date
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        guard let tempDate = dateFormate.date(from: tempTimeStr) else {
            TSLog("TSDate: 时间格式不正确")
            return nil
        }
        return tempDate
    }
    
    /// 转换时区格式
    static func timeFormate(time: String, defaultTimeZone: String = "GMT+8") -> String? {
        
        let items = time.components(separatedBy: " ")
        if items.count < 2 { return nil }
        
        if items.count > 2 && items[2].count > 2 {
            let zone = items[2] as NSString
            let flag = zone.substring(with: NSRange(location: 0, length: 1))
            if  flag == "+" || flag == "-" {
                var t = "GMT" + zone.substring(with: NSRange(location: 0, length: 3))
                if (t as NSString).substring(with: NSRange(location: t.count - 1, length: 1)) == "0" {
                    t = (t as NSString).substring(with: NSRange(location: 0, length: t.count - 1))
                }
                return items[0] + " " + items[1] + " " + t
            } else {
                return time
            }
        } else {
            // == 2
            return time + " " + defaultTimeZone
        }
    }
    
    
    /// date转string方法
    static func assignData(date: Date, format: String) -> String {
        let dateFormate = DateFormatter()
        dateFormate.timeZone = TimeZone.current
        dateFormate.dateFormat = format
        return dateFormate.string(from: date)
    }
}
