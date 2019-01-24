//
//  RepairRecordsVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/25.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class RepairRecordsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    
    var orderNo = ""
    
    var nowPage = 1
    
    var tableview = BasePullTableView()
    var dataArr = [repairRecordsReturnObjModel]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "维修记录"
        self.tableview.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.pullDelegate = self
        self.tableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableview.separatorColor = RGBCOLOR(r: 240, 240, 240)
        self.tableview.frame = self.view.bounds
        self.view.addSubview(self.tableview)
        
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line.height = 0.5
        self.tableview.tableFooterView = line
        
        self.tableview.register(UINib.init(nibName: "repairRecordsCell", bundle: nil), forCellReuseIdentifier: repairRecordsCell_id)
        
        
        self.getDataWith(page: 1 )


        
        
        
        
    }
    

    //MARK: - 数据
    func getDataWith(page:Int) {
        
        UserCenter.shared.userInfo { (islogin, user) in
            
            var para = [
                
                "empName":user.empName,
                "orgCode":user.companyCode,
                "companyCode":user.companyCode,
                "empNo":user.empNo,

                "start":page.description,
                "ord": "8",
                "id":self.orderNo
            ]
            
            
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getMaintenanceRecordURL, modelClass: "repairRecordsModel", response: { (obj) in
                
                let model : repairRecordsModel = obj as! repairRecordsModel
                
                if model.statusCode == 800 {
                    
                    self.nowPage = page
                    
                    if page == 1 {
                        
                        
                        self.dataArr = model.returnObj ?? []
                        
                        
                    }else{
                        
                        self.dataArr += model.returnObj ?? []
                        
                    }
                    
                    
                    self.tableview.configBlankPage(EaseBlankPageType.view, hasData: self.dataArr.count > 0, hasError: false, reloadButtonBlock: { (sure) in
                        
                    })
                    
                    self.tableview.reloadData()
                    self.tableview.mj_header.endRefreshing()
                    self.tableview.mj_footer.endRefreshing()
                    
                    
                    
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
        
        return self.dataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : repairRecordsCell = tableView.dequeueReusableCell(withIdentifier: repairRecordsCell_id, for: indexPath) as! repairRecordsCell

        let model = self.dataArr[indexPath.row]
        
        cell.dateL.text = self.timeStampToString(timeStamp: model.date ?? "")
        cell.nameL.text = model.name ?? ""
        cell.contentL.text = model.desc ?? ""
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let model = self.dataArr[indexPath.row]
        
        let vc = orderDetailVC.getOrderDetailVC()
        vc.orderNo = model.workno ?? ""
        vc.repairType = orderDetailType.repaired
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWith(page: 1)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getDataWith(page: self.nowPage + 1 )
        
    }
    
    
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
    }

}
