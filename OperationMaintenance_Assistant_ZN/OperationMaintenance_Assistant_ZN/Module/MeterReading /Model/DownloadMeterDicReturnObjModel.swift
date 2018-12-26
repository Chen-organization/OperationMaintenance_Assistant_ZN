//
//  DownloadMeterDicReturnObjModel.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/22.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import RealmSwift
import HandyJSON

class DownloadMeterDicReturnObjModel: Object,HandyJSON {
    
    
    @objc dynamic var deviceNum : String?
    @objc dynamic var id : String?
    @objc dynamic var installSite : String?
    @objc dynamic var measureUnit : String?
    @objc dynamic var multiplyingPower : String?
    @objc dynamic var name : String?
    @objc dynamic var nowValue = 0
    @objc dynamic var orgCode : String?
    @objc dynamic var stationName : String?
    @objc dynamic var stationNo : String?
    @objc dynamic var thresholdMax : String?

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
