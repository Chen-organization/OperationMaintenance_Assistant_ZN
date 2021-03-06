//
//  readingListVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 Chen. All rights reserved.
//

import UIKit

@objc protocol readingListVCDelegate{
    
    func deleteRefresh()
    
}

class readingListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,readinglistCellDelegate,PullTableViewDelegate {
    
    weak var  Delegate: readingListVCDelegate?

    
    var tableView : BasePullTableView!
    
    var nowpage = 1

//    var lastNum = 1

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


        self.tableView.mj_header.beginRefreshing()
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        self.getdata(num: 1)

    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        self.getdata(num: self.nowpage + 1)
        
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
                    
                    
                    self.nowpage = num;
                    
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
//            var canDelete = false
        
            
            let num = RealmTool.getMetersReadingData().count
//            if num > 0 {
        
                if indexPath.row < num{
                    
                    let model : writeMeterModel = RealmTool.getMetersReadingData()[indexPath.row]
                    
                    
                    name = model.deviceName ?? ""
//                    meterNum = model.value ?? ""
                    time = self.timeStampToString(timeStamp: model.time ?? "")
                    meterNum = String(format:"%.2f",Double(model.value ?? "0") ?? 0)
                    
                    cell.setTitleColor(isLocal: true)
                    cell.setCanDelete(CanDelete: true)
                    
                }else{
                    
                    let model : readingListReturnObjModel = self.dataArray[indexPath.row - num]

                    orderNum = (indexPath.row - num + 1).description
                    name = model.deviceHisId ?? ""
//                    meterNum = model.nowValue ?? ""
                    meterNum = String(format:"%.2f",Double(model.nowValue ?? "0") ?? 0)

                    time = self.timeStampToString(timeStamp:model.createDate ?? "")
                    
                    //判断时间 一小时内能修改
                    var candelete = false
                    
//                    let betowen = Int(self.milliStamp)! - Int(model.createDate!)!
                    
                    if Int(self.NowHourMilliStamp)! >= Int(model.createDate!)! {

                        candelete = false
                    }else{
                        
                        if indexPath.row == num {
                            
                            candelete = true

                        }else{
                            
                            candelete = false

                        }
                        
                        
                    }
                    
                    cell.setTitleColor(isLocal: false)
                    cell.setCanDelete(CanDelete: candelete)
                    
                    
                    
                }
//            }else{
//
//
//                let model : readingListReturnObjModel = self.dataArray[indexPath.row]
//
//                orderNum = (indexPath.row - num).description
//                name = model.deviceHisId ?? ""
//                meterNum = model.nowValue ?? ""
//                time = self.timeStampToString(timeStamp:model.createDate ?? "")
//
//
//                //判断时间 一小时内能修改
//                var candelete = false
//
//                let betowen = Int(self.milliStamp)! - Int(model.createDate!)!
//
//                if betowen/1000 >= 24 * 60 * 60 {
//
//                    candelete = false
//                }else{
//
//                    candelete = true
//                }
//
//                cell.setTitleColor(isLocal: false)
//                cell.setCanDelete(CanDelete: candelete)
//
//            }
        
            cell.NoL.text = orderNum
            cell.nameL.text = name
            cell.value0.text = meterNum
            cell.value1.text = time

            
            cell.index = indexPath.row
            cell.cellDelegate = self
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    // MARK: - cell Delegate  抄表删除数据
    
    func cellDeleteWithImgIndex(index: Int) {
        
        let localNum = RealmTool.getMetersReadingData().count

        
        if index >= localNum {
            
            //线上过得记录
            
            let model = self.dataArray[index - localNum] as? readingListReturnObjModel
            
            if let url = model?.photoUrl{
                
                //查看
                PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                    
                    let pbModel = PhotoModel()
                    pbModel.mid = 1
                    pbModel.image_HD_U = url
                    
                    return [pbModel]
                }
                
            }else{
                
                //查看
                PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                    
                    let pbModel = PhotoModel()
                    pbModel.mid = 1
                    pbModel.image = UIImage.init(named: "站位图")
                    
                    return [pbModel]
                }
            }
            
        }else{
            
            //本地
            let meterArr = RealmTool.getMetersReadingData()
            
            if let m : writeMeterModel = meterArr[index] as? writeMeterModel{
                
                if m.file?.characters.count ?? 0 > 0 {
                    
                    let imageData = Data(base64Encoded: m.file ?? "")
                    
                    
                    //查看
                    PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                        
                        let pbModel = PhotoModel()
                        pbModel.mid = 1
                        pbModel.image = UIImage(data: imageData!)
                        
                        return [pbModel]
                    }
                }else{
                    
                    //查看
                    PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                        
                        let pbModel = PhotoModel()
                        pbModel.mid = 1
                        pbModel.image = UIImage.init(named: "站位图")
                        
                        return [pbModel]
                    }
                    
                }
                
                
                
                
            }
        }
        
    }

    func cellDeleteWithIndex(index: Int) {
    
        UserCenter.shared.userInfo { (islogin, model) in
            
    
            var para = [
                
                "companyCode":model.companyCode,
                "orgCode":model.orgCode,
                "empId":model.empNo,
                "empName":model.empName,
                ]
            
            
            let localNum = RealmTool.getMetersReadingData().count
            
            if localNum > 0 {
                
                if index < localNum {
                    
                    
                    
                    ZNCustomAlertView.handleTip("是否确定删除此条抄表记录！", isShowCancelBtn: true) { (issure) in
                        
                        if issure{
                            
                            //本地删除
                            RealmTool.deleteMetersReadingData(model: RealmTool.getMetersReadingData()[index])
                            
                            self.tableView.reloadData()
                            
                            self.Delegate?.deleteRefresh()
                        }
                        
                    }
               
                    return
                    
                }else{
                    
                    let model:readingListReturnObjModel = self.dataArray[index + localNum] as! readingListReturnObjModel
                    
                    para["id"] = model.id
                    
                    
                }
                
            }else{
                
                let model:readingListReturnObjModel = self.dataArray[index] as! readingListReturnObjModel
                
                para["id"] = model.id
                
                
            }
            
            
            
            
            ZNCustomAlertView.handleTip("是否确定删除此条抄表记录！", isShowCancelBtn: true) { (issure) in
                
                YJProgressHUD.hide()

                if issure{
                    
                    
                    
                    YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
                    
                    NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeleteUrl, modelClass: "BaseModel", response: { (obj) in
                        
                        let model : BaseModel = obj as! BaseModel
                        
                        if model.statusCode == 800 {
                            
                            self.getdata(num: 1)
                            
                            self.tableView.reloadData()
                            
                            DispatchQueue.main.after(0.3) {
                                
                                ZNCustomAlertView.handleTip("数据删除成功", isShowCancelBtn: false, completion: { (issure) in
                                    
                                })
                            }
                            self.Delegate?.deleteRefresh()

                            
                        }else{
                            
                            DispatchQueue.main.after(0.3) {

                                ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (issure) in

                                })
                            }
                            
                        }
//                        else if model.statusCode == 900 {
//
//                            DispatchQueue.main.after(0.3) {
//
//                                ZNCustomAlertView.handleTip("删除失败，请刷新数据检查此条记录能否被删除！", isShowCancelBtn: false, completion: { (issure) in
//
//                                })
//                            }
//                        }else{
//
//                            DispatchQueue.main.after(0.3) {
//
//                                ZNCustomAlertView.handleTip("删除失败", isShowCancelBtn: false, completion: { (issure) in
//
//                                })
//                            }
//                        }
                        
                        YJProgressHUD.hide()

                    }, failture: { (error) in
                        
                        
                        YJProgressHUD.hide()
                        
                    })
                    
                    
                    
                    
                }
                
            }
            
            
          
          
            
            
            
        }
    
  
   
    }
    
    /// 获取当前整点 毫秒级 时间戳 - 13位
    var NowHourMilliStamp : String {
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        
        let hourDate = timeFormatter.date(from: strNowTime)
        
        let timeInterval: TimeInterval = (hourDate?.timeIntervalSince1970)!
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="MM-dd HH:mm:ss"
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
