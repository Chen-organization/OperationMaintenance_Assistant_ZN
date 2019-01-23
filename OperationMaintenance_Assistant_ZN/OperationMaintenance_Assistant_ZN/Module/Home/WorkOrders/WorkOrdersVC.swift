//
//  WorkOrdersVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class WorkOrdersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    
    
    var nowPage = 1

    var repairTableview = BasePullTableView()
    
    var repairArr = [myOrdersReturnObjModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "任务工单"
        
        self.view.backgroundColor = .white
        
        
        self.repairTableview.delegate = self
        self.repairTableview.dataSource = self
        self.repairTableview.pullDelegate = self
        self.repairTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.repairTableview.separatorColor = RGBCOLOR(r: 240, 240, 240)
        self.repairTableview.frame = self.view.bounds
        self.view.addSubview(self.repairTableview)
        

        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line.height = 0.5
        self.repairTableview.tableFooterView = line
        
        self.repairTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)

        self.getDataWith(page: 1)
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 数据
    func getDataWith(page:Int) {
        
        UserCenter.shared.userInfo { (islogin, user) in
            
            var para = [
                
                "empName":user.empName,
                "orgCode":user.companyCode,
                "companyCode":user.companyCode,
                "start":page.description,
                "ord": "10",
                "state":"0",
                "id":user.empNo
            ]
            
                para["code"] = "1"
           
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getWorkFristUrl, modelClass: "myOrdersModel", response: { (obj) in
                
                let model : myOrdersModel = obj as! myOrdersModel
                
                if model.statusCode == 800 {
                    
                    if page == 1 {
                        
          
                            self.repairArr = model.returnObj ?? []
                        
                        
                    }else{
                     
                            self.repairArr += model.returnObj ?? []
                        
                    }
                    
                    
                    self.repairTableview.configBlankPage(EaseBlankPageType.view, hasData: self.repairArr.count > 0, hasError: false, reloadButtonBlock: { (sure) in
                        
                    })
                    
                    self.repairTableview.reloadData()
                    self.repairTableview.mj_header.endRefreshing()
                    self.repairTableview.mj_footer.endRefreshing()
                    
                    
                    
                }
                
                
            }, failture: { (error) in
                
                
                
            })
            
        }
        
    }
    

    
    // MARK: - TableView Delegate  DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.repairArr.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyOrdersCell = tableView.dequeueReusableCell(withIdentifier: MyOrdersCell_id, for: indexPath) as! MyOrdersCell
        
        var model = myOrdersReturnObjModel()
        
        model = self.repairArr[indexPath.row]
      
        
        cell.imgView.kf.setImage(with: URL.init(string:model.imgs ?? ""), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in
            
        }, completionHandler: { (img) in
            
        })
        
        cell.titleL.text = (model.zc ?? "") + "|" + (model.zg ?? "")
        cell.orderNoL.text = model.id ?? ""
        cell.contentL.text = model.zv ?? ""
        cell.addressL.text = model.zb ?? ""
        cell.bottom1.text = model.zu ?? ""
        cell.bottom2.text = model.zd ?? ""
        
        if let distance = model.distance{
            
            cell.distanceL.text = String(format:"%.1f", Double(distance/1000)) + "km"
            
        }else{
            
            cell.distanceL.text = "0.0km"
            
        }
        
        let hourStr = ((model.timedifference ?? 0) / 1000 / 60 / 60 ).description + "小时"
        let minStr = ((model.timedifference ?? 0) / 1000 / 60 %  60 ).description + "分钟"
        cell.TimeL.text =  hourStr + minStr
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let model = self.repairArr[indexPath.row]
       
        let vc = orderDetailVC.getOrderDetailVC()
        vc.orderNo = model.id ?? ""
        
        if model.zu == "已安排" {
            vc.repairType = orderDetailType.repair

        }else if model.zu == "修理中" {
            
            vc.repairType = orderDetailType.repairing

        }else if model.zu == "待支付" {
            
            vc.repairType = orderDetailType.waitPay
            
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWith(page: 1)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getDataWith(page: self.nowPage + 1)
        
    }

}
