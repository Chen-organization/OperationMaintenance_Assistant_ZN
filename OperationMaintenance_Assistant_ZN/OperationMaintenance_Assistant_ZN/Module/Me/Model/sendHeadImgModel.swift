//
//  sendHeadImgModel.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/26.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import HandyJSON

class sendHeadImgModel: HandyJSON {

    var statusCode : Int?
    var msg : String?
    var returnObj : String?

    required init() {} // 如果定义是struct，连init()函数都不用声明；

}
