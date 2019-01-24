//
//  orderDetailVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/10.
//  Copyright © 2019年 Chen. All rights reserved.
//

enum orderDetailType : Int {
    
    case repair = 0,repairing,repaired,waitPay
}


import UIKit

class orderDetailVC: UITableViewController {

    //订单号
    var orderNo = ""
    var repairType : orderDetailType = orderDetailType.repair
    
    //获取的数据
    var model = WorkOrderDetailModel()
    
    @IBOutlet weak var sureBtn: UIButton!
    
    
    @IBOutlet weak var titleL: UILabel!
//    @IBOutlet weak var longTimeL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var orderNoL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var telL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var telBtn: UIButton!
    
    @IBAction func telBtnClick(_ sender: Any) {
        
        let globalQueue = DispatchQueue.global()
        globalQueue.async {
            UIApplication.shared.openURL(URL(string: "telprompt://" + self.telL.text! )!)
        }
        
    }
    
    //MARK: - 报修内容
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var repairContentL: UILabel!
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    
    
    @IBOutlet weak var repairContentViewH: NSLayoutConstraint!
    @IBOutlet weak var repairContentView: UIView!
    @IBOutlet weak var repairImgContentView: UIView!
    @IBOutlet weak var repairImgViewH: NSLayoutConstraint!
    
    //MARK: - 现场a拍摄
    @IBOutlet weak var sceneTimeL: UILabel!
    
    @IBOutlet weak var sceneImg1: UIImageView!
    @IBOutlet weak var sceneImg2: UIImageView!
    @IBOutlet weak var sceneImg3: UIImageView!
    
    
    
    
    
    //MARK: - 维修内容
    @IBOutlet weak var repairedDateL: UILabel!
    
    
    @IBOutlet weak var repairedContentL: UILabel!
    
    @IBOutlet weak var repairedImg1: UIImageView!
    @IBOutlet weak var repairedImg2: UIImageView!
    @IBOutlet weak var repairedImg3: UIImageView!
    
    @IBOutlet weak var repairedLContentView: UIView!
    @IBOutlet weak var repairedLContentH: NSLayoutConstraint!
    
    @IBOutlet weak var repairedImgContent: UIView!
    @IBOutlet weak var repairedImgContentH: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var fittingsContentViewH: NSLayoutConstraint!
    @IBOutlet weak var fittingSContentView: UIView!
    
    @IBOutlet weak var moneyL: UILabel!
    
    @IBOutlet weak var repairManL: UILabel!
    @IBOutlet weak var signImg: UIImageView!
    
    
    @IBOutlet weak var distanceL: UILabel!
    @IBOutlet weak var distanceContentView: UIView!
    
    //MARK: - 完成按钮
    @IBAction func completeBtn(_ sender: UIButton) {
        
        
        if self.repairType == orderDetailType.repair {
            
            let vc = toTheSceneVC()
            vc.orderNo = self.orderNo
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if self.repairType == orderDetailType.repairing {
            
            let vc = makeSureOrderVC.getVC()
            vc.orderNo = self.orderNo
            vc.workClass = self.model.returnObj?.workclass ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if self.repairType == orderDetailType.waitPay {
            
            let vc = PayVC()
            vc.orderNo = self.model.returnObj?.orderno ?? ""
            vc.money = self.moneyL.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)

            
        }
        
    }
    
    var repairImgArr = [UIImageView]()
    var repairSceneImgArr = [UIImageView]()
    var repairedImgArr = [UIImageView]()

    
    
    class func getOrderDetailVC() ->  orderDetailVC {
        
        let sb = UIStoryboard(name: "orderDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "orderDetailVC") as! orderDetailVC
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单详情"
        
        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)

        if self.repairType == orderDetailType.repair {
            
            self.sureBtn.setTitle("到现场", for: UIControl.State.normal)
            
        }else if self.repairType == orderDetailType.repairing {
            
            self.sureBtn.setTitle("去完成", for: UIControl.State.normal)

        }else if self.repairType == orderDetailType.waitPay {
            
            self.sureBtn.setTitle("待支付", for: UIControl.State.normal)

        }
        
        
         repairImgArr = [contentImg1,contentImg2,contentImg3]
         repairSceneImgArr = [sceneImg1,sceneImg2,sceneImg3]
         repairedImgArr = [repairedImg1,repairedImg2,repairedImg3]
        
        let footer = UIView()
        footer.height = 1
        self.tableView.tableFooterView = footer
        
        // 维修记录
        let backButton = UIButton(type: .custom)
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

        self.getdata()
        
    }
    
    //MARK: - 维修记录
    @objc func toList() {
        
        let vc = RepairRecordsVC()
        vc.orderNo = self.orderNo
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //MARK: - 获取数据
    func getdata() {
        
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = ["code": "1",
                        "id":self.orderNo,
                        "companyCode":model.companyCode,
                        "empId":model.empNo,
                        "empName":model.empName,
                        "orgCode":model.orgCode,
                        ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getDetailsUrl, modelClass: "WorkOrderDetailModel", response: { (obj) in
                
                let model : WorkOrderDetailModel = obj as! WorkOrderDetailModel
                
                if model.statusCode == 800{
                    
                    self.model = model
                    
                    self.titleL.text = (model.returnObj?.configname ?? "") + " | " + (model.returnObj?.repairsdesc ?? "")
                    self.dateL.text = self.timeStampToString(timeStamp: model.returnObj?.date ?? "")
                    
                    self.orderNoL.text = self.orderNo
                    self.nameL.text = model.returnObj?.contactman ?? ""
                    self.telL.text = model.returnObj?.tel ?? ""
                    self.addressL.text = model.returnObj?.address ?? ""
                    
                    self.status1.text = model.returnObj?.status ?? ""
                    self.status2.text = model.returnObj?.urgency ?? ""
                
                    if let content = model.returnObj?.repairsdesc {
                        
                        if model.returnObj?.repairsdesc?.characters.count ?? 0 > 0 {
                            
                            self.repairContentL.text = model.returnObj?.repairsdesc ?? ""
                            self.repairContentViewH.constant =  CGFloat(model.returnObj?.repairsdescHeight ?? 0)
                            
                        }
                        
                    }else {
                        
                        self.repairContentView.isHidden = true
                        self.repairContentViewH.constant = 0
                        
                    }
                    
                    if model.returnObj?.arr?.count ?? 0 > 0{
                        
                        for a in  0..<model.returnObj!.arr!.count {
                            
                            let imageVeiw = self.repairImgArr[a]
                            imageVeiw.kf.setImage(with: URL.init(string:model.returnObj!.arr![a]), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in
                                
                            }, completionHandler: { (img) in
                                
                            })

                        }
                        
                        self.repairImgViewH.constant = (ScreenW - 60)/3 + 30;

                        
                    }else{
                        
                        self.repairImgContentView.isHidden = true
                        self.repairImgViewH.constant = 0;
                        
                    }
                    
                 // ---
                    self.sceneTimeL.text = self.timeStampToString(timeStamp: model.returnObj?.arrdate ?? "")
                    
                    
                    if model.returnObj?.are?.count ?? 0 > 0{
                        
                        for a in  0..<model.returnObj!.are!.count {
                            
                            let imageVeiw = self.repairSceneImgArr[a]
                            imageVeiw.kf.setImage(with: URL.init(string:model.returnObj!.are![a]), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in
                                
                            }, completionHandler: { (img) in
                                
                            })
                            
                        }
                        
                    }else{
                        
                        
                    }
                    
                    // ----
                    self.repairedDateL.text = self.timeStampToString(timeStamp: model.returnObj?.dealdate ?? "")
                    
                    if let content = model.returnObj?.dealdesc {
                        
                        if content.characters.count > 0 {
                            
                            self.repairedContentL.text = content
                            self.repairContentViewH.constant =  CGFloat(model.returnObj?.repairsdescHeight ?? 0)

                        }
                        
                    }else {
                        
                        self.repairedLContentView.isHidden = true
                        self.repairedLContentH.constant = 0
                        
                    }
                    
                    if model.returnObj?.art?.count ?? 0 > 0{
                        
                        for a in  0..<model.returnObj!.art!.count {
                            
                            let imageVeiw = self.repairedImgArr[a]
                            imageVeiw.kf.setImage(with: URL.init(string:model.returnObj!.art![a]), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in
                                
                            }, completionHandler: { (img) in
                                
                            })
                            
                        }
                        
                        self.repairedImgContentH.constant = (ScreenW - 60)/3 + 30;

                        
                    }else{
                        
                        self.repairedImgContent.isHidden = true
                        self.repairedImgContentH.constant = 0;
                        
                    }
                    
                    //MARK: - 配件
                    
                    if let arr = model.returnObj?.mapArr {
                        
                        if arr.count > 0 {
                            
                            for a in 0..<arr.count {
                                
                                let m : WorkOrderDetailMapModel = arr[a]
                                
                                let view : orderDetailFittingsView = Bundle.main.loadNibNamed("orderDetailFittingsView", owner: nil, options: nil)?.first as! orderDetailFittingsView
                                view.nameL.text = m.name ?? ""
                                view.onepriceL.text = String(format: "¥%.2f", m.price ?? 0)
                                view.numL.text = "x" + Int(m.count ?? 0).description
                                
                                self.fittingSContentView.addSubview(view)
                                view.snp.makeConstraints({ (make) in
                                    
                                    
                                    make.top.equalTo(self.fittingSContentView).offset(a * 35)
                                    make.left.right.equalTo(self.fittingSContentView).offset(0)
                                    make.height.equalTo(35)
            
                                })
                                
                                
                            }
                            self.fittingsContentViewH.constant = CGFloat(arr.count * 35)
                            
                        }else{
                            
                            self.fittingsContentViewH.constant = 0
                            self.fittingSContentView.isHidden = true
                        }
                        
                    }
                    
                    
                    self.moneyL.text = String(format: "¥%.2f", model.returnObj?.total ?? 0)
                    self.repairManL.text = model.returnObj?.contactman ?? ""
                    
                    self.signImg.kf.setImage(with: URL.init(string:model.returnObj!.ast ?? ""), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in

                    }, completionHandler: { (img) in

                    })
                    
                }
                
                self.tableView.reloadData()
                
            }, failture: { (error) in
                
                
            })
            
            
            
        }
        
        
    }
    
    //MARK: - tableview
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        <#code#>
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.repairType == orderDetailType.repair {
            
            if section < 2 || section == 7{
                
                return 1
            }else{
                
                return 0
            }
            
        }else if self.repairType == orderDetailType.repairing {
            
            if section < 4 || section == 7{
                
                return 1
            }else{
                
                return 0
            }
            
        }else if self.repairType == orderDetailType.repaired {
            
            if section == 7{
                
                return 0
            }
            return 1
        }else if self.repairType == orderDetailType.waitPay {
            
            if section == 6{
                
                return 0
            }
            return 1
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        switch indexPath.section {
        case 1: return CGFloat(self.model.returnObj?.repairContentCellHeight ?? 0)
        case 3: return (ScreenW - 60)/3 + 30;
            case 5: return CGFloat(self.model.returnObj?.dealedCellHeight ?? 0)
            case 6: return 100
            case 7: return 100

        default: return 50;
            
        }
        
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if self.repairType == orderDetailType.repair {
            
            if section > 2 {
                
                return 0;
            }
            
        }else if self.repairType == orderDetailType.repairing {
            
            if section > 4 {
                
                return 0;
            }
            
            
        }else if self.repairType == orderDetailType.waitPay {
            
            if section == 6 {
                
                return 0;
            }
            
            
        }
        return 10
    }
    
    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="YYYY-MM-dd HH:mm:ss"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
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
