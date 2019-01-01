//
//  readingListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 Chen. All rights reserved.
//

import UIKit

class readingListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,readinglistCellDelegate,PullTableViewDelegate {
    
    var tableView : BasePullTableView!

    var lastNum = 1

    var dataArray = [readingListReturnObjModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "记录"
        
        self.tableView = BasePullTableView()
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.pullDelegate = self
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
            
        }
        self.tableView.backgroundColor = UIColor.white
        

        
        let view = UIView()
        view.height = 40
        
        let header = readingListHeaderView().loadXib()
        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            
            make.edges.equalTo(view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        self.tableView.tableHeaderView = view
        self.tableView.tableHeaderView?.height = 40
        
        
        self.tableView.register(UINib.init(nibName: "readinglistCell", bundle: nil), forCellReuseIdentifier: readinglistCell_id)
        
        edgesForExtendedLayout = []
        
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = is_X_XS_max ? 34 : 0;


        self.getdata(num: 1)
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getdata(num: 1)

    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        self.getdata(num: self.dataArray.count)
        
    }
    
    
    func getdata(num:Int) {
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = [
                
                "companyCode":model.companyCode,
                "orgCode" : model.orgCode,
                        "empId": model.empNo,
                        "empName": model.empName,
                        "start":num.description,
                        "ord": "20",
                        ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getRecordUrl, modelClass: "readingListModel", response: { (obj) in
                
                let model : readingListModel = obj as! readingListModel
                
                if model.statusCode == 800 {
                    
                    if num == 1 {
                        
                        self.dataArray = model.returnObj ?? []

                    }else{
                        
                        if let arr = model.returnObj{
                            
                            self.dataArray += arr

                        }
                    }
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                    
                }
                
              

                
            }, failture: { (error) in
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
            })
            
            
            
        }
        
    }
    
    
    //MAKR: - tableview
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            if RealmTool.getMetersReadingData().count > 0 {
                
                return RealmTool.getMetersReadingData().count + self.dataArray.count
            }
            
            return self.dataArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell:readinglistCell
                = tableView.dequeueReusableCell(withIdentifier:readinglistCell_id, for: indexPath) as! readinglistCell
            
            var orderNum = ""
            var name = ""
            var meterNum = ""
            var time = ""
            var canDelete = false
            
            
            let num = RealmTool.getMetersReadingData().count
            if num > 0 {
                
                if indexPath.row < num{
                    
                    let model : writeMeterModel = RealmTool.getMetersReadingData()[indexPath.row]
                    
                    
                    name = model.deviceName ?? ""
                    meterNum = model.value ?? ""
                    time = self.timeStampToString(timeStamp: model.time ?? "")
                    canDelete = true
                    
                }else{
                    
                    let model : readingListReturnObjModel = self.dataArray[indexPath.row - num] as! readingListReturnObjModel

                    orderNum = (indexPath.row - num).description
                    name = model.deviceHisId ?? ""
                    meterNum = model.nowValue ?? ""
                    time = self.timeStampToString(timeStamp:model.createDate ?? "")
                    canDelete = false
                    
                }
            }else{
                
                
                let model : readingListReturnObjModel = self.dataArray[indexPath.row] as! readingListReturnObjModel
                
                orderNum = (indexPath.row - num).description
                name = model.deviceHisId ?? ""
                meterNum = model.nowValue ?? ""
                time = self.timeStampToString(timeStamp:model.createDate ?? "")
                canDelete = false
                
            }
            
            cell.NoL.text = orderNum
            cell.nameL.text = name
            cell.value0.text = meterNum
            cell.value1.text = time
            
            cell.setTitleColor(CanDelete: canDelete)
            
            cell.index = indexPath.row
            cell.cellDelegate = self
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    // MARK: - cell Delegate  抄表删除数据

    func cellDeleteWithIndex(index: Int) {
    
        UserCenter.shared.userInfo { (islogin, model) in
            
            
            var para = [ String : String]()
            
            let localNum = RealmTool.getMetersReadingData().count
            
            if localNum > 0 {
                
                if index < localNum {
                    
                    //本地删除
                    RealmTool.deleteMetersReadingData(model: RealmTool.getMetersReadingData()[index])
                    
                    self.tableView.reloadData()
                    return
                    
                }else{
                    
                    let model:readingListReturnObjModel = self.dataArray[index + localNum] as! readingListReturnObjModel
                    
                    para["id"] = model.id
                    
                }
                
            }else{
                
                let model:readingListReturnObjModel = self.dataArray[index] as! readingListReturnObjModel
                
                para["id"] = model.id
                
            }
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeleteUrl, modelClass: "BaseModel", response: { (obj) in
                
                let model : BaseModel = obj as! BaseModel
                
                if model.statusCode == 800{
                    
                    ZNCustomAlertView.handleTip("删除成功", isShowCancelBtn: false, completion: { (sure) in
                        
                    })
                    
                }else{
                    
                    ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (sure) in
                        
                    })
                    
                    self.tableView.reloadData()
                    
                }
                
            }) { (error) in
                
                
                
            }
            
            
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
            dfmatter.dateFormat="MM-dd HH:mm"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
