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
        
        tabBar.isTranslucent = false
        
        self.setUpAllChildViewController()
    }
    
    
    func setUpAllChildViewController() {

        let home = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.setUpOneChildViewController(viewController: home, image: "首页", selectedImage: "首页Sel", title: "")
        
        self.setUpOneChildViewController(viewController: InspectionVC(), image: "巡检", selectedImage: "巡检Sel", title: "")
        
        let meterReading = UIStoryboard(name: "MeterReading", bundle: nil)
            .instantiateViewController(withIdentifier: "MeterReadingVC") as! MeterReadingVC
        self.setUpOneChildViewController(viewController: meterReading, image: "抄表", selectedImage: "抄表Sel", title: "")
        
        let me = UIStoryboard(name: "Me", bundle: nil)
            .instantiateViewController(withIdentifier: "MeVC") as! MeVC
        self.setUpOneChildViewController(viewController: me, image: "我的", selectedImage: "我的Sel", title: "")
    }
    
    
    func setUpOneChildViewController(viewController: UIViewController, image: String, selectedImage: String, title: NSString) {
        
        let navVC = NavigationController.init(rootViewController: viewController)
        
        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        let barItem : UITabBarItem = UITabBarItem.init(title: title as String, image: UIImage.init(named: image), selectedImage: UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal))

        barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);


        navVC.tabBarItem = barItem
        
        self.addChild(navVC)
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



class SafeAreaFixTabBar: UITabBar {
    
    var oldSafeAreaInsets = UIEdgeInsets.zero
    
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        if oldSafeAreaInsets != safeAreaInsets {
            oldSafeAreaInsets = safeAreaInsets
            
            invalidateIntrinsicContentSize()
            superview?.setNeedsLayout()
            superview?.layoutSubviews()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            let bottomInset = safeAreaInsets.bottom
            if bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90) {
                size.height += bottomInset
            }
        }
        return size
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var tmp = newValue
            if let superview = superview, tmp.maxY !=
                superview.frame.height {
                tmp.origin.y = superview.frame.height - tmp.height
            }
            
            super.frame = tmp
        }
    }
}

