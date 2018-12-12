//
//  BaseVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 71/255.0, green: 143/255.0, blue: 183/255.0, alpha: 1.0)
        
        // 设置初始导航栏透明度
        navBarBackgroundAlpha = 1.0
        
        // 设置导航栏按钮和标题颜色
        navBarTintColor = .white
        navBarTitleColor = .white
        statusBarStyle = UIStatusBarStyle.lightContent
        
        self.view.backgroundColor = UIColor.white
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
