//
//  writeMeterModel.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/23.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import RealmSwift

class writeMeterModel:  Object  {

    @objc dynamic var id : String?
    @objc dynamic var deviceName : String?

    @objc dynamic var value : String?
    @objc dynamic var empId : String?
    @objc dynamic var org : String?
    @objc dynamic var type : String?
    @objc dynamic var file : String?
    @objc dynamic var file2 : String?
    @objc dynamic var longitude : String?
    @objc dynamic var latitude : String?
    @objc dynamic var status : String?
    @objc dynamic var time : String?
    @objc dynamic var remark : String?
    @objc dynamic var isMoreThanMax : String?
    @objc dynamic var thresholdMax : String?

    
    
    
    
}
