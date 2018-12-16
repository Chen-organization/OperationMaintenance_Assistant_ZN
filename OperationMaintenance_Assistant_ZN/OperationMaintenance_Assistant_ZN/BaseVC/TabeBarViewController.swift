//
//  TabeBarViewController.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/13.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

class TabeBarViewController: UITabBarController {

    var tabBarBgImg:UIImageView?
    var tabBarBgImgSelected:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*
         * 更改tabBar选中按钮的颜色
         */
        
        self.setUpAllChildViewController()
    }
    
    
    func setUpAllChildViewController() {

        
        self.setUpOneChildViewController(viewController: HomeVC(), image: "", selectedImage: "", title: "首页")
        
        self.setUpOneChildViewController(viewController: InspectionVC(), image: "", selectedImage: "", title: "巡检")
        
        let meterReading = UIStoryboard(name: "MeterReading", bundle: nil)
            .instantiateViewController(withIdentifier: "MeterReadingVC") as! MeterReadingVC
        self.setUpOneChildViewController(viewController: meterReading, image: "", selectedImage: "", title: "抄表")
        
        self.setUpOneChildViewController(viewController: MeVC(), image: "", selectedImage: "", title: "我的")
    }
    
    
    func setUpOneChildViewController(viewController: UIViewController, image: String, selectedImage: String, title: NSString) {
        
        let navVC = NavigationController.init(rootViewController: viewController)
        
        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        navVC.tabBarItem = UITabBarItem.init(title: title as String, image: UIImage.init(named: image), selectedImage: UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal))
        
        self.addChildViewController(navVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

