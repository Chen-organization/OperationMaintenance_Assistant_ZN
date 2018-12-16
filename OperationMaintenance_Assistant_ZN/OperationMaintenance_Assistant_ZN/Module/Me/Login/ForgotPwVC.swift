//
//  ForgotPwVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

protocol ChangedPwDelegate: class {

    func ChangedPw(phoneNum:String)
}


class ForgotPwVC: BaseTableVC ,UITextFieldDelegate{
    
    weak var delegate: ChangedPwDelegate!
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var newPwTextField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var vertifyBtn: PhoneCodeButton!
    
    
    @IBOutlet weak var footerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "忘记密码"
        
        self.phoneNumTextField.keyboardType = UIKeyboardType.numberPad
        self.phoneNumTextField.tag = 1000
        self.newPwTextField.tag = 2000
        self.messageTextField.tag = 3000
        
        self.phoneNumTextField.delegate = self
        self.newPwTextField.delegate = self
        self.messageTextField.delegate = self
        
        self.phoneNumTextField.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControlEvents.editingChanged)
        self.newPwTextField.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControlEvents.editingChanged)
        
        self.vertifyBtn.layer.borderColor = RGBCOLOR(r: 153, 153, 153).cgColor
        self.vertifyBtn.layer.borderWidth = 1
        
        
        self.sendBtn.layer.shadowColor = UIColor.red.cgColor;
        self.sendBtn.layer.shadowOffset = CGSize(width:1, height:2);
        self.sendBtn.layer.shadowOpacity = 0.7;
        self.sendBtn.layer.shadowRadius = 5;
        
        let subLayer=CALayer();
        var fixframe=self.sendBtn.layer.frame;
        fixframe.size.width = UIScreen.main.bounds.size.width - 80;
        subLayer.frame=fixframe;
        subLayer.cornerRadius=6;
        subLayer.backgroundColor=UIColor.gray.cgColor;
        subLayer.masksToBounds=false;
        subLayer.shadowColor=UIColor.black.cgColor;
        subLayer.shadowOffset=CGSize(width:1,height:2);
        subLayer.shadowOpacity=0.3;
        subLayer.shadowRadius=2;
        self.footerView.layer.insertSublayer(subLayer, below: self.sendBtn.layer)
        
    }
    
    
    @IBAction func verifyBtnClick(_ sender: Any) {
        
        if ( self.isCorrectTel(Str: self.phoneNumTextField.text!) ) {

            let para = [
                "state" : "0",
                "phone"   : self.phoneNumTextField.text ?? ""
                ] as [String : Any]

            NetworkService.networkGetrequest(currentView : self.view, parameters: para as! [String : String], requestApi: getBackPasswordUrl, modelClass: "BaseModel", response: { (obj) in

                    let model = obj as! BaseModel

                    if(model.statusCode == 800){

                        self.vertifyBtn.startUpTimer()
                        
                        YJProgressHUD.showMessage("验证码发送成功", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

                    }else{
                        
                        YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                }
                
                


                }, failture: { (error) in



                })

        }else{
            
            if self.phoneNumTextField.text!.characters.count > 0 {
                
                YJProgressHUD.showMessage("请输入正确的手机号码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                
            }else{
                

                YJProgressHUD.showMessage("请输入手机号码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
            }
            
        }
        
    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        
        if (self.isCorrectTel(Str: self.phoneNumTextField.text!) && self.messageTextField.text!.characters.count > 0 && self.newPwTextField.text!.characters.count >= 6) {
            
            
            
            let para = [
                        "state" : "1",
                        "phone"   : self.phoneNumTextField.text ?? "",
                        "Code"    : self.messageTextField.text ?? "",
                        "password":self.newPwTextField.text
                ] as [String : Any]
            
            NetworkService.networkPostrequest(currentView : self.view, parameters: para as! [String : String], requestApi: getBackPasswordUrl, modelClass: "BaseModel", response: { (obj) in
                
                let model = obj as! BaseModel

                if(model.statusCode == 800){
                    
                    
                    if self.delegate != nil{
                        
                        self.delegate.ChangedPw(phoneNum: self.phoneNumTextField.text!)
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                    YJProgressHUD.showMessage("修改成功", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                    
                }else{
                    
                    YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                }
                
                

                
            }, failture: { (error) in
                
                
                
                
            })
            
            
            
        }else{
            
            
            if (!self.isCorrectTel(Str: self.phoneNumTextField.text!)){
                
                if (self.phoneNumTextField.text!.characters.count > 0){
                    
                    YJProgressHUD.showMessage("请输入正确的手机号码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                    
                }else{
                    
                    YJProgressHUD.showMessage("请输入手机号码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

                }

            }else if(!(self.messageTextField.text!.characters.count > 0)){
                
                YJProgressHUD.showMessage("请输入短信验证码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

            }else if(!(self.newPwTextField.text!.characters.count >= 6)){
                
                YJProgressHUD.showMessage("请输入6~12位新密码", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

            }

            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string == ""){return true}

        
        if textField.tag == 1000 {
            
            //新号码
            let regex = "^[0-9]*$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: string)
            print(isValid ? "正确" : "错误")
            if isValid == false {
                
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

            }
            
            return  isValid
            
//            guard let text = textField.text else{ return true }
//            let textLength = text.characters.count + string.characters.count - range.length
//            return textLength<=11

        }else if textField.tag == 2000 {
            
            //密码
            let regex = "^[A-Za-z0-9]+$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: string)
            print("------" + string)
            
            return isValid
            
            
        }else if(textField.tag == 3000){
            
            //验证码
            let regex = "^[0-9]*$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: string)
            print(isValid ? "正确" : "错误")
            
            if isValid == false {
                
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

            }
            return isValid
            
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 2000 {
            
            if (textField.isSecureTextEntry)
            {
                textField.insertText(self.newPwTextField.text!)
            }
        }

    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func textField1TextChange(textfield: UITextField)  {
        
        if textfield.tag == 1000 {
            
            //tel
            if textfield.text!.characters.count > 11 {
                
                //获得已输出字数与正输入字母数
                let selectRange = textfield.markedTextRange
                
                //获取高亮部分 － 如果有联想词则解包成功
                if let selectRange = selectRange {
                    let position =  textfield.position(from: (selectRange.start), offset: 0)
                    if (position != nil) {
                        return
                    }
                }
                
                let textContent = textfield.text
                let textNum = textContent?.characters.count
                
                //截取200个字
                if textNum! > 11 {
                    let index = textContent?.index((textContent?.startIndex)!, offsetBy: 11)
                    let str = textContent?.substring(to: index!)
                    textfield.text = str
                }
            }
            
        }else if textfield.tag == 2000{
            
            //tel
            if textfield.text!.characters.count > 12 {
                
                //获得已输出字数与正输入字母数
                let selectRange = textfield.markedTextRange
                
                //获取高亮部分 － 如果有联想词则解包成功
                if let selectRange = selectRange {
                    let position =  textfield.position(from: (selectRange.start), offset: 0)
                    if (position != nil) {
                        return
                    }
                }
                
                let textContent = textfield.text
                let textNum = textContent?.characters.count
                
                //截取200个字
                if textNum! > 12 {
                    let index = textContent?.index((textContent?.startIndex)!, offsetBy: 12)
                    let str = textContent?.substring(to: index!)
                    textfield.text = str
                }
            }
            
        }
        
       
        
    }
    
    
    func isCorrectTel(Str:String) -> Bool {
        
        //手机号正则
        let regex = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: Str)
        print(isValid ? "正确的手机号" : "错误的手机号")
        
        return isValid
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
