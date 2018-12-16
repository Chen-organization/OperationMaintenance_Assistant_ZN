//
//  MeterReadingVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/13.
//  Copyright © 2018年 Chen. All rights reserved.
//

//----------   抄表  ---------  

import UIKit

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
    }
    
    
    func meterReading() {
        
        
        let meterReading = UIStoryboard(name: "MeterReading", bundle: nil)
            .instantiateViewController(withIdentifier: "readingVC") as! readingVC
        self.navigationController?.pushViewController(meterReading, animated: true)
        
    }
    func downloadMeterDic() {
        
        let dic = {
            
        }
        
//        NetworkService.networkPostrequest(currentView: self.view, parameters: <#T##[String : Any]#>, requestApi: <#T##String#>, modelClass: <#T##String#>, response: <#T##(AnyObject) -> ()#>, failture: <#T##(NSError) -> ()#>)
        
        
    }
    func UploadeMeterDic() {
        
        
        
        
    }
    func ChangeMeter() {
        
        
        
        
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
