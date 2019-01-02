//
//  changeMeterVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/18.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class changeMeterVC: UITableViewController,ScanViewControllerDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,MKDropdownMenuDataSource,MKDropdownMenuDelegate {
    
    
    
    @IBOutlet weak var meterNoTextField: UITextField!
    
    @IBOutlet weak var meterNameL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    
    @IBOutlet weak var oldMeterNum: UITextField!
    @IBOutlet weak var newMeterNum: UITextField!
    @IBOutlet weak var remainNum: UITextField!
    
    @IBOutlet weak var dropDownMenu: MKDropdownMenu!
    
    
//    @IBOutlet weak var typeSelectContentView: UIView!
    @IBOutlet weak var remarkTextView: UITextView!
    
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    
    @IBOutlet weak var firstDeleteBtn: UIButton!
    @IBOutlet weak var secondDeleteBtn: UIButton!
    
    
    var selectedRepaireTypeModel : changeMeterParModel?  //类型

    var repairTypeArr : NSArray = [Any]() as NSArray

    
    var firstImage64Str : String?
    var secondImage64Str : String?
    
    var deviceInfoModel : getDeviceInfoReturnObjModel?   //获取的表设备数据

    var selectingImgIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "换表"
        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1 //轻点次数
        tap.numberOfTouchesRequired = 1 //手指个数
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapFirstImgView(action:)))
        self.firstImgView.addGestureRecognizer(tap)
        
        
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap1.numberOfTapsRequired = 1 //轻点次数
        tap1.numberOfTouchesRequired = 1 //手指个数
        tap1.delegate = self
        tap1.addTarget(self, action: #selector(tapSecondImgView(action:)))
        self.secondImgView.addGestureRecognizer(tap1)
//        
//        self.tableView.register(UINib.init(nibName: NSStringFromClass(ReadingVCTableviewCell.self), bundle: nil), forCellReuseIdentifier: ReadingVCTableviewCell_id)
        
        self.meterNoTextField.delegate = self
        self.meterNoTextField.addTarget(self, action: #selector(meterNoChanged), for: UIControl.Event.editingChanged)
        
        
        
        self.dropDownMenu.backgroundColor = UIColor.clear
        self.dropDownMenu.useFullScreenWidth = true
        self.dropDownMenu.delegate = self
        self.dropDownMenu.dataSource = self
        self.dropDownMenu.componentTextAlignment = NSTextAlignment.left
        self.dropDownMenu.dropdownShowsTopRowSeparator = false
        
      
        self.firstDeleteBtn.isHidden = true
        self.secondDeleteBtn.isHidden = true
        

        
        
    }
    
    //MARK: - 设备更换原因 获取

    func getChangeReason(meterNo:String) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode": userModel.companyCode ?? "",
                "orgCode": userModel.orgCode ?? "",
                "empNo": userModel.empNo ?? "",
                "empName": userModel.empName ?? "",
                "code": "2",
                "deviceNo": meterNo ,
                ] as [String : Any]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi: changeReasonUrl, modelClass: "changeMeterModel", response: { (obj) in
                
                let model : changeMeterModel = obj as! changeMeterModel
                
                if model.statusCode == 800 {
                    
                    self.meterNoTextField.text = model.returnObj?.display?.deviceNO ?? ""
                    self.meterNameL.text = model.returnObj?.display?.deviceName ?? ""
                    self.addressL.text = model.returnObj?.display?.installSite ?? ""
                    self.oldMeterNum.text = model.returnObj?.display?.nowValue?.description ?? ""
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
                        
                        self.newMeterNum.becomeFirstResponder()
                        
                    }
                    
                    self.repairTypeArr = model.returnObj?.par as! NSArray
                    self.dropDownMenu.reloadAllComponents()
                    
                }
                
                
            }, failture: { (error) in
                
                
                
            })
        }
        
        
    }
    
    //MARK: - textField
    @objc func meterNoChanged() {
        
        if self.meterNoTextField.text?.characters.count == 16 {
            
            self.searchBtnClick()
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text!
        
        let len = text.characters.count + string.count - range.length
        
        return len<=16
        
    }
    
    
    func searchBtnClick() {
        
        if !((self.meterNoTextField.text?.characters.count)! > 0) {
            
            ZNCustomAlertView.handleTip("请输入设备编码或表号", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            UserCenter.shared.userInfo { (islogin, model) in
                
                let para = [
                    "companyCode":model.companyCode,
                    "empNo":model.empNo,
                    "orgCode":model.orgCode,
                    "id": self.meterNoTextField.text]
                
                NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getVerificationUrl, modelClass: "getVerificationModel"
                    , response: { (object) in
                        
                        let model : getVerificationModel = object as! getVerificationModel
                        
                        if model.statusCode == 800 {
                            
                            if (Int((model.returnObj?.state)!) == 1) {
                                
                                self.getMeterInfo(deviceKey: self.meterNoTextField.text!)
                                
                            }else{
                                
                                ZNCustomAlertView.handleTip("设备不存在", isShowCancelBtn: false, completion: { (isSure) in
                                    
                                    
                                })
                            }
                            
                        }else{
                            
                            ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (isSure) in
                                
                            })
                            
                        }
                        
                        
                }) { (error) in
                    
                    
                }
                
                
                
            }
            
            
            
        }else{
            
            self.searchMeterWighKey(key: self.meterNoTextField.text ?? " ")
        }

    }
    
    //本地字典表查询
    func searchMeterWighKey(key:String) {
        
        
        let result = RealmTool.getMetersDic()
        if result.count > 0 {
            
            
            //无网络本地查询
            let arr :NSArray = RealmTool.getOneMetersDic(meterNo: key) as NSArray
            
            if (arr.count > 0) {
                
                
                let model:DownloadMeterDicReturnObjModel = arr.firstObject as! DownloadMeterDicReturnObjModel
                
                
                self.meterNoTextField.text = model.id ?? ""
                self.meterNameL.text = model.name ?? ""
                self.addressL.text = model.installSite ?? ""
                self.oldMeterNum.text = model.nowValue.description ?? ""
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
                    
                    self.newMeterNum.becomeFirstResponder()
                }
                
                
                self.deviceInfoModel = getDeviceInfoReturnObjModel()
                self.deviceInfoModel?.deviceNo = model.id ?? ""
                self.deviceInfoModel?.lastNowValue = model.nowValue as? Double
                self.deviceInfoModel?.deviceName = model.name ?? ""
                self.deviceInfoModel?.stationName = model.stationName ?? ""
                self.deviceInfoModel?.installSite = model.installSite ?? ""
                
                if let mul = model.multiplyingPower{
                    
                    self.deviceInfoModel?.multiplyingPower = Double(mul) ?? 0
                    
                }
                
                
                
            }
            
        }else{
            
            ZNCustomAlertView.handleTip("请先下载字典表", isShowCancelBtn: false) { (issure) in
            }
            
        }
        
        
        
        
    }
    
    
    //MARK: - MKDropdownMenu
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        
        return 1
    }
    
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        
        let title : String!
        
            
            if self.selectedRepaireTypeModel != nil {
                
                title = self.selectedRepaireTypeModel?.configName
            }else{
                
                title = ""
            }
        
        
        
        let att = NSAttributedString.init(string: title , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor : RGBCOLOR(r: 51, 51, 51)])
        
        return att
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        
        return  self.repairTypeArr.count
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
        
        let model = self.repairTypeArr[row] as! changeMeterParModel
        
        let label : UILabel = UILabel()
        label.text = model.configName
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
        
            
            let model = self.repairTypeArr[row] as! changeMeterParModel
            self.selectedRepaireTypeModel = model

        
        dropdownMenu.reloadAllComponents()
        dropdownMenu.closeAllComponents(animated: true)
        
    }
    
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didOpenComponent component: Int) {
        
        self.view.endEditing(true)
        
//
//                if(self.repairTypeArr.count == 0){
//
//
//                    if (self.selectedRepaireClassModel == nil){
//
//                        //                    ZNCustomAlertView.handleTip("请选择报修类别", isShowCancelBtn: false, completion: { (issure) in
//                        //
//                        //                    })
//                        dropdownMenu.closeAllComponents(animated: false)
//
//                    }else{
//
//                        self.view.beginLoading()
//                        self.getRepairsType(replairClass: (self.selectedRepaireClassModel?.workClass)!)
//                        dropdownMenu.closeAllComponents(animated: false)
//                    }
//
//
//                }

    }
    
    
    
    
    // MARK: - 手势
    @objc func tapFirstImgView(action:UITapGestureRecognizer) -> Void {
        
        self.selectingImgIndex = 1
        
        print("照相")
        if self.firstImage64Str == nil {
            
            //拍照
            self.cameraGetphoto()
            
        }else{
            
            //查看
            let img :UIImageView = action.view as! UIImageView
            
            PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                
                
                let pbModel = PhotoModel()
                pbModel.mid = 1
                pbModel.image = img.image
                
                return [pbModel]
                
            }
            
        }
        
    }
    
    @objc func tapSecondImgView(action:UITapGestureRecognizer) -> Void {
        
        self.selectingImgIndex = 2
        
        print("  ")
        
            if self.secondImage64Str == nil {
                
                //拍照
                self.cameraGetphoto()
                
            }else{
                
                //查看
                let img :UIImageView = action.view as! UIImageView
                
                PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                    
                    
                    let pbModel = PhotoModel()
                    pbModel.mid = 1
                    pbModel.image = img.image
                    
                    return [pbModel]
                }
                
            }
            

    }
    
    //MARK: - tableview
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    
    //MARK: -  拍照
    func cameraGetphoto() {
        
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        pickerVC.sourceType = .camera
        present(pickerVC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //获得照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //        let data = UIImageJPEGRepresentation(image,0.4);
        //        let imageBase64String = data?.base64EncodedString()
        
        
        let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
        print( Double((data?.count)!)/1024.0/1024.0)
        let imageBase64String = data!.base64EncodedString()
        
        if (self.selectingImgIndex == 1 ){
            
            
            self.firstImgView.image = image
            self.firstImage64Str = imageBase64String
            self.firstDeleteBtn.isHidden = false
            
        }else  if( self.selectingImgIndex == 2) {
            
            self.secondImgView.image = image
            self.secondImage64Str = imageBase64String
            self.secondDeleteBtn.isHidden = false
            
        }
     
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    // MARK: - Table view data source


    //MARK: - 控制器 方法
    
    @IBAction func deleteFirstImg(_ sender: UIButton) {
        
        self.firstImgView.image = UIImage.init(named: "相机")
        self.firstImage64Str = nil;
        
        self.firstDeleteBtn.isHidden = true
        
    }
    
    
    @IBAction func deleteSecondImg(_ sender: UIButton) {
        
        self.secondImgView.image = UIImage.init(named: "相机")
        self.secondImage64Str = nil
        self.secondDeleteBtn.isHidden = true
        
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        //二维码
        
        let vc = QQScanViewController()
        vc.scanDelegate = self;
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "qrcode_scan_light_green")
        vc.scanStyle = style
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        if self.meterNoTextField.text?.characters.count != 16 {
            
            ZNCustomAlertView.handleTip("设备编号输入错误，请重新输入", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        if self.oldMeterNum.text == "" {
            
            ZNCustomAlertView.handleTip("请输入旧表底数", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        if self.newMeterNum.text == "" {
            
            ZNCustomAlertView.handleTip("请输入新表底数", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        if self.remainNum.text == "" {
            
            ZNCustomAlertView.handleTip("请输入余量", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        if ((self.selectedRepaireTypeModel == nil)){
            
            ZNCustomAlertView.handleTip("请选择换表原因", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        if !(self.firstImage64Str?.characters.count ?? 0 > 0){
            
            ZNCustomAlertView.handleTip("请进行旧表拍照", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        if !(self.secondImage64Str?.characters.count ?? 0 > 0){
            
            ZNCustomAlertView.handleTip("请进行新表拍照", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
//        MBProgressHUD.show(withModifyStyleMessage: "", to: self.view)
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            var para = [

                "companyCode": userModel.companyCode!,
                "orgCode": userModel.orgCode!,
                "empNo": userModel.empNo!,
                "empName": userModel.empName!,
                "code": "1",
                "deviceNo": self.meterNoTextField.text ?? "",
                "oldGauge": self.oldMeterNum.text ?? "",
                "newGauge": self.newMeterNum.text ?? "",
                "remarks": self.remarkTextView.text ?? "",
                "reason": self.selectedRepaireTypeModel?.configCode ?? "",
                "remain": self.remainNum.text ?? "",

                ] as [String : Any]

            
            if let oldFile = self.firstImage64Str {

                para["oldFile"] = oldFile

            }
            if let newFile = self.secondImage64Str {

                para["newFile"] = newFile

            }
//
//            let newUrl = getDateUrl + "?companyCode:" + userModel.companyCode! + "&orgCode:" +  userModel.orgCode! + "&empNo:" + userModel.empNo!
//
//            let newnewUrl = newUrl  + "&empName:" + userModel.empName! + "&deviceNo:" + (self.deviceInfoModel?.deviceNo ?? "") + "&oldGauge:" + (self.oldMeterNum.text ?? "")
//
//            let url3 = newnewUrl  + "&newGauge:" + (self.newMeterNum.text ?? "") + "&remarks:" + (self.remarkTextView.text ?? "")
//
//            let url4 = url3 + "&reason:070001" + "&remain:" + (self.remainNum.text ?? "")
            
            
//            let newurl = NSString.connect(withAuthorizeUrl: getDateUrl, andParams: para)
            

            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getDateUrl , modelClass: "BaseModel", response: { (obj) in
                
                let model : BaseModel = obj as! BaseModel
                
                if model.statusCode == 800 {
                    
                    ZNCustomAlertView.handleTip("更换成功", isShowCancelBtn: false, completion: { (sure) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    
                    ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (sure) in
                        
                        
                    })
                }
                
//                MBProgressHUD.hide(for: self.view)
                YJProgressHUD.hide()
                
            }, failture: { (error) in
                
                YJProgressHUD.hide()

//                MBProgressHUD.hide(for: self.view)

                
            })
            
            
        }
        
        
      
    }
    
    
    // MARK: - 二维码 代理
    func ScanViewInfo(answer: String) {
        
        self.getMeterInfo(deviceKey: answer)

    }
    
    
    func getMeterInfo(deviceKey:String) {
        
        
        self.getChangeReason(meterNo: deviceKey)
//
//        UserCenter.shared.userInfo { (islogin, model) in
//
//            let para = ["deviceKey":deviceKey,
//                        "companyCode":model.companyCode,
//                        "empNo":model.empNo,
//                        "orgCode":model.orgCode,
//                        ]
//
//            NetworkService.networkGetrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeviceInfoUrl, modelClass: "getDeviceInfoModel", response: { (obj) in
//
//                let model = obj as! getDeviceInfoModel
//
//                if model.statusCode == 800 {
//
//                    self.deviceInfoModel = model.returnObj
//
//                    self.meterNoTextField.text = model.returnObj?.deviceNo ?? ""
//                    self.meterNameL.text = model.returnObj?.deviceName ?? ""
//                    self.addressL.text = model.returnObj?.installSite ?? ""
//                    self.oldMeterNum.text = model.returnObj?.lastNowValue?.description ?? ""
//
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
//
//                        self.newMeterNum.becomeFirstResponder()
//
//                    }
//
//
//                }
//
//            }) { (error) in
//
//            }
//
//        }
  
    }
    
   

}
