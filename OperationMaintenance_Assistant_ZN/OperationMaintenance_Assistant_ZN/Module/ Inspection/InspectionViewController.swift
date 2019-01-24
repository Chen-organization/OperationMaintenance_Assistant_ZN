//
//  InspectionViewController.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2019/1/23.
//  Copyright © 2019 Chen. All rights reserved.
//

import UIKit
import HandyJSON

class InspectionViewController:  UIViewController,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextViewDelegate ,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate  ,BMKLocationAuthDelegate ,BMKLocationManagerDelegate {
    
    var locationManager : BMKLocationManager!
    var completionBlock : BMKLocatingCompletionBlock!
    
    var location : CLLocationCoordinate2D?
    var address : String?


    
    @IBOutlet weak var textView: UIPlaceHolderTextView!
    
    var nowPage = 1
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    @IBOutlet weak var contentImg4: UIImageView!
    
    @IBOutlet weak var deleteBtn1: UIButton!
    @IBOutlet weak var deleteBtn2: UIButton!
    @IBOutlet weak var deleteBtn3: UIButton!
    @IBOutlet weak var deleteBtn4: UIButton!
    
    @IBOutlet weak var topContentView: UIView!
    
    
    var ImgArr = [UIImageView]()
    var selectedImgArr = [UIImage]()
    
    var deleteBtnArr = [UIButton]()
    
    @IBOutlet weak var speakBtn: UIButton!
    
    
    @IBAction func speakBtnClick(_ sender: UIButton) {
        
        
        
    }
    
    @IBOutlet weak var commitBtn: UIButton!
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        
        if(self.location == nil){
            
            ZNCustomAlertView.handleTip("定位失败,查看设置中定位是否打开", isShowCancelBtn: false, completion: { (isSure) in
                
            })
            
            return
        }
        
        if !(self.textView.text.characters.count > 0) {
            
            YJProgressHUD.showMessage("请填写巡检内容", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
            return
        }
        
        
        YJProgressHUD.showProgress("", in: UIApplication.shared.delegate?.window!)

        UserCenter.shared.userInfo { (islogin, user) in
            
         
            var ImgStrArr = [String]()
            
            for i in 0..<self.selectedImgArr.count {
                //MARK: ---
                let image = self.selectedImgArr[i]
                
                let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
                
                // NSData 转换为 Base64编码的字符串
                let base64String:String = data!.base64EncodedString()//
                ImgStrArr.append((base64String))
            }
            
           
            var para = String()
            
            for str in ImgStrArr{
                
                if para.characters.count > 0{
                    
                    para = para + "&"
                }
                para = para + "File=" + str
                
            }
            

            var URL = getInspectionSubmissionURL + "?companyCode="
            
            URL = URL + user.companyCode! + "&empName="
            
            URL = URL + user.empName! + "&empNo="
            
            URL = URL + user.empNo! + "&orgCode="
            
            URL = URL + user.orgCode! + "&date="
            
            URL = URL + self.textView.text + "&address="
            
            URL = URL + (self.address ?? "")
                
            self.post(para: para, url: URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")

        }
        
        
        
    }
    
    var tableView = BasePullTableView()
    
    var dataArray = [PatrolListReturnObjModel]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "巡检"
        
        self.edgesForExtendedLayout = []
        
        
        self.view.addSubview(self.tableView);
        tableView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.topContentView.snp.bottom).offset(0);
            make.left.right.bottom.equalTo(self.view).offset(0)
        }
//        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.tableView.isLoadMoreEnable = true

        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = RGBCOLOR(r: 240, 240, 240)
        
         self.tableView.register(UINib.init(nibName: "PatrolListCell", bundle: nil), forCellReuseIdentifier: PatrolListCell_id)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.pullDelegate = self
        
        self.textView.placeholder = "请描述状况，限300字..."
        self.textView.placeholderColor = RGBCOLOR(r: 153, 153, 153)
        self.textView.delegate = self
        self.textView.tag = 4000
        self.textView.tintColor = self.view.tintColor
        self.textView.text = ""
        
        self.tableView.mj_footer.beginLoading()
        
        
        ImgArr = [contentImg1,contentImg2,contentImg3,contentImg4]
        deleteBtnArr = [deleteBtn1,deleteBtn2,deleteBtn3,deleteBtn4]
        
        
        for i in 0..<ImgArr.count {
            
            
            let img = ImgArr[i]
            img.tag = i
            
            if i == 0 {
                
                img.isHidden = false
            }else{
                
                img.isHidden = true
                
            }
            
            
            let tap1:UITapGestureRecognizer = UITapGestureRecognizer.init()
            tap1.numberOfTapsRequired = 1 //轻点次数
            tap1.numberOfTouchesRequired = 1 //手指个数
            tap1.delegate = self
            tap1.addTarget(self, action: #selector(tapImgView(action:)))
            img.addGestureRecognizer(tap1)
            
        }
        
        for i in 0..<deleteBtnArr.count {
            
            let btn = deleteBtnArr[i]
            
            btn.tag = i;
            
            btn.addTarget(self, action: #selector(deleteImg(btn:)), for: UIControl.Event.touchUpInside)
            
        }
        
        self.refreshImgs()
        
        self.getDataWithPage(page: 1)
        
        
        
        BMKLocationAuth.sharedInstance().checkPermision(withKey: "hblWV9xsl67jWi4uuTDup58EU0QKWnlb", authDelegate: self)
        
        locationManager = BMKLocationManager.init()
        locationManager.delegate = self as! BMKLocationManagerDelegate
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        
        locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //设置应用位置类型
        locationManager.activityType = CLActivityType.other;
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false;
        //设置是否允许后台定位
        locationManager.allowsBackgroundLocationUpdates = false;
        //设置位置获取超时时间
        locationManager.locationTimeout = 5;
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 5;
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        locationManager.requestLocation(withReGeocode: true, withNetworkState: false) { (location, netWorkState, error) in
            
            if (location == nil){
                
                ZNCustomAlertView.handleTip("定位失败,查看设置中定位是否打开", isShowCancelBtn: false, completion: { (isSure) in
                    
                    let url = URL(string: UIApplication.openSettingsURLString)
                    
                    if UIApplication.shared.canOpenURL(url!){
                        
                        UIApplication.shared.openURL(url!)
                        
                    }
                    
                })
                self.address = ""
                return
            }
            
            let loc = location as! BMKLocation
            
            if (loc.location != nil) {//得到定位信息
                
                self.location = loc.location?.coordinate
                
            }else{
                
                return;
            }
            
            if (loc.rgcData != nil) {
                
                var str : String! = ""
                
                if  let a = loc.rgcData?.city, let b = loc.rgcData?.district{
                    
                    str = (loc.rgcData?.city)! + (loc.rgcData?.district)!
                    
                }
                
                
                if let street = loc.rgcData?.street {
                    
                    str = str + street
                }
                
                if let streetNum = loc.rgcData?.streetNumber {
                    
                    str = str + streetNum
                }
                
//                if let arr = loc.rgcData?.poiList {
//
//                    if  let poi : BMKLocationPoi = loc.rgcData?.poiList.first {
//
//                        str = str + poi.name
//                    }
//                }
                
                
                self.address = str
                
             
                
            }
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func getDataWithPage(page:Int) {
        
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode":userModel.companyCode,
                "orgCode":userModel.orgCode,
                "empNo":userModel.empNo,
                "empName":userModel.empName,
                "start":page.description,
                "ord":"10"
                
            ]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getPatrolListURL, modelClass: "PatrolListModel", response: { (obj) in
                
                let model:PatrolListModel = obj as! PatrolListModel
                
                if model.statusCode == 800 {
                    
                    self.nowPage = page
                    
                    if page == 1 {
                        
                        self.dataArray = model.returnObj ?? []
 
                    }else{
                        
                        self.dataArray = self.dataArray + (model.returnObj ?? [])
                    }
                    
                    self.tableView.reloadData()
                    
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    
                }
                
                
            }) { (error) in
                
                
                
            }
            
        }
        
        
        
        
    }
    
    
    //MARK: - 手势
    @objc func tapImgView(action:UIGestureRecognizer)  {
        
        if action.view!.tag == self.selectedImgArr.count  {
            
            if action.view!.tag == 3 {
                
                YJProgressHUD.showMessage("仅限添加三张图片", in: UIApplication.shared.keyWindow, afterDelayTime: Int(1.5))
                
                return
            }
            
            //添加图片
            let actionSheet=UIActionSheet()
            
            actionSheet.addButton(withTitle:"取消" )//addButtonWithTitle("取消")
            actionSheet.addButton(withTitle:"拍照" )//addButtonWithTitle("动作1")
            actionSheet.addButton(withTitle:"从相册选择" )//addButtonWithTitle("动作2")
            actionSheet.cancelButtonIndex=0
            actionSheet.delegate=self
            actionSheet.show(in: self.view)
            
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
    
    
    @objc func deleteImg(btn:UIButton) {
        
        self.selectedImgArr.remove(at: btn.tag)
        
        self.refreshImgs()
    }
    
    
    func refreshImgs() {
        
        for i in 0..<ImgArr.count {
            
            let img = ImgArr[i]
            let btn = deleteBtnArr[i]
            
            img.tag = i
            
            if i <= self.selectedImgArr.count {
                
                img.isHidden = false
                
                if i < self.selectedImgArr.count {
                    
                    img.image = self.selectedImgArr[i]
                    
                    btn.isHidden = false
                    
                    
                }else{
                    
                    img.image = UIImage.init(named: "相机")
                    
                    btn.isHidden = true
                }
                
            }else{
                
                img.isHidden = true
                btn.isHidden = true
                
            }
            
        }
        
        
    }
    
    
    
    //MARK: - UIActionSheet
    
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
        
        DispatchQueue.main.after(0.1) {
            
            let pickerVC = UIImagePickerController()
            pickerVC.view.backgroundColor = UIColor.white
            pickerVC.delegate = self
            pickerVC.allowsEditing = false
            pickerVC.sourceType = sourceType
            self.present(pickerVC, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    
    
    //MARK : - 选择图片
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.selectedImgArr.append(image)
        
        self.refreshImgs()
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - tableview
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let view = UIView()
    //        view.backgroundColor = UIColor.clear
    //
    //        return view
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //        if section == 2 || section == 3{
    //
    //            return 0
    //        }
    //        return 10
    //    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PatrolListCell = tableView.dequeueReusableCell(withIdentifier: PatrolListCell_id, for: indexPath) as! PatrolListCell
        
        let model : PatrolListReturnObjModel = self.dataArray[indexPath.row]
  
        cell.contentL.text = self.timeStampToString(timeStamp:(model.createDate ?? "")) + " " + (model.patrolContent ?? "")
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 38
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArray[indexPath.row]
        
        let vc = InspectionDetailVCTableViewController.getVC()
        vc.patrolId = model.patrolId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
         self.getDataWithPage(page: 1)
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        self.getDataWithPage(page: self.nowPage + 1)
        
    }
    
    
    func post(para:String , url:String) {
        
        let session = URLSession(configuration: .default)
        // 设置URL(该地址不可用，写你自己的服务器地址)
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = ["name":"111111","password":"2222222"]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        
        
        
        let customAllowedSet =  NSCharacterSet(charactersIn:"+").inverted
        let paraUtf8String = para.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        
        
        request.httpBody = paraUtf8String?.data(using: .utf8)
        // 后面不解释了，和GET的注释一样
        let task = session.dataTask(with: request) {(data, response, error) in
            do{
                //              将二进制数据转换为字典对象
                if let jsonObj:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                {
                    print(jsonObj)
                    
                    //主线程
                    DispatchQueue.main.async{
                        
                        YJProgressHUD.hide()
                        
                        let model : BaseModel = (swiftClassFromString(className: "BaseModel") as! HandyJSON.Type ).deserialize(from: jsonObj as? NSDictionary) as! BaseModel
                        
                        if model.statusCode == 800 {
                            
                           //刷新页面
                            self.textView.text = ""
                            self.selectedImgArr.removeAll()
                            self.refreshImgs()
                            
                            self.getDataWithPage(page: 1)
                            
                        }else{
                            
                            YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 1)
                        }
                        
                    }
                }
            } catch{
                print("Error.")
                DispatchQueue.main.async{
                    
                    YJProgressHUD.hide()
                    
                }
                
            }
        }
        task.resume()
        
    }
    
    //MARK: - TEXTVIEW
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {  // textView点击完成隐藏键盘
            
            textView.resignFirstResponder()
            
            return false
            
        }else{
            
            if textView.textInputMode?.primaryLanguage == "emoji" || ((textView.textInputMode?.primaryLanguage) == nil) {
                YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                return false
            }
            
            if NSString.isNineKeyBoard(text) {
                
                
                return true
            }else{
                
                let str : NSString = text as NSString
                
                if ( str.containEmoji()){
                    YJProgressHUD.showMessage("请输入正确字符", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                    return false
                }
            }
            
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        if textView.text.characters.count > 300 {
            
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
            
            //
            if textNum! > 300 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 300)
                let str = textContent?.substring(to: index!)
                textView.text = str
            }
        }
        
        
    }

    

    
    //MARK: -时间戳转时间函数
    func timeStampToString(timeStamp: String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        
        if let timestampDouble = Double(timeStamp) {
            
            let timeSta:TimeInterval = TimeInterval(timestampDouble / 1000)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dfmatter = DateFormatter()
            //yyyy-MM-dd HH:mm:ss
            dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            return dfmatter.string(from: date as Date)
            
        }
        
        return ""
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
