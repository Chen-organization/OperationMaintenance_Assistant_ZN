//
//  WorkOrderDetailReturnObjModel.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class WorkOrderDetailReturnObjModel: BaseReturnObjModel {
    
    
    var workNo : String?
    
    var companyCode : String?
    var orgCode : String?
    var source : String?
    var workClass : String?
    var workType : String?
    var urgency : String?
    var biotopeCode : String?
    var longitude : String?
    var latitude : String?
    var houseName : String?
    var unitName : String?
    var houseNumber : String?
    var address : String?
    var contactMan : String?
    var tel : String?
    var repairsDesc : String?
    var dealDesc : String?
    var status : String?
    var isEvaluate : String?
    var isVisit : String?
    var orderNo : String?
    var payType : String?
    var isPay : String?
    var workName : String?
    var typeName : String?
    var createDateStr : String?
    var workSendId : String?
    var sendEmpNo : String?
    var sendEmpName : String?
    var repairsTime : String?
    var urgencyName : String?

    var workDealImgs : [WorkOrderDetailImgsModel]?
    
    
    lazy var cellHeight : Double = {
        
        if let a = self.repairsDesc{
            
            
            let statusLabelText: String = ("　　" + a)
            
            let h = statusLabelText.ga_heightForComment(fontSize: 14, width: ScreenW - 30)
            
            return Double(h + 86)
        }
        
     
        return 86
        
    }()
    
    
    
}
    
    
    // 计算文字高度或者宽度与weight参数无关
    extension String {
        
        func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
            let font = UIFont.systemFont(ofSize: fontSize)
            let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
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

