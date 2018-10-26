//
//  TSDateTransferString.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/9/29.
//  Copyright © 2018年 caiqr. All rights reserved.
//
//  解析时间戳 返回结构体，其中包含各种日期相关的属性

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

/// 周几
public enum TSWeekName {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, None
}

/// 时间字符串转换后的对应的时间结构体
public struct TSDateObject {

//MARK: - public property
    
    public var year: String?
    public var month: String?
    public var day: String?
    public var hour: String?
    public var minute: String?
    public var second: String?
    ///以下必须有年与日才可有值
    /// 距离当前时间秒数间隔 (正数表示未来，负数表示过去)
    public var timeOffset: TimeInterval?
    /// 周几
    public var week: TSWeekName = .None
    /// 表示是今年明年去年
    public var yearNickname: TSDateNickname = .none
    /// 表示是当月上月下月
    public var monthNickname: TSDateNickname = .none
    /// 表示是今天明天昨天
    public var dayNickname: TSDateNickname = .none
    
//MARK: - private property
    
    /// 原始数据
    private(set) var originDateString: String
    /// 原始数据的格式
    private(set) var originDateFormat: String
    /// 原始数据的时区
    private(set) var originDateTimeZone: TimeZone
    
    
//MARK: - public mothed
    
    /// 根据对应格式转换对应时间结构体
    /// - warning: timeZone的单位为秒
    /// - Parameters:
    ///   - date: 时间字符串
    ///   - format: 时间字符格式
    ///   - timeZone: 单位为秒的时区  北京为28800 = 60 * 8 * 60
    public init?(date: String, format: String = "yyyy-MM-dd HH:mm:ss zzz" , timeZone: Int = 28800) throws {
        
        guard let zone = TimeZone.init(secondsFromGMT: timeZone) else {
            throw TSDateTransferError.timeZoneError
        }
        
        self.originDateString = date
        self.originDateFormat = format
        self.originDateTimeZone = zone
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = self.originDateFormat
        dateFormat.timeZone = self.originDateTimeZone
        //解析时间戳
        guard let timeDate = dateFormat.date(from: date) else {
            throw TSDateTransferError.timeFormatError
        }
        let calendar = Calendar.current
        let dateComponets = calendar.dateComponents(in: self.originDateTimeZone, from: timeDate)
        let nowDate = Date()
        let nowComponets = calendar.dateComponents(in: self.originDateTimeZone, from: nowDate)
        if self.originDateFormat.contains("yyyy"), let intValue = dateComponets.year {
            self.year = String("\(intValue)")
        }
        if self.originDateFormat.contains("MM"), let intValue = dateComponets.month {
            self.month = String("\(intValue)")
        }
        if self.originDateFormat.contains("dd"), let intValue = dateComponets.day {
            self.day = String("\(intValue)")
        }
        if self.originDateFormat.contains("HH"), let intValue = dateComponets.hour {
            self.hour = String("\(intValue)")
        }
        if self.originDateFormat.contains("mm"), let intValue = dateComponets.minute {
            self.minute = String("\(intValue)")
        }
        if self.originDateFormat.contains("ss"), let intValue = dateComponets.second {
            self.second = String("\(intValue)")
        }
        // 是否有 yyyy MM dd
        if self.originDateFormat.contains("yyyy") && self.originDateFormat.contains("MM") && self.originDateFormat.contains("dd") {
            self.week = self.weekObject(dateComponets.weekday ?? 0)
            self.timeOffset = timeDate.timeIntervalSince(nowDate)
            ///今年 去年 明年
            if calendar.isDateInTomorrow(timeDate) {
                //明天
                self.dayNickname = .next
                self.yearNickname = .now
                //当月判断
                if let dateMonth = dateComponets.month , let nowMonth = nowComponets.month {
                    self.monthNickname = self.timeCompare(dateMonth, nowMonth)
                } else {
                    self.monthNickname = TSDateNickname.none
                }
            } else if calendar.isDateInYesterday(timeDate) {
                //昨天
                self.dayNickname = .last
                self.yearNickname = .now
                //当月判断
                if let dateMonth = dateComponets.month , let nowMonth = nowComponets.month {
                    self.monthNickname = self.timeCompare(dateMonth, nowMonth)
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
                            self.monthNickname = self.timeCompare(dateMonth, nowMonth)
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
    
    /// 当前时间
    public init() {
        /// 获取当前时间
        let date = Date()
        self.originDateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        self.originDateTimeZone = TimeZone.current
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = self.originDateFormat
        dateFormat.timeZone = self.originDateTimeZone
        self.originDateString = dateFormat.string(from: date)
        /// 将date分别解析出 年月日时分秒
        self.year = self.assignData(date: date, format: "yyyy")
        self.month = self.assignData(date: date, format: "MM")
        self.day = self.assignData(date: date, format: "dd")
        self.hour = self.assignData(date: date, format: "HH")
        self.minute = self.assignData(date: date, format: "mm")
        self.second = self.assignData(date: date, format: "MM")
        self.yearNickname = .now
        self.monthNickname = .now
        self.dayNickname = .now
        let calendar = Calendar.current
        let dateComponets = calendar.dateComponents(in: self.originDateTimeZone, from: date)
        self.week = self.weekObject(dateComponets.weekday ?? 0)
    }
    
//MARK: - private mothed
    /// get week
    private func weekObject(_ weekNum : Int) -> TSWeekName {
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
    private func timeCompare (_ timeCurrent : Int , _ nowTime : Int) -> TSDateNickname {
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
    
    /// date转string方法
    private func assignData(date: Date, format: String) -> String {
        let dateFormate = DateFormatter()
        dateFormate.timeZone = TimeZone.current
        dateFormate.dateFormat = format
        return dateFormate.string(from: date)
    }
}


/// 定义错误类型
enum TSDateTransferError: Error {
    
    case timeZoneError
    case timeFormatError
    
    var localizedDescription: String {
        
        switch self {
        case .timeZoneError:
            return "TSUtility: 时区错误"
        case .timeFormatError:
            return "TSUtility: 时间格式错误"
        }
    }
    
}
