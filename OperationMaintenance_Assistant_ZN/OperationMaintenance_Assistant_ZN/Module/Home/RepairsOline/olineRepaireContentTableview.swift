//
//  olineRepaireContentTableview.swift
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

enum DropdownMenuType : Int {
    
    case classType, typeType
    
}


// 声明设置代理方法
protocol AddressTextFieldHeightChangeDelegate : class {
    
    func AddressTextFieldHeightChangeDelegate(height:Double)
}


class olineRepaireContentTableview: UITableViewController ,MKDropdownMenuDataSource, MKDropdownMenuDelegate
,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate , UITextViewDelegate{
    
//    let typeTitles : NSArray = ["Circle", "Triangle", "Rectangle", "Pentagon", "Hexagon"]
    
    var repairClassArr : NSArray = []
    var repairTypeArr : NSArray = []
    
    var selectedRepaireTypeModel : RepairsTypeReturnObjModel?
    var selectedRepaireClassModel : RepairsTypeReturnObjModel?

    var cacheTypeDic : [String: NSArray] = [:]
    
    
    @IBOutlet weak var dropDowmRepairsClassMenu: MKDropdownMenu!
    
    @IBOutlet weak var dropDownMenu: MKDropdownMenu!
    
    @IBOutlet weak var footerVeiw: PersonDataAddPicCell!
    
    
    @IBOutlet weak var contentTextView: UIPlaceHolderTextView!
    
    @IBOutlet weak var wokerName: UITextField!
    
    @IBOutlet weak var tel: UITextField!
    
    @IBOutlet weak var address: UIPlaceHolderTextView!
    
    var addressCellHeight = 40.0
    
    
    weak var delegate : AddressTextFieldHeightChangeDelegate?
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    var imageArr : NSMutableArray = NSMutableArray()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //--请选择报修类型--
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "现场报修"
        
        
        self.dropDowmRepairsClassMenu.tag = DropdownMenuType.classType.rawValue
        self.dropDownMenu.tag = DropdownMenuType.typeType.rawValue
        

        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        self.dropDownMenu.backgroundColor = UIColor.clear
        self.dropDownMenu.useFullScreenWidth = true
        self.dropDownMenu.delegate = self
        self.dropDownMenu.dataSource = self
        self.dropDownMenu.componentTextAlignment = NSTextAlignment.left
        self.dropDownMenu.dropdownShowsTopRowSeparator = false
        
        
        self.dropDowmRepairsClassMenu.backgroundColor = UIColor.clear
        self.dropDowmRepairsClassMenu.useFullScreenWidth = true
        self.dropDowmRepairsClassMenu.delegate = self
        self.dropDowmRepairsClassMenu.dataSource = self
        self.dropDowmRepairsClassMenu.componentTextAlignment = NSTextAlignment.left
        self.dropDowmRepairsClassMenu.dropdownShowsTopRowSeparator = false
        
        
        self.contentTextView.placeholder = "请输入您的内容"
        self.contentTextView.placeholderColor = RGBCOLOR(r: 153, 153, 153)
        self.contentTextView.delegate = self
        self.contentTextView.tag = 4000
        self.contentTextView.tintColor = self.view.tintColor
        self.contentTextView.text = ""

        
        self.address.delegate = self
        self.address.tag = 3000
        self.address.placeholder = "请填写详细地址"
        self.address.placeholderColor = RGBCOLOR(r: 153, 153, 153)
//        self.address.contentInset = UIEdgeInsetsMake(-5, 0.0, 0.0, 0.0);
        
        self.address.tintColor = self.view.tintColor
        


        
        self.wokerName.delegate = self
        self.tel.delegate = self
        
        self.wokerName.placeholderColor = RGBCOLOR(r: 153, 153, 153)
        self.tel.placeholderColor = RGBCOLOR(r: 153, 153, 153)
        
        self.tel.tag = 1000
        self.wokerName.tag = 2000
        
        
        self.wokerName.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControl.Event.editingChanged)
        self.tel.addTarget(self, action: #selector(textField1TextChange(textfield:)), for: UIControl.Event.editingChanged)

        
        let view:UIView = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.frame = CGRect(x:0 , y : 0 , width: ScreenW , height:10)
        let shadow:UIView = UIView()
        shadow.backgroundColor = UIColor.white
        shadow.frame = CGRect(x:0 , y : 7 , width: ScreenW , height:3)
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.shadowRadius = 3
        shadow.layer.shadowOffset = CGSize(width:0 ,height:0)
        view.addSubview(shadow)
        self.dropDownMenu.spacerView = view;
        self.dropDownMenu.backgroundDimmingOpacity = 0.00;
        self.dropDownMenu.tintColor = UIColor.clear
        
        
        let view1:UIView = UIView()
        view1.backgroundColor = UIColor.white
        view1.clipsToBounds = true
        view1.frame = CGRect(x:0 , y : 0 , width: ScreenW , height:10)
        let shadow1:UIView = UIView()
        shadow1.backgroundColor = UIColor.white
        shadow1.frame = CGRect(x:0 , y : 7 , width: ScreenW , height:3)
        shadow1.layer.shadowColor = UIColor.black.cgColor
        shadow1.layer.shadowOpacity = 0.3
        shadow1.layer.shadowRadius = 3
        shadow1.layer.shadowOffset = CGSize(width:0 ,height:0)
        view1.addSubview(shadow1)
        
        self.dropDowmRepairsClassMenu.spacerView = view1;
        self.dropDowmRepairsClassMenu.backgroundDimmingOpacity = 0.00;
        self.dropDowmRepairsClassMenu.tintColor = UIColor.clear
        
        
        footerVeiw.addPicturesBlock = {
            
            
            let actionSheet=UIActionSheet()
            
            actionSheet.addButton(withTitle:"取消" )//addButtonWithTitle("取消")
            actionSheet.addButton(withTitle:"拍照" )//addButtonWithTitle("动作1")
            actionSheet.addButton(withTitle:"从相册选择" )//addButtonWithTitle("动作2")
            actionSheet.cancelButtonIndex=0
            actionSheet.delegate=self
            actionSheet.show(in: self.view)
            
        }
        weak var weakSelf = self

        footerVeiw.deleteTweetImageBlock = {
            index in
            
            weakSelf?.imageArr.removeObject(at: Int(index))
            weakSelf?.footerVeiw.setDataArray(weakSelf?.imageArr as! [Any], isLoading: false)
        }
        
        
        self.footerVeiw.height = PersonDataAddPicCell.cellHeight(withObj: self.imageArr.count)
        self.tableView.reloadData()
        
        self.getRepairsClass()
        
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            self.wokerName.text = userInfo.empName
            self.tel.text = userInfo.mobile
            
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dropDownMenu.closeAllComponents(animated: false)
        self.dropDowmRepairsClassMenu.closeAllComponents(animated: false)
        
        IQKeyboardManager.shared.enable = true

    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        
        
        print("点击了："+actionSheet.buttonTitle(at: buttonIndex)!)
        var sourceType: UIImagePickerController.SourceType = .photoLibrary
        if (buttonIndex == 0) {
            
            return
        }else if (buttonIndex == 1) {
            
            //拍照
            sourceType = .camera
            
        }else if (buttonIndex == 2) {
            
            //相册
            sourceType = .photoLibrary
            
        }
        
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        pickerVC.sourceType = sourceType
        present(pickerVC, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        //获得照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
//        let data = UIImageJPEGRepresentation(image,0.4);
//        let imageBase64String = data?.base64EncodedString()
        
        self.imageArr.add(image)
        
        self.footerVeiw.setDataArray(self.imageArr as! [Any], isLoading: false)
        
        self.footerVeiw.height = 140//PersonDataAddPicCell.cellHeight(withObj: self.imageArr.count)
        self.tableView.reloadData()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 2
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return section == 0 ? 5 : 1
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 2 {
                
                return CGFloat(self.addressCellHeight)
                
            }else{
                
                return 40
                
            }
            
        }else{
            
            return 132
        }
        
        
    }
    
        override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
            return 10
        }
    
        override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
            let view : UIView = UIView()
            view.backgroundColor  = UIColor.clear
            return view
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dropDownMenu.closeAllComponents(animated: true)
        self.dropDowmRepairsClassMenu.closeAllComponents(animated: true)
        
    }
    
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        }
    
    
    // MKDropdownMenuDataSource
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        
        return 1
    }
    
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        
        let title : String!
        
        if dropdownMenu.tag == DropdownMenuType.classType.rawValue{
            
            if self.selectedRepaireClassModel != nil {
                
                title = self.selectedRepaireClassModel?.workName
            }else{
                
                title = "--请选择报修类别--"
            }
        }else{
            
            if self.selectedRepaireTypeModel != nil {
                
                title = self.selectedRepaireTypeModel?.typeName
            }else{
                
                title = "--请选择报修类型--"
            }
        }
        
        
        
        let att = NSAttributedString.init(string: title , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor : RGBCOLOR(r: 51, 51, 51)])
        
        return att
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        
        return  dropdownMenu.tag == DropdownMenuType.classType.rawValue ? self.repairClassArr.count : self.repairTypeArr.count
    }
    
    //MKDropdownMenuDelegate
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, rowHeightForComponent component: Int) -> CGFloat {
        
        return 33
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, maximumNumberOfRowsInComponent component: Int) -> Int {
        
        return 10
        
    }
    
//    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, widthForComponent component: Int) -> CGFloat {
//
//        return ScreenW //180
//    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, shouldUseFullRowWidthForComponent component: Int) -> Bool {
        return true
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view : UIView = UIView()
        
        let model = (dropdownMenu.tag == DropdownMenuType.classType.rawValue ? self.repairClassArr[row] : self.repairTypeArr[row]) as! RepairsTypeReturnObjModel
        
        let label : UILabel = UILabel()
        label.text = ( dropdownMenu.tag == DropdownMenuType.classType.rawValue ? model.workName : model.typeName)
        label.font = UIFont.systemFont(ofSize:13 )
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
//            make.left.equalTo(view).offset(10)
        }
        
        
        return view
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        
        
        print(row)
        
        if dropdownMenu.tag == DropdownMenuType.classType.rawValue {
            
            
            self.selectedRepaireTypeModel = nil
            
            let model = self.repairClassArr[row] as! RepairsTypeReturnObjModel
            self.selectedRepaireClassModel = model
            
            var m = self.cacheTypeDic[model.workClass != nil ? model.workClass! : ""]
            
            if (m != nil) {
                
                self.repairTypeArr = m as! NSArray
                self.dropDownMenu.reloadAllComponents()
                
            }else{

                self.getRepairsType(replairClass: model.workClass!)

                
            }
            
        }else{
            
                let model = self.repairTypeArr[row] as! RepairsTypeReturnObjModel
                self.selectedRepaireTypeModel = model
                
   
            
        }
        
        
        dropdownMenu.reloadAllComponents()
        
        dropdownMenu.closeAllComponents(animated: true)
        
    }
    
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didOpenComponent component: Int) {
        
        self.view.endEditing(true)
        
        if (dropdownMenu.tag == DropdownMenuType.classType.rawValue){
            
            self.dropDownMenu.closeAllComponents(animated: false)
        
            if(self.repairClassArr.count == 0){
                
                self.view.beginLoading()
                self.getRepairsClass()
                dropdownMenu.closeAllComponents(animated: false)
                
            }
            
        }else
        if (dropdownMenu.tag == DropdownMenuType.typeType.rawValue){
            
            self.dropDowmRepairsClassMenu.closeAllComponents(animated: false)
            
            if(self.repairTypeArr.count == 0){
                
                
                if (self.selectedRepaireClassModel == nil){
                    
//                    ZNCustomAlertView.handleTip("请选择报修类别", isShowCancelBtn: false, completion: { (issure) in
//
//                    })
                    dropdownMenu.closeAllComponents(animated: false)
                    
                }else{
                    
                    self.view.beginLoading()
                    self.getRepairsType(replairClass: (self.selectedRepaireClassModel?.workClass)!)
                    dropdownMenu.closeAllComponents(animated: false)
                }

                
            }
            
            
        }

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.dropDownMenu.closeAllComponents(animated: true)
        self.dropDowmRepairsClassMenu.closeAllComponents(animated: true)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     
        if textField.tag == 1000 {
            //tel
            
            let regex = "^[0-9]*$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: string)
            print(isValid ? "正确" : "错误")
            if !isValid {
                
                
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)

                return false
                
            }
            
//            guard let text = textField.text else{ return true }
//            let textLength = text.characters.count + string.characters.count - range.length
//            return textLength<=11
            
        }else if(textField.tag == 2000){
            //workname
            if string == " " {
                
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                return false
            }
            
            let  isEmoji = self.isEmojiStr(text: string, textView: textField)
            if isEmoji { return false }
            
            
//            guard let text = textField.text else{ return true }
//            let textLength = text.characters.count + string.characters.count - range.length
//            return textLength<=11
            
        }else{
            //address
            
            let  isEmoji = self.isEmojiStr(text: string, textView: textField)
            
            if isEmoji { return false }
            
        }
        
    
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textField1TextChange(textfield: UITextField)  {
        
        //报修人员
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
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
        
        self.dropDownMenu.closeAllComponents(animated: true)
        self.dropDowmRepairsClassMenu.closeAllComponents(animated: true)
        
        return true
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
        
//        if textView.tag == 3000  {
//
//            if text == " " {
//
//                ZNCustomAlertView.handleTip("请输入正确字符", isShowCancelBtn: false, completion: { (issure) in
//
//                })
//                return false
//            }
//        }
        
        if (text == "\n") {  // textView点击完成隐藏键盘
            
            textView.resignFirstResponder()
            
            return false
            
        }else{
            
            if textView.textInputMode?.primaryLanguage == "emoji" || ((textView.textInputMode?.primaryLanguage) == nil) {
                 YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                return false
            }
            
            if NSString.isNineKeyBoard(text) {
                
                self.setAddressCellheight(textView: textView)
                
                return true
            }else{
                
                let str : NSString = text as NSString
                
                if ( str.containEmoji()){
                     YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                    return false
                }
            }
            
        }
        
        self.setAddressCellheight(textView: textView)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.tag == 3000{
            
            //限制字数 64
            if textView.text.characters.count > 64 {
                
                //获得已输出字数与正输入字母数
                let selectRange = textView.markedTextRange
                
                //获取高亮部分 － 如果有联想词则解包成功
                if let selectRange = selectRange {
                    let position =  textView.position(from: (selectRange.start), offset: 0)
                    if (position != nil) {
                        return
                    }
                }
                
                let textContent = textView.text
                let textNum = textContent?.characters.count
                
                //截取200个字
                if textNum! > 64 {
                    let index = textContent?.index((textContent?.startIndex)!, offsetBy: 64)
                    let str = textContent?.substring(to: index!)
                    textView.text = str
                }
            }
            
            self.setAddressCellheight(textView: textView)

        }
        
        
        
    }
    
    func setAddressCellheight(textView : UITextView ) {
        
        if textView.tag == 3000{
            
            let size = NSString.getRectInTextView(textView.text, in: textView)
            self.addressCellHeight = size.height < 40 ? 40 : Double(size.height) + 11
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            delegate?.AddressTextFieldHeightChangeDelegate(height: self.addressCellHeight)
        }
        
    }
    
    
    func getRepairsType(replairClass:String) {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workClass": replairClass,
                        ]
            
            NetworkService.networkGetrequest(currentView : self.view , parameters: para as! [String : String], requestApi: getRepairsTypeUrl, modelClass: "RepairsTypeModel", response: { (obj) in
                
                self.view.endLoading()
                
                let model = obj as! RepairsTypeModel
                
                if model.statusCode == 800{
                    
                    self.cacheTypeDic[replairClass] = model.returnObj as! NSArray
         
                    self.repairTypeArr = model.returnObj as! NSArray
                    
                    self.dropDownMenu.reloadAllComponents()
                }

                
            }, failture: { (error) in
                
                self.view.endLoading()
                
            })
            
            
        }
        
        
    }
    
    
    func getRepairsClass() {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        
                        ]
            
            NetworkService.networkGetrequest(currentView : self.view , parameters: para as! [String : String], requestApi: getRepairsClassUrl, modelClass: "RepairsTypeModel", response: { (obj) in
                self.view.endLoading()
                
                let model = obj as! RepairsTypeModel
                
                if model.statusCode == 800{
                    
                    self.repairClassArr = model.returnObj as! NSArray
                    self.dropDowmRepairsClassMenu.reloadAllComponents()
                }

                
            }, failture: { (error) in
                
                self.view.endLoading()
            })
            
            
        }
        
        
    }
    
    
    
    func isEmojiStr(text:String , textView:UITextField) -> Bool {
        
        
        if textView.textInputMode?.primaryLanguage == "emoji" || ((textView.textInputMode?.primaryLanguage) == nil) {
            YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
            return true
        }
        
        if NSString.isNineKeyBoard(text) {
            
            return false
        }else{
            
            let str : NSString = text as NSString
            
            if ( str.containEmoji() /*NSString.hasEmoji(text) || NSString.stringContainsEmoji(text)*/ ){
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                return true
            }
        }
        
        return false
    }
    
    
    
    /** 根据字符串的的长度来计算UITextView的高度 - parameter textView: UITextView - parameter fixedWidth: UITextView宽度 - returns: 返回UITextView的高度 */
     func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        self.dropDownMenu.closeAllComponents(animated: true)
        self.dropDowmRepairsClassMenu.closeAllComponents(animated: true)
        
    }
    
  
    
}
