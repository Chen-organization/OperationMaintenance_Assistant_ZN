//
//  YMNavigationController.swift
//  DanTang
//
//  Created  on 2017/3/24.
//  Copyright © 2017年  All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {


    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()

        
        //设置导航栏背景颜色
        self.navigationBar.barTintColor = UIColor.init(red: 31/255.0, green: 181/255.0, blue: 167/255.0, alpha: 1)
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        //标题颜色
        self.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        //item颜色
        self.navigationBar.tintColor = UIColor.white
        
    
    }
    
    
    /**
     # 统一所有控制器导航栏左上角的返回按钮
     # 让所有push进来的控制器，它的导航栏左上角的内容都一样
     # 能拦截所有的push操作
     - parameter viewController: 需要压栈的控制器
     - parameter animated:       是否动画
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        /// 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        if viewControllers.count > 0 {
            // push 后隐藏 tabbar
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(navigationBackClick))
        }
        super.pushViewController(viewController, animated: true)
    }
    /// 返回按钮
    @objc func navigationBackClick() {
       
        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        popViewController(animated: true)
    }
    
}
