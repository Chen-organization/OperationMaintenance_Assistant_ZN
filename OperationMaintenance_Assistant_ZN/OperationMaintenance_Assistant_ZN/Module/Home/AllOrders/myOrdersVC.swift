//
//  myOrdersVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

enum ordersTableViewType : Int {
    case repair=0, repairing, repaired
}

import UIKit


class myOrdersVC:UIViewController,MXSegmentedPagerDelegate, MXSegmentedPagerDataSource,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {

    var selectedIndex : ordersTableViewType = ordersTableViewType.repair
    
    var nowPage = 1
    
    
    let segmentedPager = MXSegmentedPager()
    
    var repairTableview = BasePullTableView()
    var repairingTableview = BasePullTableView()
    var repairedTableview = BasePullTableView()
    
    
    var repairArr = [myOrdersReturnObjModel]()
    var repairingArr = [myOrdersReturnObjModel]()
    var repairedArr = [myOrdersReturnObjModel]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的工单"
        
        self.view.backgroundColor = .white
        
        self.edgesForExtendedLayout = []

        
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        segmentedPager.backgroundColor = .white
        self.view.addSubview(segmentedPager)

        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = .white
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : RGBCOLOR(r: 24, 151, 138), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        segmentedPager.segmentedControl.selectionStyle = .textWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = RGBCOLOR(r: 24, 151, 138)
        segmentedPager.segmentedControl.selectionIndicatorHeight = 2
        segmentedPager.segmentedControl.borderType = .bottom
        segmentedPager.segmentedControl.borderColor = RGBCOLOR(r: 245, 245, 245)
        segmentedPager.segmentedControl.borderWidth = -10
        segmentedPager.segmentedControlEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        
        self.repairTableview.tag = ordersTableViewType.repair.rawValue
        self.repairingTableview.tag = ordersTableViewType.repairing.rawValue
        self.repairedTableview.tag = ordersTableViewType.repaired.rawValue

        self.repairTableview.delegate = self
        self.repairingTableview.delegate = self
        self.repairedTableview.delegate = self
        
        self.repairTableview.dataSource = self
        self.repairingTableview.dataSource = self
        self.repairedTableview.dataSource = self
        
        self.repairTableview.pullDelegate = self
        self.repairingTableview.pullDelegate = self
        self.repairedTableview.pullDelegate = self
        
        self.repairTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.repairingTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.repairingTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

        
        self.repairTableview.separatorColor = RGBCOLOR(r: 240, 240, 240)
        self.repairingTableview.separatorColor = RGBCOLOR(r: 240, 240, 240)
        self.repairedTableview.separatorColor = RGBCOLOR(r: 240, 240, 240)
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line.height = 0.5
        self.repairTableview.tableFooterView = line
        
        let line1 = UIView()
        line1.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line1.height = 0.5
        self.repairingTableview.tableFooterView = line1
        
        let line2 = UIView()
        line2.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line2.height = 0.5
        self.repairedTableview.tableFooterView = line
        
        
        self.repairTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)
        self.repairingTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)
        self.repairedTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)

        self.getDataWith(page: 1, type: self.selectedIndex)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        self.segmentedPager.pager.showPage(at: selectedIndex.rawValue, animated: false)
        
        self.segmentedPager.reloadData()

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        self.segmentedPager.frame = self.view.bounds

        
    }
    
    //MARK: - 数据
    func getDataWith(page:Int , type:ordersTableViewType) {
        
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
            
            switch (type){

                case ordersTableViewType.repair :
                para["code"] = "3"
                    break
            case ordersTableViewType.repairing :
                para["code"] = "4"
                    break
            case ordersTableViewType.repaired:
                para["code"] = "5"
                    break
                default :
                    break
                
            }
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getWorkFristUrl, modelClass: "myOrdersModel", response: { (obj) in
                
                let model : myOrdersModel = obj as! myOrdersModel
                
                if model.statusCode == 800 {
                    
                    if page == 1 {
                        
                        
                        switch (type){
                            
                        case ordersTableViewType.repair :
                            self.repairArr = model.returnObj ?? []
                            break
                        case ordersTableViewType.repairing :
                            self.repairingArr = model.returnObj ?? []
                            break
                        case ordersTableViewType.repaired:
                            self.repairedArr = model.returnObj ?? []

                            break
                        default :
                            break
                            
                        }
                        
                    }else{
                        
                        switch (type){
                            
                        case ordersTableViewType.repair :
                            self.repairArr += model.returnObj ?? []
                            break
                        case ordersTableViewType.repairing :
                            self.repairingArr += model.returnObj ?? []
                            break
                        case ordersTableViewType.repaired:
                            self.repairedArr += model.returnObj ?? []
                            
                            break
                        default :
                            break
                            
                        }
                        
                    }
                    
                    
                    self.repairTableview.reloadData()
                    self.repairTableview.mj_header.endRefreshing()
                    self.repairTableview.mj_footer.endRefreshing()
                    
                    self.repairingTableview.reloadData()
                    self.repairingTableview.mj_header.endRefreshing()
                    self.repairingTableview.mj_footer.endRefreshing()
                    
                    self.repairedTableview.reloadData()
                    self.repairedTableview.mj_header.endRefreshing()
                    self.repairedTableview.mj_footer.endRefreshing()
                    
                    

                }
                
                
            }, failture: { (error) in
                
                
                
            })
            
        }
        
    }
    
    
    //MARK: - SEGMENT
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["待维修", "维修中", "已完成"][index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        
        return 3
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        return [repairTableview,repairingTableview,repairedTableview][index]
    }

    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        
        self.selectedIndex = ordersTableViewType(rawValue: segmentedPager.pager.indexForSelectedPage)!
        
        if segmentedPager.pager.indexForSelectedPage == ordersTableViewType.repair.rawValue {
            
            if !(self.repairArr.count > 0){
                
                self.getDataWith(page: 1, type: ordersTableViewType.repair)
            }
            
        }else if segmentedPager.pager.indexForSelectedPage == ordersTableViewType.repairing.rawValue {
            
            if !(self.repairingArr.count > 0){
                
                self.getDataWith(page: 1, type: ordersTableViewType.repairing)
            }
            
        }else {
            
            
                if !(self.repairedArr.count > 0){
                    
                    self.getDataWith(page: 1, type: ordersTableViewType.repaired)
                }
            
        }
        
    }
    
    // MARK: - TableView Delegate  DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (tableView.tag){
            
        case 0 :
            return self.repairArr.count
        case 1 :
            return self.repairingArr.count
            
        case 2:
            return self.repairedArr.count
            
        default :
            break
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyOrdersCell = tableView.dequeueReusableCell(withIdentifier: MyOrdersCell_id, for: indexPath) as! MyOrdersCell
        
        var model = myOrdersReturnObjModel()
        
        if tableView.tag == ordersTableViewType.repair.rawValue {
            
            model = self.repairArr[indexPath.row]
            
        } else if tableView.tag == ordersTableViewType.repairing.rawValue {
            
            model = self.repairingArr[indexPath.row]

        }else if tableView.tag == ordersTableViewType.repaired.rawValue {
            
            model = self.repairedArr[indexPath.row]

        }
 
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
        
        let vc = orderDetailVC.getOrderDetailVC()

        var model : myOrdersReturnObjModel = myOrdersReturnObjModel()
        
        if tableView.tag == ordersTableViewType.repair.rawValue{
            
            model = self.repairArr[indexPath.row]
            vc.repairType = orderDetailType.repair

        }else if tableView.tag == ordersTableViewType.repairing.rawValue{
            
            model = self.repairingArr[indexPath.row]
            vc.repairType = orderDetailType.repairing

        }else if tableView.tag == ordersTableViewType.repaired.rawValue{
            
            model = self.repairedArr[indexPath.row]
            vc.repairType = orderDetailType.repaired

        }
        
        vc.orderNo = model.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWith(page: 1, type: ordersTableViewType(rawValue: (pullTableView!.tag)) ?? ordersTableViewType(rawValue: 0)!)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getDataWith(page: self.nowPage + 1, type: ordersTableViewType(rawValue: (pullTableView?.tag)!)!)

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
