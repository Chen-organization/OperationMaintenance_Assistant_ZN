//
//  WorkOrderDetailReturnObjModel.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import HandyJSON

class WorkOrderDetailReturnObjModel: HandyJSON {
    
    
    var workcontent : String?
    
    var orderno : String?
    var address : String?
    var tel : String?
    var configname : String?
    var repairsdesc : String?
    var longitude : String?
    var latitude : String?
    var date : String?
    var arr : [String]?
    var are : [String]?
    var art : [String]?
    var distance : String?
    var workclass : String?
    var worktype : String?
    var urgency : String?
    var status : String?
    var paytype : String?
    var ispay : String?
    var dealdesc : String?
    var arrdate : String?
    var dealdate : String?
    var price : Double?
    var qty : Double?
    var fee : Double?
    var ast : String?
    var total : Double?

    

    var contactman : String?

    var mapArr : [WorkOrderDetailMapModel]?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        
        mapper.specify(property: &mapArr, name: "map")

    }
   


//    var workDealImgs : [WorkOrderDetailImgsModel]?

    
    
    lazy var repairsdescHeight : Double = {

        if let a = self.repairsdesc{

            let statusLabelText: String = ("" + a)

            let h = statusLabelText.ga_heightForComment(fontSize: 16, width: ScreenW - 30)

            return Double(h + 30)
        }

        return 50

    }()
    
    
    lazy var dealdescHeight : Double = {
        
        if let a = self.dealdesc{
            
            let statusLabelText: String = ("" + a)
            
            let h = statusLabelText.ga_heightForComment(fontSize: 14, width: ScreenW - 30)
            
            return Double(h + 30)
        }
        
        return 50
        
    }()
    
    
    lazy var repairContentCellHeight : Double = {
        
        var height = 0.0
        
        if let a = self.dealdesc{
            
            let statusLabelText: String = ("" + a)
            
            let h = statusLabelText.ga_heightForComment(fontSize: 14, width: ScreenW - 30)
            
            height = Double(h + 30)
        }
        
        if self.arr?.count ?? 0 > 0 {
            
            height = height + Double((ScreenW - 60)/3) + 30
            
        }
        
        
        return height
        
    }()

    lazy var dealedCellHeight : Double = {
        
        var height = 0.0
        
        if let a = self.dealdesc{
            
            let statusLabelText: String = ("" + a)
            
            let h = statusLabelText.ga_heightForComment(fontSize: 14, width: ScreenW - 30)
            
            height = Double(h + 30)
        }
        
        if self.art?.count ?? 0 > 0 {
            
            height = height + Double((ScreenW - 60)/3) + 30
            
        }
        
        if self.mapArr?.count ?? 0 > 0 {
            
            height = height + Double((self.mapArr?.count ?? 0) * 35 )
            
        }
        
        
        return height + 50
        
    }()

}

    
    // 计算文字高度或者宽度与weight参数无关
    extension String {
        
        func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
            let font = UIFont.systemFont(ofSize: fontSize)
            let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(rect.height)
        }
        
    }
    
  
    
    
 
//    "createDate": 1511431815000,
//    "arrDate": 1511488098000,
//    "dealDate": 1511488150000,
//    "": "1001201711240001",
//    "": 1,
//    "": 1,
//    "": "报修",
//    "": "不热",
//    "": "2017-11-23 18:10:15",
//    "": 414,
//    "": "E100100009",
//    "": "王利海",
//    "": 99051,
//    "": "一般",
//    "": []

