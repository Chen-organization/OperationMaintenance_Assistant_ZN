//
//  MoreHeadLinesVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2018/12/29.
//  Copyright © 2018 Chen. All rights reserved.
//

import UIKit

class MoreHeadLinesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {

    var tableview : BasePullTableView!
    
    var headLinesData = [TheHeadlinesReturnObjModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "运维头条"
        
        self.tableview = BasePullTableView()
        self.view.addSubview(self.tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.pullDelegate = self
        self.tableview.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
            
        }

        
        self.tableview.register(UINib.init(nibName: "HomeNewCell", bundle:Bundle.main ), forCellReuseIdentifier: HomeNewCell_id)
        
        self.getDataWithStart(start: 1)
        
        self.tableview.mj_footer.ignoredScrollViewContentInsetBottom = is_X_XS_max ? 34 : 0;


}

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.headLinesData.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HomeNewCell = tableView.dequeueReusableCell(withIdentifier: HomeNewCell_id, for: indexPath) as! HomeNewCell
        
        let model : TheHeadlinesReturnObjModel = self.headLinesData[indexPath.row] as? TheHeadlinesReturnObjModel ?? TheHeadlinesReturnObjModel()
    
        if let url = model.imgUrl {
            
            cell.img.kf.setImage(with: URL.init(string: url))
            
        }
        cell.titleL.text = model.title ?? ""
        cell.contentL.text = model.knowledgeDesc ?? ""
        cell.timeL.text = self.timeStampToString(timeStamp: model.createDate ?? "")
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model : TheHeadlinesReturnObjModel = self.headLinesData[indexPath.row] as? TheHeadlinesReturnObjModel ?? TheHeadlinesReturnObjModel()

        let vc = headerLinesDetailVC()
        vc.url = model.h5Url ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getDataWithStart(start: 1)
        
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        self.getDataWithStart(start: self.headLinesData.count + 1)

    }
    
    
    //MARK : - 获取数据
    
    func getDataWithStart(start:Int) {
        
        
        let para = ["start": start.description,
                    "end": "20",
                    ]
        
        NetworkService.networkGetrequest(currentView: self.view, parameters: para, requestApi: getTheHeadlinesUrl, modelClass: "TheHeadlinesModel", response: { (obj) in
            
            let model : TheHeadlinesModel = obj as! TheHeadlinesModel
            
            if model.statusCode == 800 {
                
                
                if start == 1{
                    
                    self.headLinesData.removeAll()
                    self.headLinesData = model.returnObj ?? []
                    
                }else{
                    
                    self.headLinesData += model.returnObj as! [TheHeadlinesReturnObjModel]
                
                }
                self.tableview.reloadData()
                
                self.tableview.mj_header.endRefreshing()
                self.tableview.mj_footer.endRefreshing()

            }
            
        }) { (error) in
            
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
  
}
