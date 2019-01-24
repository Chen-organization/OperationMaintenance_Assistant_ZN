//
//  PayVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/21.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire

class PayVC: UIViewController {
    
    
    var money = ""

    
    var orderNo = ""

    var scanUrl = ""   //账单进入 支付连接
    
    
    
    var timer = Timer.init()
    
    
    @IBOutlet weak var moneyL: UILabel!
    
    @IBOutlet weak var scanImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "二维码收款"
        
        self.view.backgroundColor = UIColor.init(red: 31/255.0, green: 181/255.0, blue: 167/255.0, alpha: 1)
        
        
        self.getData()
        
        
        
//        http://plat.znxk.net:6801/first/getStatus?companyCode=1009&orgCode=1009001&empNo=E100900003&empName=zf%E6%9C%BA%E6%9E%84&id=W100920190100004
        
        // Do any additional setup after loading the view.
    }

    func getData() {
        
        if self.scanUrl.characters.count > 0 {
            
            //生成二维码
            
            let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString:self.scanUrl , size: self.scanImg.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
            
            self.scanImg.image = qrImg
            
        }else{
            
            
            let para = ["orderNo": self.orderNo,
                        ]
            
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:"http://plat.znxk.net:6802/wx/scanCodePay" , modelClass: "scanCodePayModel", response: { (obj) in
                
                let model : scanCodePayModel = obj as! scanCodePayModel
                
                if model.statusCode == 800 {
                    
                    //生成二维码
                    
                    let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator", codeString:model.returnObj ?? "" , size: self.scanImg.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
                    
                    self.scanImg.image = qrImg
                    
                }
                
            }) { (error) in
                
            }
            
            
        }
        
      
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        
    }
    
    
    
    @objc func tickDown()
    {
       
        print(" 请求--------- ")
        
        UserCenter.shared.userInfo(Infor: { (islogin, userModel) in
            
            
            let para = [
                
                "id": self.orderNo,
                "companyCode": userModel.companyCode ?? "",
                "orgCode": userModel.orgCode ?? "",
                "empNo": userModel.empNo ?? "",
                "empName": userModel.empName ?? "",
                
                ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getStatusURL , modelClass: "payStatusModel", response: { (obj) in
                
                let model : payStatusModel  = obj as! payStatusModel
                
                if model.statusCode == 800 {
                    
                    //支付成功
                    if model.returnObj == "已支付" {
                        
                        let vc = PaySignVC()
                        vc.orderNo = self.orderNo
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        self.timer.invalidate()

                        
                    }
                    
                }
                
            }) { (error) in
                
            }
            
            
        })
        
        
    }
    
    
    @IBAction func billList(_ sender: UIButton) {
        
        self.navigationController?.pushViewController(myBillListVC(), animated: true)
        
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
