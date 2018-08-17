//
//  TSTimerControl.swift
//  TSUtility
//
//  Created by 洪利 on 2018/8/17.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

@objc public protocol TS_TimerCountDown {
    @objc func ts_timeCountDown()
}


public var ts_timerControl = TSTimerControl.createConfig()
open class TSTimerControl: NSObject {

    var ts_timer_interval : TimeInterval = 0.1
    var ts_service_stack = [[String : AnyObject]]()
    var time_counting = 0.0
    
    var timer : Timer?
    
    static var configSinglation : TSTimerControl?
    class func createConfig() ->TSTimerControl {
        if configSinglation == nil {
            let config = TSTimerControl()
            return config
        }else{
            return configSinglation!
        }
    }
    
    //启动时间工具
    func addMession(timeinterval : TimeInterval, target : NSObject?) {
        if target != nil {
            let dic = ["target":target!,
                       "time":(timeinterval)] as [String : AnyObject]
            ts_service_stack.append(dic as [String : AnyObject])
        }
        if self.timer == nil {
            time_counting = 0.0
            if #available(iOS 10.0, *) {
                self.timer = Timer.scheduledTimer(withTimeInterval: ts_timer_interval, repeats: true, block: { (tim) in
                    self.countDown()
                })
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: ts_timer_interval, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            }
        }
    }
    //事件派发
    @objc func countDown() {
        //检查元素合法性
        checkInstanceWetherNil()
        //派发事件
        time_counting += 0.1
        if ts_service_stack.count > 0 {
            for (_, value) in ts_service_stack.enumerated() {
                let time = (value["timer"])?.doubleValue
                if time_counting >= Double(time!) {
                    if value["target"] != nil {
                        let target :NSObject = value["target"] as! NSObject
                        if target.conforms(to: TS_TimerCountDown.self){
                            (target as! TS_TimerCountDown).ts_timeCountDown()
                        }
                    }
                }
            }
            
        }
    }
    
    func checkInstanceWetherNil() {
        if ts_service_stack.count > 0 {
            for (index, value) in ts_service_stack.enumerated() {
                if value["target"] != nil {
                    ts_service_stack.remove(at: index)
                }
            }
        }
    }
    func removeTarget(target:NSObject) {
        for (index, value) in ts_service_stack.enumerated() {
            if (value["target"]?.isEqual(target))!  {
                ts_service_stack.remove(at: index)
            }
        }
    }
    
    //无任务状态，清理单例
    func cleanMemory() {
        self.timer?.invalidate()
        self.timer = nil
        self.time_counting = 0.0
        free(&ts_timerControl)
    }
}


public extension NSObject {
    public func resign_timeEvent(timeinterval: TimeInterval){
        //启动timer工具，添加服务
        ts_timerControl.addMession(timeinterval: timeinterval, target: self)
    }
    
    public func remove_timeEvent(){
        //移除
        ts_timerControl.removeTarget(target: self)
    }
}



