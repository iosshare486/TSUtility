//
//  ViewController.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/16.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let dateObj = TSDateObject.init(date: "2018-10-10", format: "yyyy-MM-dd")
        let dateObj = TSDateObject.init(date: "ddd", format: "dddd", timeZone: 1111)
        let dateObj1 = TSDateObject.init(date: "2018")
        TSDateObject.init(date: "2018", format: "yyyy", timeZone: 28800)
        TSLog(dateObj.year)
        TSLog(dateObj.month)
        TSLog(dateObj.day)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

