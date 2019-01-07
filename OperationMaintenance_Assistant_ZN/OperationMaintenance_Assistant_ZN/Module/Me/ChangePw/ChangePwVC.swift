//
//  ChangePwVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class ChangePwVC: BaseTableVC ,UITextFieldDelegate, UIAlertViewDelegate{
    
    @IBOutlet weak var oldPw: UITextField!
    
    @IBOutlet weak var newPw: UITextField!
    
    @IBOutlet weak var makeSurePw: UITextField!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"
        
        self.oldPw.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControl.Event.editingChanged)
        self.newPw.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControl.Event.editingChanged)
        self.makeSurePw.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControl.Event.editingChanged)



        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.oldPw.delegate = self
        self.newPw.delegate = self
        self.makeSurePw.delegate = self
        
        self.oldPw.tag = 1000
        self.newPw.tag = 2000
        self.makeSurePw.tag = 3000

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
            view.backgroundColor = .clear
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 12
    }

    
    @IBAction func sureBtnClick(_ sender: UIButton) {
        
        let old = oldPw.text!
        let new = newPw.text!
        let makesure = makeSurePw.text!
        
        if (old.characters.count >= 6 && new.characters.count >= 6 && makesure.characters.count >= 6) {
            
            
            if(new != makesure){
                
                ZNCustomAlertView.handleTip("两次输入密码不一致", isShowCancelBtn: false, completion: { (sisure) in
                    
                })
                
                return
                
            }
            
            
            weak var weakSelf = self // ADD THIS LINE AS WELL
            
            UserCenter.shared.userInfo { (islogin, userInfo) in
                
                let para = [
                            "empID":userInfo.empNo,
                            "old":old,
                            "new" : new
                ]
                
                YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
                
                NetworkService.networkPostrequest(currentView : self.view, parameters: para as! [String : String], requestApi: getModifyPasswordUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model = obj as! BaseModel
                    if(model.statusCode == 800){
                        
                        UserCenter.shared.rememberPw(Pw: "", isRemember: false)
                        let vc = LoginVC.getLoginVC()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                        
                    }else{
                        
                        ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                        
                    }
                    
                    YJProgressHUD.hide()
                    
                }, failture: { (error) in
                    
                    YJProgressHUD.hide()

                })
                
            }
            
            
        }else{
            
            
            
            if (!(old.characters.count >= 6)){
                
                ZNCustomAlertView.handleTip("请输入6~12位旧密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
                
            }else if(!(new.characters.count >= 6 )){
                
                ZNCustomAlertView.handleTip("请输入6~12位新密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
                
            }else if(!(makesure.characters.count >= 6)){
                
                ZNCustomAlertView.handleTip("请输入6~12位确认密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
            }
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        guard let text = textField.text else{
//            return true
//        }
//
//        let textLength = text.characters.count + string.characters.count - range.length
//
//        return textLength <= 16
        
        if(string == ""){return true}
        
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: string)
        print("------" + string)
        
        return isValid
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.isSecureTextEntry)
        {
            if textField.tag == 1000 {
                
                textField.insertText(self.oldPw.text!)
                
            }else if textField.tag == 2000 {
                
                textField.insertText(self.newPw.text!)

            }else if textField.tag == 3000{
                
                textField.insertText(self.makeSurePw.text!)

            }
            
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @objc func textField1TextChange(textfield: UITextField)  {
        

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
                
                //截取11个字
                if textNum! > 12 {
                    let index = textContent?.index((textContent?.startIndex)!, offsetBy: 12)
                    let str = textContent?.substring(to: index!)
                    textfield.text = str
                }
            }
            
   
        
        
    }
    
    
}



