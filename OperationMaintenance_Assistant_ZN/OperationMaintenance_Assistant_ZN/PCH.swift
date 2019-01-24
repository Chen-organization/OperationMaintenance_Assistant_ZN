//
//  PCH.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/12.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import SnapKit

func PrintLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DebugType
    print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息\(message)");
    #endif
}

func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

let IS_iPhoneX = (UIScreen.main.bounds.size.width == 375 && UIScreen.main.bounds.size.height == 812)

let is_X_XS_max = UIScreen.main.bounds.size.height >= 812

let ScreenH = UIScreen.main.bounds.size.height
let ScreenW = UIScreen.main.bounds.size.width

let NavHeight = is_X_XS_max ? 88.0 : 64.0

public let statusBarheight = UIApplication.shared.statusBarFrame.size.height


