//
//  GRabOrdersVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class GRabOrdersVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,grabOrderCellDelegate {
    
    var mapVC : GrabOrdersMapVC?
    
    
    var nowPage = 1
    
    var repairTableview = BasePullTableView()
    
    var repairArr = [myOrdersReturnObjModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "抢单池"
        
        self.repairTableview.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.view.backgroundColor = .white
        
        
        self.repairTableview.delegate = self
        self.repairTableview.dataSource = self
        self.repairTableview.pullDelegate = self
        self.repairTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.repairTableview.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.repairTableview.frame = self.view.bounds
        self.view.addSubview(self.repairTableview)
        
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line.height = 0.5
        self.repairTableview.tableFooterView = line
        
        self.repairTableview.register(UINib.init(nibName: "grabOrderCell", bundle: nil), forCellReuseIdentifier: grabOrderCell_id)
        
        
        
        // 维修记录
        let map = UIButton(type: .custom)
        map.frame = CGRect(x: 200, y: 13, width: 18, height: 18)
        map.addTarget(self, action: #selector(toMap(btn:)), for: .touchUpInside)
//        map.setTitle("记录", for: UIControl.State.normal)
//        map.setTitleColor(UIColor.white, for: UIControl.State.normal)
        map.setImage(UIImage.init(named: "定位白"), for: UIControl.State.normal)
        map.setImage(UIImage.init(named: ""), for: UIControl.State.selected)

        // 自定义导航栏的UIBarButtonItem类型的按钮
        let backView = UIBarButtonItem(customView: map)
        // 重要方法，用来调整自定义返回view距离左边的距离
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = -5
        // 返回按钮设置成功
        navigationItem.rightBarButtonItems = [barButtonItem, backView]
        
        
        self.getDataWith(page: 1)
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 地图
    @objc func toMap(btn:UIButton)  {
        
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            
            if self.mapVC == nil {
                
                let vc = GrabOrdersMapVC()
                self.mapVC = vc
                vc.view.frame = self.view.bounds
                self.addChild(vc)
                self.view.insertSubview(vc.view, at: 0)
                
            }
            UIView.animate(withDuration: 0.3, animations: {
                
                self.repairTableview.isHidden = true

            }) { (sure) in

                
            }
            self.title = "定位抢单"
            //MARK: - 是否刷新数据
            
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.repairTableview.isHidden = false
                
            }) { (sure) in
                
                
            }
            self.title = "抢单池"
        }
        
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
            
            para["code"] = "2"
            
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getWorkFristUrl, modelClass: "myOrdersModel", response: { (obj) in
                
                let model : myOrdersModel = obj as! myOrdersModel
                
                if model.statusCode == 800 {
                    
                    if page == 1 {
                        
                        
                        self.repairArr = model.returnObj ?? []
                        
                        
                    }else{
                        
                        self.repairArr += model.returnObj ?? []
                        
                    }
                    
                    self.repairTableview.configBlankPage(EaseBlankPageType.view, hasData: self.repairArr.count > 0, hasError: false, reloadButtonBlock: { (a) in
                        
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
        
        let cell : grabOrderCell = tableView.dequeueReusableCell(withIdentifier: grabOrderCell_id, for: indexPath) as! grabOrderCell
        
        var model = myOrdersReturnObjModel()

        model = self.repairArr[indexPath.row]

        cell.titleL.text = (model.workname ?? "") + " | " + (model.typename ?? "")
        cell.conentL.text = model.repairsdesc ?? ""
        cell.address.text = model.address ?? ""

        if let distance = model.distance{

            cell.distanceL.text = String(format:"%.1f", Double(distance/1000)) + "km"

        }else{

            cell.distanceL.text = "0.0km"

        }

        let hourStr = ((model.timedifference ?? 0) / 1000 / 60 / 60 ).description + "小时"
        let minStr = ((model.timedifference ?? 0) / 1000 / 60 %  60 ).description + "分钟"
        cell.timeL.text =  hourStr + minStr
        
        cell.Index = indexPath.row
        cell.grabDelegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = orderDetailVC.getOrderDetailVC()
        
        var model : myOrdersReturnObjModel = myOrdersReturnObjModel()
        model = self.repairArr[indexPath.row]
        vc.repairType = orderDetailType.repair
        vc.orderNo = model.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWith(page: 1)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getDataWith(page: self.nowPage + 1)
        
    }
    
    //MARK: - CELL DELEGATE
    func grabOrder(index: Int) {
        
        YJProgressHUD.showProgress("", in: UIApplication.shared.keyWindow)
        
        let orderModel :myOrdersReturnObjModel  = self.repairArr[index]
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = [
                
                "companyCode":model.companyCode,
                "orgCode" : model.orgCode,
                "empNo": model.empNo,
                "empName": model.empName,
                "orderID":orderModel.workno ?? "",
                "start":"1",
                "ord": "20",
                ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getMyGrabListUrl, modelClass: "BaseModel", response: { (obj) in

                YJProgressHUD.hide()

                let model : BaseModel = obj as! BaseModel
                
                if model.statusCode == 800 {
                    
                    self.repairArr.remove(at: index)
                    self.repairTableview.reloadData()
                
                    self.navigationController?.pushViewController(myOrderListVC(), animated: true)
                    
                }

                
            }, failture: { (error) in
                
              
                YJProgressHUD.hide()

            })
            
            
            
        }

        
    }
    
    
}
