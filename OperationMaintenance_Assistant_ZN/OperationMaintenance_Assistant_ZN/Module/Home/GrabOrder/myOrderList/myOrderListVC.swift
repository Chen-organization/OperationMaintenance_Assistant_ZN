//
//  myOrderListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/15.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class myOrderListVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        UserCenter.shared.userInfo { (islogin, model) in
//
//            let para = [
//
//                "companyCode":model.companyCode,
//                "orgCode" : model.orgCode,
//                "empNo": model.empNo,
//                "empName": model.empName,
//                "orderID":model.orgCode ?? "",
//                "start":"1",
//                "ord": "20",
//                ]
//
//            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getMyGrabListUrl, modelClass: "BaseModel", response: { (obj) in
//
//                let model : readingListModel = obj as! readingListModel
//
//                if model.statusCode == 800 {
//
//                    if num == 1 {
//
//                        self.dataArray = model.returnObj ?? []
//
//                    }else{
//
//                        if let arr = model.returnObj{
//
//                            self.dataArray += arr
//
//                        }
//                    }
//
//
//                    self.nowpage = num;
//
//                    self.tableView.mj_header.endRefreshing()
//                    self.tableView.mj_footer.endRefreshing()
//
//                    self.tableView.reloadData()
//
//
//                }
//
//
//
//
//            }, failture: { (error) in
//
//                self.tableView.mj_header.endRefreshing()
//                self.tableView.mj_footer.endRefreshing()
//
//            })
//
//
//
//        }

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
