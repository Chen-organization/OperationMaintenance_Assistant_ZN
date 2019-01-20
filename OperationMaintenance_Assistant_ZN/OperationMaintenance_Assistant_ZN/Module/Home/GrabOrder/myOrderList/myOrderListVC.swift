//
//  myOrderListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/15.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class myOrderListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate ,myGrabOrderListCellDelegate{

    

    var nowPage = 1
    
    var repairTableview = BasePullTableView()
    var repairArr = [GrabOrderListReturnObjModel]()
    
    
    var cancelReasonArray = [cancelReasonReturnObjModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "我的抢单"
        
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
        
        self.repairTableview.register(UINib.init(nibName: "myGrabOrderListCell", bundle: nil), forCellReuseIdentifier: myGrabOrderListCell_id)
        
        self.getData(page: 1)

    }
    
    
    func getData(page:Int) {
        
        
                UserCenter.shared.userInfo { (islogin, model) in
        
                    let para = [
        
                        "companyCode":model.companyCode,
                        "orgCode" : model.orgCode,
                        "empNo": model.empNo,
                        "empName": model.empName,
                        "start":self.nowPage.description,
                        "ord": "10",
                        ]
        
                    NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getMyGrabListUrl, modelClass: "GrabOrderListModel", response: { (obj) in
        
                        let model : GrabOrderListModel = obj as! GrabOrderListModel
                        
                        if model.statusCode == 800 {
                            
                            self.nowPage = page
                            
                            if page == 1 {
                                
                                    self.repairArr = model.returnObj ?? []
                                    
                            }else{
                             
                                    self.repairArr += model.returnObj ?? []
                                
                            }
                            
                            self.repairTableview.configBlankPage(EaseBlankPageType.view, hasData: self.repairArr.count > 0, hasError: false, reloadButtonBlock: { (a) in
                                
                            })
                            
                            self.nowPage = page
                            
                            self.repairTableview.reloadData()
                            self.repairTableview.mj_header.endRefreshing()
                            self.repairTableview.mj_footer.endRefreshing()
                            
                        }
        
                    }, failture: { (error) in
        
                        self.repairTableview.mj_header.endRefreshing()
                        self.repairTableview.mj_footer.endRefreshing()
        
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
        
        let cell : myGrabOrderListCell = tableView.dequeueReusableCell(withIdentifier: myGrabOrderListCell_id, for: indexPath) as! myGrabOrderListCell
        
        var model = GrabOrderListReturnObjModel()
        model = self.repairArr[indexPath.row]
        
        cell.titleL.text = (model.type ?? "") + "|" + (model.category ?? "")
        cell.dateL.text = self.timeStampToString(timeStamp:(model.repairTime ?? "") )
        cell.grabDateL.text = self.timeStampToString(timeStamp: (model.grabTime ?? ""))
        cell.orderNoL.text = model.workNo ?? ""
        cell.nameL.text = model.contacts ?? ""
        cell.telL.text = model.contactNumber ?? ""
        cell.addressL.text = model.address ?? ""


        
        if let distance = model.distance{
            
            cell.distanceL.text = String(format:"%.1f", (Double(distance) ?? 0 )/1000) + "km"
            
        }else{
            
            cell.distanceL.text = "0.0km"
            
        }
        
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = orderDetailVC.getOrderDetailVC()
        
        var model : GrabOrderListReturnObjModel = GrabOrderListReturnObjModel()
        
        model = self.repairArr[indexPath.row]
        vc.repairType = orderDetailType.repair
        
        vc.orderNo = model.workNo ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getData(page: 1)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        self.getData(page: self.nowPage + 1)
        
    }
    
    
    //MARK: - cell 代理
    
    func deleteOrder(cellIndex: Int) {
        
        
        YJProgressHUD.showProgress("", in: UIApplication.shared.keyWindow)
        
        //取消原因
        NetworkService.networkPostrequest(currentView: self.view, parameters: [String : Any]() , requestApi: getCancelOrdersURL, modelClass:"cancelReasonModel", response: { (obj) in
            
            let model : cancelReasonModel = obj as! cancelReasonModel
            
            if model.statusCode == 800 {
                
                self.cancelReasonArray = model.returnObj ?? []
                
                var str = ""
                
                for  m : cancelReasonReturnObjModel in model.returnObj ?? []{
                    
                    if str.characters.count > 0{
                        
                        str = str + ","
                    }
                    
                    str = str + (m.name ?? "")

                    
                }

                
                ZNCancelOrderReasonView.handleTip(str, isShowCancelBtn: true, completion: { (sure, index) in

                    if sure {
                        
                        let model : cancelReasonReturnObjModel  = self.cancelReasonArray[NSInteger(index)]
                        
                        self.cancelOrderMethod(reason: model.id ?? "", orderIndex: cellIndex)

                    }

                })
              
            }
            
            YJProgressHUD.hide()
            
        }, failture: { (error) in
        
            YJProgressHUD.hide()

        })
        
        
        
    }
    
    func cancelOrderMethod(reason:String , orderIndex : Int) {
        
        YJProgressHUD.showProgress("", in: UIApplication.shared.keyWindow)

        
        let m : GrabOrderListReturnObjModel = self.repairArr[orderIndex]
        
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = ["code": "3",
                        "id":m.workNo,
                        "companyCode":model.companyCode,
                        "empId":model.empNo,
                        "empName":model.empName,
                        "orgCode":model.orgCode,
                        "make":reason
                        ]
            
         
            NetworkService.networkPostrequest(currentView: self.view, parameters:para as [String : Any] , requestApi: getDetailsUrl, modelClass: "BaseModel", response: { (obj) in
                
                let model : BaseModel = obj as! BaseModel
                

                
                ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (sure) in
                    
                    if model.statusCode == 800 {
                        
                        self.repairArr.remove(at: orderIndex)
                        self.repairTableview.reloadData()
                        
                    }
                })
                
                
                YJProgressHUD.hide()
                
            }, failture: { (error) in
                
                YJProgressHUD.hide()
                
            })
            
            
        }
        
     
        
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
