//
//  BaseModel.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {
    
    var statusCode: Int?
    var msg: String?
    
    required init() {} // 如果定义是struct，连init()函数都不用声明；
    
}

