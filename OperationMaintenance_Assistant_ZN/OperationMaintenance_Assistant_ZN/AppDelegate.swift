//
//  AppDelegate.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/12.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import Alamofire

import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,BMKGeneralDelegate {

    var window: UIWindow?
    
    var _mapManager: BMKMapManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //地图
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("hblWV9xsl67jWi4uuTDup58EU0QKWnlb", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }

        //讯飞
        IFlySetting.setLogFile(LOG_LEVEL(rawValue: Int(LC_ALL)))
        IFlySetting.showLogcat(true)
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last
      IFlySetting.setLogFilePath(documentPath)
        
        let initString = "appid=" + "5c457c4f"
        IFlySpeechUtility.createUtility(initString)
        
        
        
        //设置tabbar
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        

        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 1
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                
                print("Realm 数据库配置成功")
            }
                /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        UITextField.appearance().tintColor = RGBCOLOR(r: 74, 144, 181)
        
//        _mapManager = BMKMapManager()
//        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
//        let ret = _mapManager?.start("T861GXQXTnAYjvF1MxfGlGpXGgFg4yhY", generalDelegate: self)
//        if ret == false {
//            NSLog("manager start failed!")
//        }
        
        
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            //可用
            UserCenter.shared.userInfo{ (islogin, userReturnModel) in
                
                if (islogin){

                    //初始化tabbar
                    let tabbarVC = TabeBarViewController()
                    self.window!.rootViewController = tabbarVC
                    
                }else{
                    //未登录
                    let vc = LoginVC.getLoginVC()
                    self.window?.rootViewController = vc
                }
            }
            
        }else{
            
            //未登录
            let vc = LoginVC.getLoginVC()
            self.window?.rootViewController = vc
            
        }
        
       

        self.window!.makeKeyAndVisible()
        
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

