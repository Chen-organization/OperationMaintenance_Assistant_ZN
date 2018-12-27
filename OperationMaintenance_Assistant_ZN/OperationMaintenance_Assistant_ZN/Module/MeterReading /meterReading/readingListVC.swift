//
//  readingListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 Chen. All rights reserved.
//

import UIKit

class readingListVC: UITableViewController,readinglistCellDelegate {
    
    
    var nowPage = 1

    var dataArray = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "记录"
        
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.register(UINib.init(nibName: "readinglistCell", bundle: nil), forCellReuseIdentifier: readinglistCell_id)
        
        edgesForExtendedLayout = []
        

        
        self.tableView.es.addPullToRefresh {
            
//            [unowned self] in
            
            self.getdata(page: 1)
        }
        
//        self.tableView.es.addInfiniteScrolling {
//            [unowned self] in
//
//            self.getdata(page: self.nowPage + 1)
//
//        }

        self.getdata(page: 1)
    }
    
    
    func getdata(page:Int) {
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = ["empId": model.empNo,
                        "code": "2",
                        "start":page.description,
                        "ord": "20",
                        ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDisplayUrl, modelClass: "readingListModel", response: { (obj) in
                
                let model : readingListModel = obj as! readingListModel
                
                if model.statusCode == 800 {
                    
                    self.nowPage = page
                    
                    self.dataArray = model.returnObj ?? [Any]()
                    
                    self.tableView.reloadData()
                    
                    
                }
                
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()

                
            }, failture: { (error) in
                
                self.tableView.es.stopPullToRefresh()

                
            })
            
            
            
        }
        
    }
    
    
    //MAKR: - tableview
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
        if section==0 {
            return self.dataArray.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:readinglistCell
                = tableView.dequeueReusableCell(withIdentifier:readinglistCell_id, for: indexPath) as! readinglistCell
            
//            let model : readingListModel = self.dataArray[indexPath.row] as! readingListModel
            
            cell.index = indexPath.row
            
            cell.cellDelegate = self
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    //cell的缩进级别,动态静态cell必须重写,否则会造成崩溃
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        if(0 == indexPath.section){
            // (动态cell)
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    
    // MARK: - cell Delegate

    func cellDeleteWithIndex(index: Int) {
        
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
