//
//  changeMeterVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/18.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

class changeMeterVC: UITableViewController {
    
    
    @IBOutlet weak var meterNoTextField: UITextField!
    
    @IBOutlet weak var meterNameL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    
    @IBOutlet weak var oldMeterNum: UITextField!
    @IBOutlet weak var newMeterNum: UITextField!
    
    @IBOutlet weak var typeSelectContentView: UIView!
    @IBOutlet weak var remarkTextView: UITextView!
    
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    
    @IBOutlet weak var firstDeleteBtn: UIButton!
    @IBOutlet weak var secondDeleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //设备更换原因 获取
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode": UserCenter.companyCode,
                "orgCode": UserCenter.orgCode,
                "empNo": UserCenter.empNo,
                "empName": userModel.empName,
                "code": "2",
                "deviceNo": self.meterNoTextField.text,
            ]
            
            NetworkService.networkGetrequest(currentView: self.view, parameters: para, requestApi: getDatesUrl, modelClass: "", response: { (obj) in
            
            }, failture: { (error) in
                
                
                
            })
        }
        
      
        self.firstDeleteBtn.isHidden = true
        self.secondDeleteBtn.isHidden = true
        

        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    //MARK: - 控制器 方法
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
//            let para = [
//
//                "companyCode": UserCenter.companyCode,
//                "orgCode": UserCenter.orgCode,
//                "empNo": UserCenter.empNo,
//                "code": "1",
//                "deviceNo": ,
//                "oldGauge": ,
//                "newGauge": ,
//                "remain": ,
//                "remarks": ,
//                "reason": ,
//                "oldFile": ,
//                "newFile": ,
//
//                ]
//
//            NetworkService.networkPostrequest(currentView: self.view, parameters: <#T##[String : Any]#>, requestApi: <#T##String#>, modelClass: <#T##String#>, response: <#T##(AnyObject) -> ()#>, failture: <#T##(NSError) -> ()#>)
            
            
        }
        
        
      
    }
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
