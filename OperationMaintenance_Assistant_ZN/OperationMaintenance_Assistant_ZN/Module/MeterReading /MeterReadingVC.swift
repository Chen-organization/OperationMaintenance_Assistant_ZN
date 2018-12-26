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
                
                MBProgressHUD.show(withModifyStyleMessage: "", to: self.view)

            }
            
            let queue = DispatchQueue.init(label: "getCount")//定义队列
            let group = DispatchGroup()//创建一个组
            
            
            
            for model in result {
                
                //将队列放进组里
                queue.async(group: group, execute: {
                    group.enter()//开始线程1
                    
                    UserCenter.shared.userInfo { (islogin, userModel) in
                    
                            //MARK: - ！！！！ 添加经纬度 ！！！！！！！！！！！！！！！
                            var para = [
                                
                                "companyCode": userModel.orgCode ?? "",
                                "orgCode": userModel.orgCode ?? "",
                                "empId": userModel.empNo ?? "",
                                "empName": userModel.empName  ?? "",
                                "id": model.id ?? "",
                                "value": model.value,
                                "org": "002002",
                                "longitude": "",
                                "latitude": "",
                                "status": "1",
                                "time" : time,
                                "remark": model.remark ?? "",
                                "isMoreThanMax": "0",
                                "thresholdMax": model.thresholdMax ?? "",
                                ] as [String : Any]
                        
                            if let file = model.file {
                                
                                para["file"] = file
                                
                            }
                            if let file2 = model.file2 {
                                
                                para["file2"] = file2
                                
                            }
                        
                            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getSubmitUrl, modelClass: "BaseModel", response: { (obj) in
                                
                                let m :BaseModel = obj as! BaseModel
                                if m.statusCode == 800 {
                                    
                                    //清空页面本次提交数据
                                    RealmTool.deleteMetersReadingData(model: model)
                                 
                                }else{
                                    
                                
                                }
                                
                                group.leave()//线程结束
                                
                            }, failture: { (error) in
                                
                                
                                
                            })
                    }
                })
            }
            
            
            
            group.notify(queue: queue){
                //队列中线程全部结束
                print("end")
                
                DispatchQueue.main.async {
                    
                    let result =  RealmTool.getMetersReadingData()
                    self.uploadTitleL.text = "上传离线数据" + "（" + result.count.description + "）"
                    
                    MBProgressHUD.hide(for: self.view)
                    
                }
            }
            
            
        }else{
            
            ZNCustomAlertView.handleTip("暂无网络数据", isShowCancelBtn: false) { (issure) in
                
                
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
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: dic as [String : Any], requestApi: getDatesUrl, modelClass:"DownloadMeterDicModel", response: { (object) in
                
                let model = object as! DownloadMeterDicModel
                
                if ( model.statusCode == 800 && (model.returnObj?.count)! > 0){
                    
                    RealmTool.insertMetersDic(by: model.returnObj!)
                    
                    MBProgressHUD .showText("下载成功")
                    
                }
            
                
            }, failture: { (error) in
                
                
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
        
        defaultRealm.delete(model)
        
    }

}
