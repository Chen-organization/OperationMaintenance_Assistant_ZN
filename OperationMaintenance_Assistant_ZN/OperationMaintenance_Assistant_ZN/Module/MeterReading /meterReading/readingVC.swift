//
//  readingVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/16.
//  Copyright © 2018年 Chen. All rights reserved.


import UIKit
import Photos
import Alamofire


class readingVC: UITableViewController,ScanViewControllerDelegate,UIGestureRecognizerDelegate,meterReadingSignVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ReadingVCTableviewCellDelegate,UITextFieldDelegate ,readingListVCDelegate{
    
    
    var recordListMeterNo = "" //统一抄表记录用的表号 不做它用

    @IBOutlet weak var meterNo: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var nowNum: UITextField!
    
    @IBOutlet weak var nultL: UILabel!  //倍率
    @IBOutlet weak var lastTimeMeterNumL: UILabel!
    
    //超量程
    @IBOutlet weak var overContentView: UIView!
    @IBOutlet weak var overBtn: UIButton!
    @IBOutlet weak var overL: UILabel!
    
    @IBOutlet weak var overContentViewH: NSLayoutConstraint!

    
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
    var beforMeterArr = [AnyObject]()  //之前下部展示 抄表数据

    
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
        
         self.nowNum.addTarget(self, action: #selector(nowNumChanged), for: UIControl.Event.editingChanged)
        
        
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

        
        //隐藏超量程
        self.hideOverMeter()
        self.overContentView.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       
        
    }
    
    func deleteRefresh() {
        
        if self.recordListMeterNo.characters.count > 0 {
            
//            DispatchQueue.main.after(0.3) {
            
                self.getRecordList(deviceNo: self.recordListMeterNo)
                
//            }
            
        }
        
    }
    
    //勾选最大量程
    @IBAction func selectMax(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        self.overL.isHidden = !sender.isSelected
        
    }
    
    
    //MARK: - toList
    @objc func toList() {
        
//        let list = UIStoryboard(name: "MeterReading", bundle: nil)
//            .instantiateViewController(withIdentifier: "readingListVC") as! readingListVC
        let vc = readingListVC()
        vc.Delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func nowNumChanged(){
    
        if self.nowNum.text?.characters.count == 0 {
        
            self.hideOverMeter()
            
        }else {
            
            if self.self.overBtn.isSelected == false{
                
                self.hideOverMeter()
            }
            
        }
    
    }
    
    @objc func meterNoChanged() {

//        if self.meterNo.text?.characters.count == 16 {
//
////            self.searchBtnClick(UIButton())
////
////            self.getRecordList(deviceNo: self.meterNo.text!)
//
//        }
        
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

                vc.meterName = self.deviceInfoModel?.deviceName ?? ""
                vc.lastTimeMeterNum = String(format:"%.2f", self.deviceInfoModel?.lastNowValue ?? 0)  + (self.deviceInfoModel?.measureUnit ?? "")
                vc.NowMeterNum = String(format:"%.2f",  Double(self.nowNum.text ?? "0") ?? 0 )  + (self.deviceInfoModel?.measureUnit ?? "")
                
                if (self.deviceInfoModel?.deviceNum?.characters.count ?? 0) > 0 {
                    
                    vc.meterNoStr = self.deviceInfoModel?.deviceNum ?? ""

                }else{
                    
                    vc.meterNoStr = self.deviceInfoModel?.deviceNo ?? ""

                }
                

                vc.num = ""

                if let now = self.nowNum.text{
                    
                    if let last = self.deviceInfoModel?.lastNowValue{
                        
                        if let nowNum = Double(now){
                            
                            
                            if nowNum >= last{
                                
                                //正常
                                let num = (nowNum - last) * (self.deviceInfoModel?.multiplyingPower ?? 1)
                                vc.num = String(format:"%.2f", num) + (self.deviceInfoModel?.measureUnit ?? "")
                                
                            }else{
                                
                                
                                if self.overContentView.isHidden == true{
                                    
                                    //提示
                                    ZNCustomAlertView.handleTip("输入表底数比上次小，请确认是否超出最大量程 ？", isShowCancelBtn: true) { (issure) in
                                        
                                        if issure{
                                            
                                            self.showOverMeter()
                                            
                                        }else{
                                            
                                            return;
                                        }
                                        
                                    }
                                    
                                    
                                    return
                                    
                                }else{
                                    
                                    //超量程
                                    
                                    let num = (nowNum + (Double(self.overL.text ?? "0") ?? 0) + 1)
                                    let num1 = num - (self.deviceInfoModel?.lastNowValue ?? 0)
                                    let mulNum = num1 * (self.deviceInfoModel?.multiplyingPower ?? 1)
                                    vc.num = String(format:"%.2f", mulNum) + (self.deviceInfoModel?.measureUnit ?? "")
                                    
                                }
                                
                                
                            
                                
                                
                            }
                            

                            

                            
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
            return self.meterArr.count + self.beforMeterArr.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            
            let cell:ReadingVCTableviewCell
                = tableView.dequeueReusableCell(withIdentifier: ReadingVCTableviewCell_id, for: indexPath) as! ReadingVCTableviewCell
            
            
            if indexPath.row >= self.meterArr.count {
                
                let model : readingListReturnObjModel = self.beforMeterArr[indexPath.row - self.meterArr.count] as! readingListReturnObjModel
                
                cell.nameL.text = model.deviceHisId ?? ""
                cell.value0.text = String(format:"%.2f", Double(model.nowValue ?? "0") ?? 0)
                cell.value1.text = self.timeStampToString(timeStamp: model.createDate ?? "")
                
                cell.index = indexPath.row
                
                //判断时间 一小时内最近能修改
                var candelete = false

                if Int(self.NowHourMilliStamp)! >= Int(model.createDate!)! {
                    
                    candelete = false
                }else{
                    
                    //最近一次
                    if indexPath.row == self.meterArr.count {
                        
                        candelete = true

                    }else{
                        
                        candelete = false

                    }
                    
                }
                
                cell.setTitleColor(isLocal: false)
                cell.setCanDelete(CanDelete: candelete)
                
                cell.cellDelegate = self
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                return cell
                
                
            }else{
                
                let model : writeMeterModel = self.meterArr[indexPath.row] as! writeMeterModel
                
                cell.nameL.text = model.deviceName ?? ""
//                cell.value0.text = model.value ?? ""
                cell.value1.text = self.timeStampToString(timeStamp: model.time ?? "")
                cell.value0.text = String(format:"%.2f", Double(model.value ?? "0") ?? 0)

                cell.index = indexPath.row
                
                cell.setTitleColor(isLocal: true)
                cell.setCanDelete(CanDelete: true)
                
                cell.cellDelegate = self
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                return cell
                
            }
            
           
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 2 || indexPath.section == 1){
            
            return 40
        }
        
        return self.overContentView.isHidden ? 360 : 405
    }
    
    
    //cell的缩进级别,动态静态cell必须重写,否则会造成崩溃
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        if(2 == indexPath.section){
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

    
    // MARK: - 显示超量程
    func showOverMeter() {
        
        
        //超量程界面
        self.overContentViewH.constant = 45
        self.overContentView.isHidden = false
        self.overBtn.isSelected = true
        self.overL.isHidden = false
        
        
        var nowMaxStr = ""
        
        let maxStr = Int(self.deviceInfoModel?.lastNowValue ?? 0).description
            
        for i in 0..<maxStr.count {
            
            print("a=\(i)");
            
            nowMaxStr.append("9")
            
        }
        
        self.overL.text = nowMaxStr
            
        
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    // MARK: - 隐藏超量程
    func hideOverMeter() {
        
        self.overContentViewH.constant = 0
        self.overContentView.isHidden = true
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        

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
        
        //判断是否是选择了超量程
        if self.overContentView.isHidden  {
            
            // 3 、 上次表底数比较
            var isRight = true
            
            if let num = Double(self.nowNum.text!) {
                
                if let last = self.deviceInfoModel?.lastNowValue {
                    
                    isRight =  num >= Double(last) ? true : false
                    
                }
            }
            
            if !isRight {
                
                ZNCustomAlertView.handleTip("输入表底数比上次小，请确认是否超出最大量程 ？", isShowCancelBtn: true) { (issure) in
                    
                    if issure{
                        
                        //                            self.saveData()
                        
                        self.showOverMeter()
                        
                     
                    }else{
                        
                        return;
                    }
                    
                }
            }else{
                
                
                // 2 、 数据确认 弹框确认
                ZNMakeSureView.handleTip(self.nowNum.text!, isShowCancelBtn: true) { (makeSure) in
                    
                    if makeSure {
                        
                        self.saveData()

                    }
                }
            }
            
            
        }else{
            
            //超量程
            //判断超量程是否勾选
            
            if self.overBtn.isSelected {
                
                // 数据确认 弹框确认
                ZNMakeSureView.handleTip(self.nowNum.text!, isShowCancelBtn: true) { (makeSure) in
                    
                    if makeSure {
                        
                        self.saveData()
                        
                    }
                }
                
            }else{
                
                ZNCustomAlertView.handleTip("请勾选确认选择框或重新输入表底数", isShowCancelBtn: false) { (sure) in
                    
                }
                
            }
            
          
        }
        
        

        
      
      
    }
    
    
    func saveData() {
        
        
        //校验表编号
        if self.deviceInfoModel?.deviceNo != (self.meterNo.text ?? "") {
            
            ZNCustomAlertView.handleTip("设备编号不存在，或字典表未下载", isShowCancelBtn: false) { (sure) in
                
            }
            return
        }
        
        
        let time = self.milliStamp
        print("对应的日期时间：\(time)")
        
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            
            //网络提交
            UserCenter.shared.userInfo { (islogin, userModel) in
                
                var isMoreThanMaxStr = "0"
                if let num = Int(self.nowNum.text!) {
                    
                    if let max = self.deviceInfoModel?.lastNowValue {
                        
                        isMoreThanMaxStr =  num >= Int(max) ? "0" : "1"
                        
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
                
                if self.overContentView.isHidden == false && self.overBtn.isSelected {
                    
                    para[ "thresholdMax"] = self.overL.text
                    
                }
                
                
                if let file = self.meterImage64Str {
                    
                    para["file"] = file
                    
                }
                if let file2 = self.signImage64Str {
                    
                    para["file2"] = file2
                    
                }
                
                YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
                
                NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getSubmitUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model :BaseModel = obj as! BaseModel
                    if model.statusCode == 800 {
                        
                        self.getRecordList(deviceNo:self.deviceInfoModel?.deviceNo ?? "")

                        
                        
                        self.hideOverMeter()
                        
                        ZNCustomAlertView.handleTip("提交成功", isShowCancelBtn: false, completion: { (issure) in
                            
                            if issure {
                                
                                //清空页面本次提交数据
                                self.cleanPageMeterdData()
                            }
                            
                        })
                    }else{
                        
                        

                    }
                    
                    YJProgressHUD.hide()
                    
                }, failture: { (error) in
                    
                    YJProgressHUD.hide()
                    
                    ZNCustomAlertView.handleTip("提交失败，是否存储到本地！", isShowCancelBtn: true, completion: { (issure) in
                        
                        if issure {
                            
                            
                            ////本地存储数据
                            self.saveDataToLocation()
                            
                        }
                        
                    })
                    
                    
                })
                
                
            }
            
            
            
        }else{
            
            ////本地存储数据
            self.saveDataToLocation()
            
        }
        
        
        
    }
    
    //MARK: - 本地存储数据
    func saveDataToLocation() {
        
        
        
        
        let time = self.milliStamp
        print("对应的日期时间：\(time)")
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let model = writeMeterModel()
            
            model.id = self.deviceInfoModel?.deviceNo
            model.deviceName = self.deviceInfoModel?.deviceName
            model.value = self.nowNum.text
            model.empId = userModel.empNo
            model.org = userModel.orgCode
            //                model.type = self.deviceInfoModel?.returnObj?.
            model.file = self.meterImage64Str ?? ""
            model.file2 = self.signImage64Str ?? ""
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
            
            ZNCustomAlertView.handleTip("离线数据提交成功", isShowCancelBtn: false, completion: { (issure) in
                
            })
            
            //清空页面本次提交数据
            self.cleanPageMeterdData()
        }
        
        
        let positon = IndexSet.init(integer: 2)
        self.tableView.reloadSections(positon, with: UITableView.RowAnimation.none)
        
        self.hideOverMeter()

        
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
        
        self.recordListMeterNo = self.meterNo.text!

        
        self.getMeterInfo(deviceKey: self.meterNo.text!)

//        self.getRecordList(deviceNo: self.meterNo.text!)

        
//        //无网络判断
//        let net = NetworkReachabilityManager()
//        if net?.isReachable ?? false {
//
//            UserCenter.shared.userInfo { (islogin, model) in
//
//                let para = [
//                    "companyCode":model.companyCode,
//                    "empNo":model.empNo,
//                    "orgCode":model.orgCode,
//                    "id": self.meterNo.text]
//
//                NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getVerificationUrl, modelClass: "getVerificationModel"
//                    , response: { (object) in
//
//                        let model : getVerificationModel = object as! getVerificationModel
//
//                        if model.statusCode == 800 {
//
//                            if (Int((model.returnObj?.state)!) == 1) {
//
//                                self.getMeterInfo(deviceKey: self.meterNo.text!)
//
//                                self.getRecordList(deviceNo: self.meterNo.text ?? "")
//
//
//                            }else{
//
//                                ZNCustomAlertView.handleTip("设备不存在", isShowCancelBtn: false, completion: { (isSure) in
//
//
//                                })
//                            }
//
//                        }else{
//
//                            ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (isSure) in
//
//                            })
//
//                        }
//
//
//                }) { (error) in
//
//
//                }
//
//
//
//            }
//
//
//
//        }else{
//
//            self.searchMeterWighKey(key: self.meterNo.text ?? " ")
//        }
        
        
       
        
    }
    
    func cleanPageMeterdData() {
        
        self.meterNo.text = ""
        self.nowNum.text = ""
        self.nultL.text = "X倍率"
        self.lastTimeMeterNumL.text = "上次:"
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
    
    func cellDeleteWithImgIndex(index: Int) {
        
        
        if index >= self.meterArr.count {
            
            //线上过得记录
            
            let model = self.beforMeterArr[index - self.meterArr.count] as? readingListReturnObjModel
            
            if let url = model?.photoUrl{
                
                //查看
                PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                    
                    let pbModel = PhotoModel()
                    pbModel.mid = 1
                    pbModel.image_HD_U = url
                    
                    return [pbModel]
                }
                
            }else{
                
                
                //查看
                PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                    
                    let pbModel = PhotoModel()
                    pbModel.mid = 1
                    pbModel.image = UIImage.init(named: "站位图")
                    
                    return [pbModel]
                }
                
            }
            
        }else{
            
            //本地
            if let m : writeMeterModel = self.meterArr[index] as? writeMeterModel{
                
                if m.file?.characters.count ?? 0 > 0 {
                    
                    let imageData = Data(base64Encoded: m.file ?? "")
                    

                    //查看
                    PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                        
                        let pbModel = PhotoModel()
                        pbModel.mid = 1
                        pbModel.image = UIImage(data: imageData!)
                        
                        return [pbModel]
                    }
                }else{
                    
                    //查看
                    PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                        
                        let pbModel = PhotoModel()
                        pbModel.mid = 1
                        pbModel.image = UIImage.init(named: "站位图")
                        
                        return [pbModel]
                    }
                    
                }
                
                
               
                
            }
        }
        
        
    }
    
    func cellDeleteWithIndex(index: Int) {

        
        if index >= self.meterArr.count {
            
            //删除已上传过得记录
            
            let model = self.beforMeterArr[index - self.meterArr.count] as? readingListReturnObjModel

            
            if let id = model?.id{
                
                ZNCustomAlertView.handleTip("是否确定删除此条抄表记录！", isShowCancelBtn: true) { (issure) in
                    
                    if issure{
                        
                        self.deleteOnlineData(key: id, arrIndex: index - self.meterArr.count)

                    }
                    
                }

            }
            
        }else{
            
            if let m : writeMeterModel = self.meterArr[index] as! writeMeterModel{
                
                RealmTool.deleteMetersReadingData(model: m )
                
                self.meterArr.remove(at: index)
            }
        }
        
        let positon = IndexSet.init(integer: 2)
        self.tableView.reloadSections(positon, with: UITableView.RowAnimation.none)
        
    }
    
    func deleteOnlineData(key:String , arrIndex:Int) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode":userModel.companyCode,
                "orgCode":userModel.orgCode,
                "empId":userModel.empNo,
                "empName":userModel.empName,
                "id":key,
            ]
            
            YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeleteUrl, modelClass: "BaseModel", response: { (obj) in
                
                YJProgressHUD.hide()

                let model : BaseModel = obj as! BaseModel
                
                if model.statusCode == 800 {
                    
                    DispatchQueue.main.after(0.3) {
                        
                        ZNCustomAlertView.handleTip("数据删除成功", isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                    }
                    
                    self.beforMeterArr.remove(at: arrIndex)

                    let positon = IndexSet.init(integer: 2)
                    self.tableView.reloadSections(positon, with: UITableView.RowAnimation.none)
                    

                    
                }else if model.statusCode == 900 {
                    
                    DispatchQueue.main.after(0.3) {
                        
                        ZNCustomAlertView.handleTip("删除失败，请刷新数据检查此条记录能否被删除！", isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                    }
                        
                }else{
                    
                    DispatchQueue.main.after(0.3) {
                        
                        ZNCustomAlertView.handleTip("删除失败", isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                    }
                }
                
                
            }, failture: { (error) in
                
                
                YJProgressHUD.hide()

            })
            
            
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
        
        self.recordListMeterNo = answer
        
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
                            "empName":model.empName,
                            "orgCode":model.orgCode,
                            ]
                
                NetworkService.networkGetrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDeviceInfoUrl, modelClass: "getDeviceInfoModel", response: { (obj) in
                    
                    let model = obj as! getDeviceInfoModel
                    
                    if model.statusCode == 800 {
                        
                        //清空数据
                        self.cleanPageMeterdData()
                        self.hideOverMeter()
                        
                        self.deviceInfoModel = model.returnObj
                        
//                        if model.returnObj?.deviceNum?.characters.count ?? 0 > 0{
//
//                            self.meterNo.text = model.returnObj?.deviceNum!
//
//                        }else{
                        
                            self.meterNo.text = model.returnObj?.deviceNo!

//                        }
                        
                        self.nultL.text = "X" + String(describing: (model.returnObj?.multiplyingPower)!)
                        self.lastTimeMeterNumL.text = "上次:" + String(format:"%.2f",(model.returnObj?.lastNowValue) ?? 0) + (model.returnObj?.measureUnit ?? "")
                        
                        self.nameL.text = "名称：" + (model.returnObj?.deviceName)!
                        
                        if model.returnObj?.deviceNum?.characters.count ?? 0 > 0{
                            
//                            self.meterNo.text = model.returnObj?.deviceNum!
                            
                            self.meterNoL.text = "表号：" + (model.returnObj?.deviceNum ?? "")
                            
                        }else{
                            
//                            self.meterNo.text = model.returnObj?.deviceNo!
                            self.meterNoL.text = "表号：" + (model.returnObj?.deviceNo ?? "")
                        }
                        
                        
                        self.addressL.text = "位置：" + (model.returnObj?.installSite)!
                        self.projectNameL.text = "项目：" + (model.returnObj?.stationName)!
                        
                        //获取记录
                        self.getRecordList(deviceNo: model.returnObj?.deviceNo ?? "")
   
                        DispatchQueue.main.after(0.3) {
                            
                            self.nowNum.becomeFirstResponder()
                            
                        }
                        
                    }else{
                        
                        DispatchQueue.main.after(0.3) {
                            
                            ZNCustomAlertView.handleTip("设备不存在", isShowCancelBtn: false, completion: { (isSure) in
                                
                            })
                            
                            //清空页面本次数据
                            self.cleanPageMeterdData()
                            
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
                
                //清空数据
                self.cleanPageMeterdData()
                self.hideOverMeter()
                
                
                let model:DownloadMeterDicReturnObjModel = arr.firstObject as! DownloadMeterDicReturnObjModel
                
                self.meterNo.text = model.id
                
                if let deviceNum = model.deviceNum {
                    
                    if deviceNum.characters.count > 0 {
                        
//                        self.meterNo.text = deviceNum
                        self.meterNoL.text = "表号：" + deviceNum


                    }else{
                        
//                        self.meterNo.text = model.id
                        self.meterNoL.text = "表号：" + (model.id ?? "")

                    }
                    
                }else{
                    
//                    self.meterNo.text = model.id
                    self.meterNoL.text = "表号：" + (model.id ?? "")


                }
                
                self.nultL.text = "X" + String(describing: (model.multiplyingPower)!)
                self.lastTimeMeterNumL.text = "上次:" + String(format:"%.2f",Double(model.nowValue))  + (model.measureUnit ?? "")
                
                self.nameL.text = "名称：" + (model.name)!
                self.addressL.text = "位置：" + (model.installSite)!
                self.projectNameL.text = "项目：" + (model.stationName)!
                
                
                self.deviceInfoModel = getDeviceInfoReturnObjModel()
                self.deviceInfoModel?.deviceNo = model.id ?? ""
                self.deviceInfoModel?.lastNowValue = model.nowValue as? Double
                self.deviceInfoModel?.deviceName = model.name ?? ""
                self.deviceInfoModel?.stationName = model.stationName ?? ""
                self.deviceInfoModel?.installSite = model.installSite ?? ""
                self.deviceInfoModel?.measureUnit = model.measureUnit ?? ""
                self.deviceInfoModel?.deviceNum = model.deviceNum ?? ""

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
    //MARK: -  获抄表取表数据
    func getRecordList(deviceNo:String) {
        
        self.meterArr = RealmTool.getOneMeterReadingDataWithNo(meterNo: deviceNo)
        
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
            
                "companyCode":userModel.companyCode,
                "orgCode":userModel.orgCode,
                "empId":userModel.empNo,
                "empName":userModel.empName,
                "code":deviceNo,
                
            ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDisplayUrl, modelClass: "readingListModel", response: { (obj) in
                
                let model :readingListModel = obj as! readingListModel

                if model.statusCode == 800 {
                    
                    self.beforMeterArr = model.returnObj ?? []
                    
                    let positon = IndexSet.init(integer: 2)
                    self.tableView.reloadSections(positon, with: UITableView.RowAnimation.none)
                }
                
                
            }, failture: { (error) in
                
                
                
            })
            
            
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
        
        
        picker.dismiss(animated: true, completion: nil)

        
        let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
        print( Double((data?.count)!)/1024.0/1024.0)
        let imageBase64String = data!.base64EncodedString()
        
        self.meterImg.image = image
        self.meterImage64Str = imageBase64String
        self.meterImgDeleteBtn.isHidden = false
        
        
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
    
    
    /// 获取当前整点 毫秒级 时间戳 - 13位
    var NowHourMilliStamp : String {
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        
        let hourDate = timeFormatter.date(from: strNowTime)
        
        let timeInterval: TimeInterval = (hourDate?.timeIntervalSince1970)!
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 获取当前时间 毫秒级 时间戳 - 13位
    var milliStamp : String {
        
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
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
            dfmatter.dateFormat="MM-dd HH:mm:ss"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
    }
}
