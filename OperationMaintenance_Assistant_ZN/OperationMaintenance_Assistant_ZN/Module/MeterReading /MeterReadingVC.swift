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


class MeterReadingVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "抄表"

        
        // Do any additional setup after loading the view.
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
        
        
        
        
    }
    func ChangeMeter() {
        
        
        
        
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
    
  

}
