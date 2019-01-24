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

    //筛选顺序
    var selectedItemCode = 0
    
    var selectedItemCodeContentView = UIView()
    var selectBtn = UIButton()
    
    
    
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
        
        
        // 筛选
        let backButton = UIButton(type: .custom)
        self.selectBtn = backButton
        backButton.frame = CGRect(x: 200, y: 13, width: 30, height: 18)
        backButton.addTarget(self, action: #selector(selectedItem(btn:)), for: .touchUpInside)
//        backButton.setTitle("三脚下", for: UIControl.State.normal)
//        backButton.setTitle("三脚上", for: UIControl.State.normal)
        backButton.setImage(UIImage.init(named: "三角下"), for: UIControl.State.normal)
        backButton.setImage(UIImage.init(named: "三角上"), for: UIControl.State.selected)

        backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        // 自定义导航栏的UIBarButtonItem类型的按钮
        let backView = UIBarButtonItem(customView: backButton)
        // 重要方法，用来调整自定义返回view距离左边的距离
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = -5
        // 返回按钮设置成功
        navigationItem.rightBarButtonItems = [barButtonItem, backView]
        
        self.selectedItemCodeContentView.isHidden = true
        self.view.addSubview(self.selectedItemCodeContentView)
        self.selectedItemCodeContentView.backgroundColor = .white
        self.selectedItemCodeContentView.borderWidth = 2
        self.selectedItemCodeContentView.borderColor = RGBCOLOR(r: 230, 230, 230)
        self.selectedItemCodeContentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(NavHeight)
            make.right.equalTo(self.view).offset(0)
            make.size.equalTo(CGSize.init(width: 60, height: 80))
        }
        
        
        let timeButton = UIButton(type: .custom)
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        timeButton.backgroundColor = RGBCOLOR(r: 230, 230, 230)
        timeButton.addTarget(self, action: #selector(selectedTimeItem(btn:)), for: .touchUpInside)
        timeButton.setTitle("时间", for: UIControl.State.normal)
        timeButton.setTitleColor(.black, for: UIControl.State.normal)
       self.selectedItemCodeContentView.addSubview(timeButton)
        timeButton.snp.makeConstraints { (make) in
            
            make.top.left.equalTo(self.selectedItemCodeContentView).offset(5)
            make.right.equalTo(self.selectedItemCodeContentView).offset(-5)

        }
        
        
        let distanceButton = UIButton(type: .custom)
        distanceButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        distanceButton.addTarget(self, action: #selector(selectedDistanceItem(btn:)), for: .touchUpInside)
        distanceButton.backgroundColor = RGBCOLOR(r: 230, 230, 230)
        distanceButton.setTitle("距离", for: UIControl.State.normal)
        distanceButton.setTitleColor(.black, for: UIControl.State.normal)

        self.selectedItemCodeContentView.addSubview(distanceButton)
        distanceButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(timeButton.snp.bottom).offset(5)
            make.height.equalTo(timeButton.snp.height)
            make.left.equalTo(self.selectedItemCodeContentView).offset(5)
            make.right.equalTo(self.selectedItemCodeContentView).offset(-5)
            make.bottom.equalTo(self.selectedItemCodeContentView).offset(-5)

        }
        
     

        self.getDataWith(page: 1 ,code: selectedItemCode)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func selectedItem(btn:UIButton) {
        
        btn.isSelected = !btn.isSelected  
        
        self.selectedItemCodeContentView.isHidden = !btn.isSelected
        
    }
    @objc func selectedTimeItem(btn:UIButton) {
        
        self.selectedItemCode = 1
        self.repairTableview.mj_header.beginRefreshing()
        
        self.selectBtn.isSelected = false
        self.selectedItemCodeContentView.isHidden = true

        
    }
    
    @objc func selectedDistanceItem(btn:UIButton) {
        
        self.selectedItemCode = 2
        self.repairTableview.mj_header.beginRefreshing()

        self.selectBtn.isSelected = false
        self.selectedItemCodeContentView.isHidden = true
        
    }
    
    //MARK: - 数据
    func getDataWith(page:Int , code:Int) {
        
        UserCenter.shared.userInfo { (islogin, user) in
            
            var para = [
                
                "empName":user.empName,
                "orgCode":user.companyCode,
                "companyCode":user.companyCode,
                "start":page.description,
                "ord": "10",
                "state": self.selectedItemCode.description,
                "id":user.empNo
            ]
            
                para["code"] = "1"
           
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getWorkFristUrl, modelClass: "myOrdersModel", response: { (obj) in
                
                let model : myOrdersModel = obj as! myOrdersModel
                
                if model.statusCode == 800 {
                    
                    self.nowPage = page
                    
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
        
        self.getDataWith(page: 1,code: selectedItemCode)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getDataWith(page: self.nowPage + 1 , code: selectedItemCode)
        
    }

}
