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

class readingVC: UITableViewController,ScanViewControllerDelegate,UIGestureRecognizerDelegate,meterReadingSignVCDelegate {

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
    
    var meterArr = [AnyObject]()  //抄表数据
    
    var deviceInfoModel : getDeviceInfoModel?   //表设备数据
    
    var meterImage : UIImage?
    var signImage : UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "抄表"

//        self.meterImgDeleteBtn.isHidden = true
//        self.signImgDeleteBtn.isHidden = true
        
        
        //测试
        let model = writeMeterModel()
        model.remark = "12313213"
        //存储本地
        RealmTool.insertMetersReadingData(by: [model])
        
        
        
        
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
        self.meterImg.addGestureRecognizer(tap1)
        
        self.tableView.register(UINib.init(nibName: NSStringFromClass(ReadingVCTableviewCell.self), bundle: nil), forCellReuseIdentifier: ReadingVCTableviewCell_id)
        
 
    }
    
    @objc func tapPickImgView(action:UITapGestureRecognizer) -> Void {
        
        print("照相")
        if self.meterImg == nil {
            
            //拍照
            
        }else{
            
            //查看
            
        }
        
    }
    
    @objc func tapSignImgView(action:UITapGestureRecognizer) -> Void {
        
        print("签名")
        
        if ((self.nowNum.text)!.characters.count > 0) {
            
            if self.signImage == nil {
                
                //签名
                let vc = meterReadingSignVC()
                vc.signDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
                //查看
                
                
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

            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 2 || indexPath.section == 1){
            
            return 50
        }
        
        return 310
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view;
    }

    
    // MARK: - 本控制器方法
    
    
    @IBAction func deletePickImg(_ sender: UIButton) {
        
    }
    
    
    @IBAction func deleteSignImg(_ sender: UIButton) {
        
        self.signImg.image = UIImage.init(named: "签字1")
        self.signImage = nil
        self.signImgDeleteBtn.isHidden = true
        
    }
    
    
    func toPickImg() {
        
        
        
    }

    func toSignImg() {
        
        
        
    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            
            
        }else{
            
            
            UserCenter.shared.userInfo { (islogin, userModel) in
                
                let model = writeMeterModel()
                model.id = self.deviceInfoModel?.returnObj?.deviceNo
                model.value = self.nowNum.text
                model.empId = userModel.empNo
                model.org = userModel.orgCode
//                model.type = self.deviceInfoModel?.returnObj?.
                model.file = ""
                model.longitude = nil
                model.latitude = nil
                model.status = "2"
                model.time = ""
                model.remark = self.remarksTextField.text
                
                if let num = Int(self.nowNum.text!) {
                    
                    model.isMoreThanMax = ( self.deviceInfoModel?.returnObj?.thresholdMax!)! > num ? "0" : "1"
                }
                
                model.thresholdMax = String(describing: self.deviceInfoModel?.returnObj?.thresholdMax!)
                
                //存储本地
                RealmTool.insertMetersReadingData(by: [model])
            }
            
          
            
            
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
    
        
        let para = ["id": self.meterNo.text]
        
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
                }
                
                
        }) { (error) in
        
            
        }
        
        
    }
     // MARK: - 签名代理
    
    func meterReadingedWithImg(img: UIImage) {
        
        self.signImg.image = img
        self.signImage = img
        
        self.meterImgDeleteBtn.isHidden = false
        
    }
    
    // MARK: - 二维码 代理
    func ScanViewInfo(answer: String) {
        
        self.getMeterInfo(deviceKey: answer)
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
                    
                    self.nultL.text = "X" + String(describing: (model.returnObj?.multiplyingPower)!)
                    self.lastTimeMeterNumL.text = "上次：" + String(describing: (model.returnObj?.lastNowValue)!)
                    
                    self.nameL.text = "名称：" + (model.returnObj?.deviceName)!
                    self.meterNoL.text = "表号：" + (model.returnObj?.deviceNo)!
                    self.addressL.text = "位置：" + (model.returnObj?.installSite)!
                    self.projectNameL.text = "项目：" + (model.returnObj?.stationName)!
                    
                }
                
            }) { (error) in
                
            }
            
            
            
        }
        
        
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
    
    
    
    
   
}
