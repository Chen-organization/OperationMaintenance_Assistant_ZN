//
//  MeterReadingVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/13.
//  Copyright © 2018年 Chen. All rights reserved.
//

//----------   抄表  ---------  

import UIKit
import RealmSwift 
import Alamofire

class MeterReadingVC: UITableViewController {
    
    
    var deleteTimeArr = [String]()

    var uploadNum = 0
    
    
    
    @IBOutlet weak var uploadTitleL: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "抄表"

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let result =  RealmTool.getMetersReadingData()
        self.uploadTitleL.text = "上传离线数据" + "（" + result.count.description + "）"
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.section {
        case 0:
            self.meterReading()
        case 1:
            self.downloadMeterDic()
        case 2:
            self.UploadeMeterDic()
        case 3:
            self.ChangeMeter()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func meterReading() {
        
        
        let meterReading = UIStoryboard(name: "MeterReading", bundle: nil)
            .instantiateViewController(withIdentifier: "readingVC") as! readingVC
        self.navigationController?.pushViewController(meterReading, animated: true)
        
    }
    func downloadMeterDic() {
        
        self.downloadMeterDicNetworkMethod()
     
    }
    func UploadeMeterDic() {
        
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            
            let result =  RealmTool.getMetersReadingData()
            
            if result.count > 0{
                
                YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)

            }
            
         
            
            for model:writeMeterModel  in result {
                
                
                    UserCenter.shared.userInfo { (islogin, userModel) in
                    
                            var para = ["companyCode": userModel.orgCode ?? "",
                                "orgCode": userModel.orgCode ?? "",
                                "empId": userModel.empNo ?? "",
                                "empName": userModel.empName  ?? "",
                                "id": model.id ?? "",
                                "value": model.value ?? "",
                                "org": "002002",
                                "status": "1",
                               
                                ]
                        
                        para["time"] = model.time ?? ""
                        
                        para["remark"] = model.remark ?? ""
                        para["isMoreThanMax"] = "0"
                        para["thresholdMax"] = model.thresholdMax ?? ""
                        para["file"] = model.file ?? ""
                        para["file2"] = model.file2  ?? ""
                        
//                            if let file = model.file {
                        
                        
//                            }
//                            if let file2 = model.file2 {
                                
                        
//                            }
                        
                            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getSubmitUrl, modelClass: "BaseModel", response: { (obj) in
                                
                                let m :BaseModel = obj as! BaseModel
                                if m.statusCode == 800 {
                                    
                                    
                                        //清空本次提交数据
//                                        RealmTool.deleteMetersReadingData(model: model)
                                
//                                    RealmTool.deleteMeterReadingDataWithTime(time: model.time ?? "")
                                    
                                    self.deleteTimeArr.append(para["time"] ?? "")
                                   
                                
                                }else{
                                    
                                
                                }
                                
                                self.uploadNum += 1
                                self.setUploadResult()
                                
                                
                            }, failture: { (error) in
                                
                                self.uploadNum += 1
                                self.setUploadResult()

                                
                            })
                    }
            }
            
            
        }else{
            
            ZNCustomAlertView.handleTip("暂无网络数据", isShowCancelBtn: false) { (issure) in
                
                
            }
            
        }
        
                
        
    }
    
    
    func setUploadResult() {
        
        if self.uploadNum == RealmTool.getMetersReadingData().count {
            
            YJProgressHUD.hide()

            if self.deleteTimeArr.count > 0 {
                
                
                for time in deleteTimeArr{
                    
                    RealmTool.deleteMeterReadingDataWithTime(time: time )
                    
                }
                
                let results =  RealmTool.getMetersReadingData()
                self.uploadTitleL.text = "上传离线数据" + "（" + results.count.description + "）"
                
                if results.count > 0 {
                    
                    ZNCustomAlertView.handleTip("离线数据部分上传成功", isShowCancelBtn: false) { (issure) in
                        
                    }
                }else{
                    
                    ZNCustomAlertView.handleTip("离线数据上传成功", isShowCancelBtn: false) { (issure) in
                        
                    }
                    
                }
                
                
            }
            
        }
        
    
        
    }
    
    
    func ChangeMeter() {
        
        let vc = UIStoryboard(name: "changeMeterVC", bundle: nil)
            .instantiateViewController(withIdentifier: "changeMeterVC") as! changeMeterVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func downloadMeterDicNetworkMethod() {
        
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            
            let dic = [
                
                "companyCode":userModel.companyCode,
                "orgCode":userModel.orgCode,
                "empNo":userModel.empNo,
                "empName":userModel.empName,
                
            ]
            
            YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: dic as [String : Any], requestApi: getDatesUrl, modelClass:"DownloadMeterDicModel", response: { (object) in
                
                let model = object as! DownloadMeterDicModel
                
                if ( model.statusCode == 800 && (model.returnObj?.count)! > 0){
                    
                    RealmTool.insertMetersDic(by: model.returnObj!)
                    
                    MBProgressHUD.show(withOnlyMessage: "数据更新成功", delayTime: 2.5)
                    
                }
            
                YJProgressHUD.hide()
                
            }, failture: { (error) in
                
                YJProgressHUD.hide()

            })
            
            
        }
        
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


class RealmTool: Object {
    private class func getDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        
        print(dbPath )
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }
    
    
    private class func getWriteDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/writeDB.realm")
        
        print(dbPath )
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }
}



/// 保存字典表
extension RealmTool {

    /// 保存字典表
    public class func insertMetersDic(by meters : [DownloadMeterDicReturnObjModel]) -> Void {
        let defaultRealm = self.getDB()

        try! defaultRealm.write {
            
            let res = defaultRealm.objects(DownloadMeterDicReturnObjModel.self)
            defaultRealm.delete(res)
            
            defaultRealm.add(meters)
        }
    }
    
    /// 查询字典表
    public class func getMetersDic() -> (Results<DownloadMeterDicReturnObjModel>) {
        let defaultRealm = self.getDB()
        
//        try! defaultRealm.write {
        
        return defaultRealm.objects(DownloadMeterDicReturnObjModel.self)

//        }
    }
    
    /// 查询本地单个设备数据
    public class func getOneMetersDic(meterNo:String) -> ([DownloadMeterDicReturnObjModel]) {
        let defaultRealm = self.getDB()
        
        //        try! defaultRealm.write {

        return [(defaultRealm.object(ofType: DownloadMeterDicReturnObjModel.self, forPrimaryKey: meterNo) ?? nil)!]
        
        //        }
    }
    
    
        
    /// 保存抄表数据
    public class func insertMetersReadingData(by meter : [writeMeterModel]) -> Void {
        let defaultRealm = self.getWriteDB()
        
        try! defaultRealm.write {
            
            defaultRealm.add(meter)
        }
    }
    
    /// 查询抄表数据
    public class func getMetersReadingData() -> (Results<writeMeterModel>) {
        let defaultRealm = self.getWriteDB()
        
        return defaultRealm.objects(writeMeterModel.self)
        
    }

    /// 操作抄表数据 删除
    public class func deleteMetersReadingData(model:writeMeterModel){
        let defaultRealm = self.getWriteDB()
        
        try! defaultRealm.write {
            
            defaultRealm.delete(model)
            
        }
        
    }
    
    /// 操作抄表数据 查找
    public class func getOneMeterReadingDataWithNo(meterNo:String) -> ([writeMeterModel]) {
        let defaultRealm = self.getWriteDB()
        
        //        try! defaultRealm.write {
        
        let result = defaultRealm.objects(writeMeterModel.self).filter("id = %@", meterNo)
        
        var arr = [Any]()
        
        for model in result {
            
            arr.append(model)
            
        }
        
        return arr as! ([writeMeterModel])
        
//        return [(defaultRealm.object(ofType: writeMeterModel.self, forPrimaryKey: meterNo) ?? nil)!]
        
        //        }
    }
    
    /// 操作抄表数据 按条件 删除
    public class func deleteMeterReadingDataWithTime(time:String){
        let defaultRealm = self.getWriteDB()
        
        let results = defaultRealm.objects(writeMeterModel.self).filter("time = %@", time)
        
        if let a = results.first {
            //删除单条数据
            try! defaultRealm.write {
                
                defaultRealm.delete(a) // 删除单个数据
                
            }
        }
        
     

        
        
    }

    
}
