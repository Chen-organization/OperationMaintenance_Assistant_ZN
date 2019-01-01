//
//  readingVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/16.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import Photos
import Alamofire


class readingVC: UITableViewController,ScanViewControllerDelegate,UIGestureRecognizerDelegate,meterReadingSignVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ReadingVCTableviewCellDelegate,UITextFieldDelegate {

    @IBOutlet weak var meterNo: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var nowNum: UITextField!
    
    @IBOutlet weak var nultL: UILabel!  //倍率
    @IBOutlet weak var lastTimeMeterNumL: UILabel!
    
    
    @IBOutlet weak var remarksTextField: UITextField!  //备注
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var meterNoL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var projectNameL: UILabel!
    
    @IBOutlet weak var meterImg: UIImageView!
    @IBOutlet weak var signImg: UIImageView!
    
    
    @IBOutlet weak var meterImgDeleteBtn: UIButton!
    @IBOutlet weak var signImgDeleteBtn: UIButton!
    
    var meterArr = [AnyObject]()  //下部展示 抄表数据
    
    var deviceInfoModel : getDeviceInfoReturnObjModel?   //获取的表设备数据
    
    var meterImage64Str : String?
    var signImage64Str : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "抄表"
        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)

        self.meterImgDeleteBtn.isHidden = true
        self.signImgDeleteBtn.isHidden = true
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1 //轻点次数
        tap.numberOfTouchesRequired = 1 //手指个数
        tap.delegate = self
        tap.addTarget(self, action: #selector(tapPickImgView(action:)))
        self.meterImg.addGestureRecognizer(tap)
      
        
        let tap1:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap1.numberOfTapsRequired = 1 //轻点次数
        tap1.numberOfTouchesRequired = 1 //手指个数
        tap1.delegate = self
        tap1.addTarget(self, action: #selector(tapSignImgView(action:)))
        self.signImg.addGestureRecognizer(tap1)
        
        self.tableView.register(UINib.init(nibName: "ReadingVCTableviewCell", bundle: nil), forCellReuseIdentifier: ReadingVCTableviewCell_id)
        
        
        self.meterNo.delegate = self;
        self.meterNo.addTarget(self, action: #selector(meterNoChanged), for: UIControl.Event.editingChanged)
        
        
        // 返回按钮
        let backButton = UIButton(type: .custom)
        // 设置frame
        backButton.frame = CGRect(x: 200, y: 13, width: 18, height: 18)
        backButton.addTarget(self, action: #selector(toList), for: .touchUpInside)
        backButton.setTitle("记录", for: UIControl.State.normal)
        backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        // 自定义导航栏的UIBarButtonItem类型的按钮
        let backView = UIBarButtonItem(customView: backButton)
        // 重要方法，用来调整自定义返回view距离左边的距离
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        barButtonItem.width = -5
        // 返回按钮设置成功
        navigationItem.rightBarButtonItems = [barButtonItem, backView]

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
    }
    
    //MARK: - toList
    @objc func toList() {
        
//        let list = UIStoryboard(name: "MeterReading", bundle: nil)
//            .instantiateViewController(withIdentifier: "readingListVC") as! readingListVC
        self.navigationController?.pushViewController(readingListVC(), animated: true)
        
    }
    
    @objc func meterNoChanged() {

        if self.meterNo.text?.characters.count == 16 {
            
            self.searchBtnClick(UIButton())
            
        }
        
    }
    
    @objc func tapPickImgView(action:UITapGestureRecognizer) -> Void {
        
        print("照相")
        if self.meterImage64Str == nil {
            
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
    
    @objc func tapSignImgView(action:UITapGestureRecognizer) -> Void {
        
        print("签名")
        
        if ((self.nowNum.text)!.characters.count > 0) {
            
            if self.signImage64Str == nil {

                //签名
                let vc = meterReadingSignVC()
                vc.signDelegate = self
//
//                if let name = self.deviceInfoModel?.deviceName{
//
//                    vc.meterNameL.text = name
//                }
//
//                if let lastimeNum = self.deviceInfoModel?.lastNowValue?.description{
//
//                     vc.lastTimeMeterNumL.text = lastimeNum
//                }
//
//                if let nowNum = self.nowNum.text{
//
//                    vc.NowMeterNumL.text = nowNum
//                }
//
//                if let meterNo = self.deviceInfoModel?.deviceNo{
//
//                    vc.meterNo.text =  meterNo
//                }
            
                vc.meterName = self.deviceInfoModel?.deviceName ?? ""
                vc.lastTimeMeterNum = self.deviceInfoModel?.lastNowValue?.description ?? ""
                vc.NowMeterNum = self.nowNum.text ?? ""
                vc.meterNoStr = self.deviceInfoModel?.deviceNo ?? ""

                vc.num = ""

                if let now = self.nowNum.text{
                    
                    if let last = self.deviceInfoModel?.lastNowValue{
                        
                        if let nowNum = Double(now){
                            
//                            if let lastNum = last{
                            
                                let num = nowNum - last
                                vc.num = num.description

//                            }
                            
                        }

                    }
                    
                }
                

                self.navigationController?.pushViewController(vc, animated: true)
                
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
            
        }else{
            
            ZNCustomAlertView.handleTip("请先输入本次抄表数", isShowCancelBtn: false) { (issure) in
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==2 {
            return self.meterArr.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell:ReadingVCTableviewCell
                = tableView.dequeueReusableCell(withIdentifier: ReadingVCTableviewCell_id, for: indexPath) as! ReadingVCTableviewCell
            
            let model : writeMeterModel = self.meterArr[indexPath.row] as! writeMeterModel
            
            cell.nameL.text = model.deviceName ?? ""
            cell.value0.text = model.value ?? ""
            cell.value1.text = self.timeStampToString(timeStamp: model.time ?? "")
            
            cell.index = indexPath.row
            
            cell.cellDelegate = self
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 2 || indexPath.section == 1){
            
            return 40
        }
        
        return 360
    }
    
    
    //cell的缩进级别,动态静态cell必须重写,否则会造成崩溃
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        if(3 == indexPath.section){
            // (动态cell)
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 1 ? 10 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view;
    }

    
    // MARK: - 本控制器方法
    @IBAction func deletePickImg(_ sender: UIButton) {
        
        self.meterImg.image = UIImage.init(named: "相机")
        self.meterImage64Str = nil;
        
        self.meterImgDeleteBtn.isHidden = true
        
    }
    
    
    @IBAction func deleteSignImg(_ sender: UIButton) {
        
        self.signImg.image = UIImage.init(named: "签字1")
        self.signImage64Str = nil
        self.signImgDeleteBtn.isHidden = true
        
    }
    
//
//    func toPickImg() {
//
//
//
//
//    }

//    func toSignImg() {
//
//
//
//    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        // 1 、 为空判断
        
        if (self.deviceInfoModel == nil)  {
            
            ZNCustomAlertView.handleTip("请先查询上次表底数后在进行提交", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        if !(self.nowNum.text?.characters.count ?? 0 > 0)  {
        
            ZNCustomAlertView.handleTip("请先输入本次抄表数", isShowCancelBtn: false) { (issure) in
                
            }
            return
        }
        
        // 2 、 数据确认 弹框确认
        ZNMakeSureView.handleTip(self.nowNum.text!, isShowCancelBtn: true) { (makeSure) in
            
            
            if makeSure {
                
                // 3 、 上次表底数比较
                var isRight = true
                
                if let num = Int(self.nowNum.text!) {
                    
                    if let last = self.deviceInfoModel?.lastNowValue {
                        
                        isRight =  num >= Int(last) ? true : false
                        
                    }
                }
                
                if !isRight {
                    
                    ZNCustomAlertView.handleTip("输入表底数比上次小，请确认是否超出最大量程 ？", isShowCancelBtn: true) { (issure) in
                        
                        if issure{
                            
                            self.saveData()
                        }else{
                            
                            return;
                        }
                        
                    }
                }else{
                    
                    self.saveData()
                }
                
                

                
            }
            
            
            
        }
        
      
      
    }
    
    
    func saveData() {
        
        let time = self.milliStamp
        print("对应的日期时间：\(time)")
        
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            
            //网络提交
            UserCenter.shared.userInfo { (islogin, userModel) in
                
                var isMoreThanMaxStr = "0"
                if let num = Int(self.nowNum.text!) {
                    
                    if let max = self.deviceInfoModel?.thresholdMax {
                        
                        isMoreThanMaxStr =  num > Int(max) ? "1" : "0"
                        
                    }
                    
                }
                
                //MARK: - ！！！！ 添加经纬度 ！！！！！！！！！！！！！！！
                var para = [
                    
                    "companyCode": userModel.orgCode ?? "",
                    "orgCode": userModel.orgCode ?? "",
                    "empId": userModel.empNo ?? "",
                    "empName": userModel.empName  ?? "",
                    "id":self.deviceInfoModel?.deviceNo! ?? "",
                    "value": self.nowNum.text!,
                    "org": "002002",
                    "longitude": "",
                    "latitude": "",
                    "status": "2",
                    "time" : time,
                    "remark": self.remarksTextField.text ?? "",
                    "isMoreThanMax": isMoreThanMaxStr,
                    "thresholdMax": self.deviceInfoModel?.thresholdMax ?? "",
                    ] as [String : Any]
                
                if let file = self.meterImage64Str {
                    
                    para["file"] = file
                    
                }
                if let file2 = self.signImage64Str {
                    
                    para["file2"] = file2
                    
                }
                
                YJProgressHUD.showProgress("", in: self.view)
                
                NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getSubmitUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model :BaseModel = obj as! BaseModel
                    if model.statusCode == 800 {
                        
                        //清空页面本次提交数据
                        self.cleanPageMeterdData()
                        
                        ZNCustomAlertView.handleTip("提交成功", isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                    }else{
                        
                        
                        ZNCustomAlertView.handleTip("提交失败", isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                    }
                    
                    YJProgressHUD.hide()
                    
                }, failture: { (error) in
                    
                    
                    YJProgressHUD.hide()
                })
                
                
            }
            
            
            
        }else{
            
            
            ////本地存储数据
            UserCenter.shared.userInfo { (islogin, userModel) in
                
                let model = writeMeterModel()
                
                model.id = self.deviceInfoModel?.deviceNo
                model.deviceName = self.deviceInfoModel?.deviceName
                model.value = self.nowNum.text
                model.empId = userModel.empNo
                model.org = userModel.orgCode
                //                model.type = self.deviceInfoModel?.returnObj?.
                model.file = ""
                model.longitude = nil
                model.latitude = nil
                model.status = "2"
                model.time = time
                model.remark = self.remarksTextField.text
                model.isMoreThanMax = "0"
                
                if let num = Int(self.nowNum.text!) {
                    
                    if let max = self.deviceInfoModel?.thresholdMax {
                        
                        model.isMoreThanMax = max > num ? "0" : "1"
                        
                    }
                }
                
                model.thresholdMax = ""
                if let thresholdMax = self.deviceInfoModel?.thresholdMax{
                    
                    model.thresholdMax = thresholdMax.description
                }
                
                //存储本地
                RealmTool.insertMetersReadingData(by: [model])
                //下部展示
                self.meterArr.append(model)
                
                //清空页面本次提交数据
                self.cleanPageMeterdData()
            }
            
            self.tableView.reloadData()
            
        }
        
        
        
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
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
    
        if !((self.meterNo.text?.characters.count)! > 0) {
            
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
                    "id": self.meterNo.text]
                
                NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getVerificationUrl, modelClass: "getVerificationModel"
                    , response: { (object) in
                        
                        let model : getVerificationModel = object as! getVerificationModel
                        
                        if model.statusCode == 800 {
                            
                            if (Int((model.returnObj?.state)!) == 1) {
                                
                                self.getMeterInfo(deviceKey: self.meterNo.text!)
                                
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
            
            self.searchMeterWighKey(key: self.meterNo.text ?? " ")
        }
        
        
       
        
    }
    
    func cleanPageMeterdData() {
        
        self.meterNo.text = ""
        self.nowNum.text = ""
        self.nultL.text = "X倍率"
        self.lastTimeMeterNumL.text = "上次："
        self.remarksTextField.text = ""
        
        self.meterImg.image = UIImage.init(named: "相机")
        self.signImg.image = UIImage.init(named: "签字1")
        self.meterImage64Str = nil;
        self.signImage64Str = nil
        
        self.meterImgDeleteBtn.isHidden = true
        self.signImgDeleteBtn.isHidden = true

        self.nameL.text = "名称："
        self.meterNoL.text = "表号："
        self.addressL.text = "位置："
        self.projectNameL.text = "项目："
        
        self.deviceInfoModel = nil
        
    }
   
    // MARK: - cell代理
    
    func cellDeleteWithIndex(index: Int) {
        
        
        if let m : writeMeterModel = self.meterArr[index] as! writeMeterModel{
            
            RealmTool.deleteMetersReadingData(model: m )
            
            self.meterArr.remove(at: index)
        }

        
    }
    
     // MARK: - 签名代理
    
    func meterReadingedWithImg(img: UIImage) {
        
        
        let data = img.compress(withMaxLength: 1 * 1024 * 1024 / 8)
        print( Double((data?.count)!)/1024.0/1024.0)
        let imageBase64String = data!.base64EncodedString()
        
        
        self.signImg.image = img
        self.signImage64Str = imageBase64String
        
        self.signImgDeleteBtn.isHidden = false
        
    }
    
    // MARK: - 二维码 代理
    func ScanViewInfo(answer: String) {
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
               
                self.getMeterInfo(deviceKey: answer)

            }
            
            
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {

                self.searchMeterWighKey(key: answer)
            }
        }
        
    }
    
    
    func getMeterInfo(deviceKey:String) {
        
     
            
            UserCenter.shared.userInfo { (islogin, model) in
                
                let para = ["deviceKey":deviceKey,
                            "companyCode":model.companyCode,
                            "empNo":model.empNo,
                            "orgCode":model.orgCode,
                            ]
                
                NetworkService.networkGetrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeviceInfoUrl, modelClass: "getDeviceInfoModel", response: { (obj) in
                    
                    let model = obj as! getDeviceInfoModel
                    
                    if model.statusCode == 800 {
                        
                        self.deviceInfoModel = model.returnObj
                        
                        self.meterNo.text = model.returnObj?.deviceNo!
                        self.nultL.text = "X" + String(describing: (model.returnObj?.multiplyingPower)!)
                        self.lastTimeMeterNumL.text = "上次：" + String(describing: (model.returnObj?.lastNowValue)!)
                        
                        self.nameL.text = "名称：" + (model.returnObj?.deviceName)!
                        self.meterNoL.text = "表号：" + (model.returnObj?.deviceNo)!
                        self.addressL.text = "位置：" + (model.returnObj?.installSite)!
                        self.projectNameL.text = "项目：" + (model.returnObj?.stationName)!
                        
   
                        DispatchQueue.main.after(0.3) {
                            
                            self.nowNum.becomeFirstResponder()
                            
                        }
                        
                        
                    }
                    
                }) { (error) in
                    
                }
                
                
                
            }
        
        
        
    }
    
    func searchMeterWighKey(key:String) {
        
        
        let result = RealmTool.getMetersDic()
        if result.count > 0 {
            
            
            //无网络本地查询
            let arr :NSArray = RealmTool.getOneMetersDic(meterNo: key) as NSArray
            
            if (arr.count > 0) {
                
                
                let model:DownloadMeterDicReturnObjModel = arr.firstObject as! DownloadMeterDicReturnObjModel
                
                self.meterNo.text = model.id
                self.nultL.text = "X" + String(describing: (model.multiplyingPower)!)
                self.lastTimeMeterNumL.text = "上次：" + String(describing: (model.nowValue))
                
                self.nameL.text = "名称：" + (model.name)!
                self.meterNoL.text = "表号：" + (model.id)!
                self.addressL.text = "位置：" + (model.installSite)!
                self.projectNameL.text = "项目：" + (model.stationName)!
                
                
                self.deviceInfoModel = getDeviceInfoReturnObjModel()
                self.deviceInfoModel?.deviceNo = model.id ?? ""
                self.deviceInfoModel?.lastNowValue = model.nowValue as? Double
                self.deviceInfoModel?.deviceName = model.name ?? ""
                self.deviceInfoModel?.stationName = model.stationName ?? ""
                self.deviceInfoModel?.installSite = model.installSite ?? ""
                
                if let mul = model.multiplyingPower{
                    
                    self.deviceInfoModel?.multiplyingPower = Double(mul) ?? 0
                    
                }
                
                DispatchQueue.main.after(0.3) {
    
                        self.nowNum.becomeFirstResponder()
                        
                }
                
            }
            
        }else{
            
            ZNCustomAlertView.handleTip("请先下载字典表", isShowCancelBtn: false) { (issure) in
            }
            
        }
        

        
        
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
        
        self.meterImg.image = image
        self.meterImage64Str = imageBase64String
        self.meterImgDeleteBtn.isHidden = false
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text!
        
        let len = text.characters.count + string.count - range.length

        return len<=16
        
    }
    
    
    
    //MARK: -  其他
    
    func checkCameraPermission() -> Bool{
        let mediaType = AVMediaType.video
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch authorizationStatus {
        case .notDetermined:  //用户尚未做出选择
            return false
        case .authorized:  //已授权
            return true
        case .denied:  //用户拒绝
            ZNCustomAlertView.handleTip("请允许系统访问摄像机", isShowCancelBtn: false, completion: { (sure) in
                
            })
            return false
        case .restricted:  //家长控制
            return false
        }
    }
    
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="MM-dd HH:mm"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
    }
}
