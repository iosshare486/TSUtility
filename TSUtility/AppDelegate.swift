//
//  AppDelegate.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/16.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        vc.view.backgroundColor = .white
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 20.ts.scale(), y: 40.ts.scale(), width: 200.ts.scale(), height: 100.ts.scale()))
        label.font = 19.ts.font()
        label.textColor = 0xfc.ts.color()
        label.text = UIDevice().ts.appVersion
        label.backgroundColor = "#3".ts.color()
        
        let label1 = UILabel(frame: CGRect(x: 20, y: 140, width: 200, height: 400))
        label1.font = UIFont.systemFont(ofSize: 19)
        label1.textColor = "0x333333".ts.color()
        label1.text = UIDevice().ts.appVersion + "\n" + "\(UIDevice().ts.isIPhoneX)" + "\n" + UIDevice().ts.appName + "\n" + UIDevice().ts.deviceName + "\n" + UIDevice.current.systemVersion + "\n" + "\(UIDevice().ts.systemVersionGreaterThanOrEqualTo("11.1.0.2"))"  + "\n" + "\(UITabBar().ts.tabBarHeight)" + "\n" + "\(UINavigationBar().ts.navBarHeight)"
        
        label1.backgroundColor = "0x5cc3ff".ts.color(0.2)
        label1.numberOfLines = 0
        let sizeL = label1.text!.ts.boundingSize(font: UIFont.systemFont(ofSize: 19), limitSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), lineSpace: 10)
        label1.bounds = CGRect(x: 20, y: 140, width: sizeL.width, height: sizeL.height)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 19), NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        label1.attributedText = NSAttributedString.init(string: label1.text!, attributes: attributes)
        
        self.window?.addSubview(label)
        self.window?.addSubview(label1)

        print(0x333333.ts.color())
        print(0x333333.ts.color(0.75))
        print(13.ts.font())
        print(13.ts.boldFont())
        print(111.ts.string())
        print("0x111111".ts.color())
        print("0x111111".ts.color(0.7))
        print("12345678".ts.substring(2, 4))
        print(10.ts.scale())
        print(CGFloat(10.5).ts.scale())
        print(Float(10.5).ts.scale())
        print(Double(10.5).ts.scale())
        print(UITabBar().ts.tabBarHeight)
        print(UINavigationBar().ts.navBarHeight)
        print(UIDevice().ts.isIPhoneX)
        print(UIDevice().ts.appVersion)
        print(UIDevice().ts.appName)
        print(UIDevice().ts.deviceName)
//        print(UIDevice().ts.systemVersionGreaterThanOrEqualTo("11.0"))
        print("1s".ts.boundingSize(font: 13.ts.font(), limitSize: CGSize(width: 0, height: CGFloat(MAXFLOAT)), lineSpace: 0))
        let str = "123444".ts[0..<3]
        let char = "ffdfcc".ts.substring(toIndex: -1)
        print("\(str)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

