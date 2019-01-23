//
//  PaySignVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/23.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class PaySignVC: UIViewController ,PopSignatureViewDelegate {
    
    var orderNo = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "客户签字"
        
        let signView = PopSignatureView()
        signView.delegate = self
        self.view.addSubview(signView)
        signView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        

    }

    
    //确认签名
    func onSubmitBtn(_ signatureImg: UIImage!) {
        
//        http://plat.znxk.net:6801/first/getParagraph?companyCode=1009&orgCode=1009001&empNo=E100900003&empName=zf%E6%9C%BA%E6%9E%84&workNo=W100920181100002&str=
        
        let data = signatureImg.compress(withMaxLength: 1 * 1024 * 1024 / 8)
        
        // NSData 转换为 Base64编码的字符串
        let base64String:String = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
        
        
        
        UserCenter.shared.userInfo(Infor: { (islogin, user) in
            
            
            let para = [
                
                "file": base64String
                ]
 
            
            var url = "http://plat.znxk.net:6801/first/getParagraph?"
            
            //参数
            url = url + "companyCode="
            
            url = url + user.companyCode! + "&empName="
            
            url = url + user.empName! + "&empNo="
            
            url = url + user.empNo! + "&orgCode="
            
            url = url + user.orgCode! + "&str=3&workNo="
            
            url = url + self.orderNo
            
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "" , modelClass: "BaseModel", response: { (obj) in
                
                let model : BaseModel  = obj as! BaseModel
                
                if model.statusCode == 800 {
                    
                    //成功
                    self.navigationController?.popToViewController(self.navigationController?.viewControllers[1] ?? UIViewController(), animated: true)
                    
                    
                }
                
            }) { (error) in
                
            }
            
            
        })
        
        
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
