//
//  myBillListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class myBillListVC: UIViewController,MXSegmentedPagerDelegate, MXSegmentedPagerDataSource,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate  {
    
    
    
    var repairBillPage = 1
    var heatingBillPage = 1

    
    let segmentedPager = MXSegmentedPager()
    
    var repairBillTableview = BasePullTableView()
    var heatingBillTableview = BasePullTableView()
    
    
    var repairBillArr = [myBillListReturnObjModel]()
    var heatingBillArr = [myBillListReturnObjModel]()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "收款账单"
        
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
        
        self.repairBillTableview.tag = 1000
        self.heatingBillTableview.tag = 2000
        
        self.repairBillTableview.delegate = self
        self.heatingBillTableview.delegate = self
        
        self.repairBillTableview.dataSource = self
        self.heatingBillTableview.dataSource = self
        
        self.repairBillTableview.pullDelegate = self
        self.heatingBillTableview.pullDelegate = self
        
        self.repairBillTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.heatingBillTableview.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        
        self.repairBillTableview.separatorColor = UIColor.clear
        self.heatingBillTableview.separatorColor = UIColor.clear
        
        self.repairBillTableview.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.heatingBillTableview.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line.height = 0.5
        self.repairBillTableview.tableFooterView = line
        
        let line1 = UIView()
        line1.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        line1.height = 0.5
        self.heatingBillTableview.tableFooterView = line1
        
      
        
        self.repairBillTableview.register(UINib.init(nibName: "myBillListCell", bundle: nil), forCellReuseIdentifier: myBillListCell_id)
        self.heatingBillTableview.register(UINib.init(nibName: "myBillListCell", bundle: nil), forCellReuseIdentifier: myBillListCell_id)
        
        self.getDataWith(page: 1, type:1000)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
//        self.segmentedPager.pager.showPage(at: selectedIndex.rawValue, animated: false)
        
        self.segmentedPager.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        self.segmentedPager.frame = self.view.bounds
        
        
    }
    
    //MARK: - 数据
    func getDataWith(page:Int , type:Int) {

        UserCenter.shared.userInfo { (islogin, user) in

            let para = [

                "empName":user.empName,
                "empNo":user.empNo,
                "orgCode":user.companyCode,
                "companyCode":user.companyCode,
                "start":page.description,
                "ord": "10",
                "str": type == 1000 ?  "1" : "2"
            ]


          
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getParagraphURL, modelClass: "myBillListModel", response: { (obj) in

                let model : myBillListModel = obj as! myBillListModel

                if model.statusCode == 800 {

                    if page == 1 {

                        if type == 1000{
                            
                            self.repairBillPage = 1
                            self.repairBillArr.removeAll()
                            self.repairBillArr += model.returnObj ?? []
                        }else{
                            
                            self.heatingBillPage = 1
                            self.heatingBillArr.removeAll()
                            self.heatingBillArr += model.returnObj  ?? []
                        }
                       

                    }else{

                        
                        if type == 1000{
                            
                            self.repairBillPage += 1
                            self.repairBillArr += model.returnObj  ?? []
                        }else{
                            
                            self.heatingBillPage += 1
                            self.heatingBillArr += model.returnObj  ?? []
                        }
                     
                    }


                    self.repairBillTableview.reloadData()
                    self.repairBillTableview.mj_header.endRefreshing()
                    self.repairBillTableview.mj_footer.endRefreshing()

                    self.heatingBillTableview.reloadData()
                    self.heatingBillTableview.mj_header.endRefreshing()
                    self.heatingBillTableview.mj_footer.endRefreshing()


                }


            }, failture: { (error) in



            })

        }
        
    }
    
    
    //MARK: - SEGMENT
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["维修账单", "供暖账单"][index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        
        return 2
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        return [repairBillTableview,heatingBillTableview][index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        
        
        if segmentedPager.pager.indexForSelectedPage == 0 {
            
            if !(self.repairBillArr.count > 0){
                
                self.getDataWith(page: 1, type: 1000)
            }
            
        }else if segmentedPager.pager.indexForSelectedPage == 1 {
            
            if !(self.heatingBillArr.count > 0){
                
                self.getDataWith(page: 1, type: 2000)
            }
            
        }
        
    }
    
    // MARK: - TableView Delegate  DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (tableView.tag){
            
        case 1000 :
            return self.repairBillArr.count
        case 2000 :
            return self.heatingBillArr.count
            
        default :
            break
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : myBillListCell = tableView.dequeueReusableCell(withIdentifier: myBillListCell_id, for: indexPath) as! myBillListCell
        
        var model = myBillListReturnObjModel()
        
        if tableView.tag == 1000 {
            
            model = self.repairBillArr[indexPath.row]
            
        } else if tableView.tag == 2000 {
            
            model = self.heatingBillArr[indexPath.row]
            
        }
    
        if  model.state == 9 {
            
            cell.payTypeL.isHidden = true
            cell.payBtn.isHidden = false
        }else{
            
            cell.payTypeL.text = model.method ?? ""
            cell.payTypeL.isHidden = false
            cell.payBtn.isHidden = true

        }
        
        
        cell.moneyL.text = "¥" + (model.payMoney ?? "")
        cell.dealTimeL.text = self.timeStampToString(timeStamp: model.payDate ?? "")
        
        if tableView.tag == 1000 {
            
            cell.payTimeL.text = model.workno ?? ""
            
            cell.goodsL.isHidden = true
            cell.goodsTitleL.isHidden = true
            cell.goodsTitleL.snp.updateConstraints { (make) in
                
                make.height.equalTo(0)
            }
            cell.goodTitleTopH.constant = 0

        }else{
            
            cell.goodsL.text = model.name ?? ""
            cell.payTimeL.text = model.orderNo ?? ""

            
        }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.tag == 1000 ? 140 : 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWith(page: 1, type: pullTableView.tag)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        let page = pullTableView.tag == 1000 ? self.repairBillPage : self.heatingBillPage
        
        self.getDataWith(page: page + 1, type: pullTableView.tag)
        
    }
    
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="YYYY-MM-dd HH:mm:ss"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
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
