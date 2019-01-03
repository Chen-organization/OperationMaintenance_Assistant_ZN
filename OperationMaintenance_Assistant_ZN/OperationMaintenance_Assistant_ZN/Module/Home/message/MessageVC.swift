//
//  MessageVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    
    var tableview : BasePullTableView!
    
    var Datas = [myMessageReturnObjModel]()


    var nowPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "消息"
        
        self.tableview = BasePullTableView()
        self.view.addSubview(self.tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.pullDelegate = self
        self.tableview.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
            
        }
        self.tableview.rowHeight = UITableView.automaticDimension
        // 设置预估行高
        self.tableview.estimatedRowHeight = 90
        
      

        self.getMyMessage(page: 1)
        
        self.tableview.register(UINib.init(nibName: "myMessageCell", bundle:Bundle.main ), forCellReuseIdentifier: myMessageCell_id)

        
        self.tableview.mj_footer.ignoredScrollViewContentInsetBottom = is_X_XS_max ? 34 : 0;
        

    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.Datas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:myMessageCell = tableView.dequeueReusableCell(withIdentifier: myMessageCell_id, for: indexPath) as! myMessageCell
        
        let model : myMessageReturnObjModel = self.Datas[indexPath.row] as? myMessageReturnObjModel ?? myMessageReturnObjModel()
        
        cell.icon.image = model.status == "1" ? UIImage.init(named: "xiaoxi_red") : UIImage.init(named: "xiaoxi")
        cell.contentL.text = model.msgText
        cell.timel.text = self.timeStampToString(timeStamp: model.sendDate ?? "")
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model : myMessageReturnObjModel = self.Datas[indexPath.row] as? myMessageReturnObjModel ?? myMessageReturnObjModel()
        
        //MARK : - 已读
        self.MessageReaded(model: model)
      
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getMyMessage(page: 1)
        
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        self.getMyMessage(page: self.nowPage + 1)
        
    }
    
    //MARK : - 接口
    
    func MessageReaded(model:myMessageReturnObjModel) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode": userModel.companyCode,
                "orgCode": userModel.orgCode,
                "empId": userModel.empNo,
                "empName": userModel.empName,
                "code": "1",
                "id":model.msgId
            ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi:getMyMessageUrl, modelClass: "BaseModel", response: { (obj) in
                
                let m :BaseModel = obj as! BaseModel
                
                if m.statusCode == 800 {
                    
                    model.status = "0"
                    self.tableview.reloadData()

                }
              
                
            }, failture: { (error) in
                
                
            })
            
        }
        
    }
    
    
    
    func getMyMessage(page:Int) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                        
                        "companyCode": userModel.companyCode,
                        "orgCode": userModel.orgCode,
                        "empId": userModel.empNo,
                        "empName": userModel.empName,
                        "ord": "10",
                        "start": page.description,
                        "code": "0"

            ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi:getMyMessageUrl, modelClass: "myMessageModel", response: { (obj) in
                
                let model :myMessageModel = obj as! myMessageModel
                
                if let num = model.returnObj?.count {
                    
                    if num > 0 {

                        if page == 1 {
                            
                            self.nowPage = 1
                            
                            self.Datas = model.returnObj!
                            
                        }else{
                            
                            self.nowPage += 1
                            self.Datas += (model.returnObj)!

                        }
                        
                        
                      
                    }else{
                        
                    }
                }
                
                self.tableview.reloadData()
                
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
                
            }, failture: { (error) in
                
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()
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
            dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
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
