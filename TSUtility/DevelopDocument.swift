//
//  DevelopDocument.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

/*
  开发文档：
 主要功能：
Int:
 Int -> Color example:
    1、Int.ts.color()
    2、Int.ts.color(alpha)
 Int -> font example:
    Int.ts.font()
    Int.ts.boldFont()
 Int -> String example:
    Int.ts.string()
 
String:
 String -> Color example:
    1、String.ts.color()
    2、String.ts.color(alpha)
 String -> 获取指定下标的子字符串:
    1、String.ts[0..3] -> 0-2下标字符串
    2、String.ts[3] -> 3下标字符
    3、String.ts[0..3] -> 0-2下标字符串
    4、String.ts.substring(toIndex : 3) -> 截图到位置3的字符串
    5、String.ts.substring(fromIndex : 3) -> 从位置3截图的字符串
    6、String.ts.dropLast(3) -> 删除后三位字符后的字符串
    7、String.ts.dropLast -> 删除后一位字符后的字符串
 version compare
    "9.0".versionCompare("11.0") -> ComparisonResult.orderedAscending
 
 
 
Scale: <Int; CGFloat; Double; Float>
 example:
    1、Int.ts.scale()
    2、CGFloat.ts.scale()
    3、Double.ts.scale()
    4、Float.ts.scale()
 
设备信息
 navBarHeight:
    UINavigationBar().ts.navBarHeight
 tabBarHeight:
    UITabBar().ts.tabBarHeight
 是否是iPhoneX
    UIDevice().ts.isIPhoneX
 应用版本
    UIDevice().ts.appVersion
 应用名称
    UIDevice().ts.appName
 设备名称
    UIDevice().ts.deviceName
 系统版本是否大于等于指定版本
    UIDevice().ts.systemVersionGreaterThanOrEqualTo("11.0")->Bool
 
 时间的处理
    创建时间结构体:
    1.TSDateObject.init(date: "2018-02-20")
    1.TSDateObject.init(date: "2018", format: "yyyy")
    2.TSDateObject.init(date: "2018", format: "yyyy", timeZone: 28800) PS:时区需要换算为秒 东八区即为 8 * 60 * 60 （可以了解一下TimeZone的创建）
    获取当前时间结构体:
    TSDateObject()
    提供时间的属性：
     var year: 年
     var month: 月
     var day: 日
     var hour: 小时
     var minute: 分钟
     var second: 秒
     ///以下属性必须有年 月 日才可有值
     /// 距离当前时间秒数间隔 可根据需求自行处理。
     var timeOffset: TimeInterval?
     /// 周几
     var week
     /// 表示是今年明年去年
     var yearNickname
     /// 表示是当月上月下月
     var monthNickname
     /// 表示是今天明天昨天
     var dayNickname
 */
 
 
 
