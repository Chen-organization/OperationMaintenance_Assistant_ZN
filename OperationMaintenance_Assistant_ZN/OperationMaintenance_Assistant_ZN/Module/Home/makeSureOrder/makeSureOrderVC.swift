//
//  makeSureOrderVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/21.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class makeSureOrderVC: UITableViewController,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,XDSDropDownMenuDelegate , makeSureOrderCellDelegate ,UITextViewDelegate{
    
    
    func setDropDown(_ sender: XDSDropDownMenu!) {
        
        self.downDropDownMenu.tag = 1000;
        self.selectedItemModel = self.showItemsArray[sender.selectedIndex]
        
    }
    
    var orderNo = ""
    
    @IBOutlet weak var textView: UIPlaceHolderTextView!
    
    
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
    
    
    @IBOutlet weak var repaireContentSelectView: UIView!
    
    @IBOutlet weak var repairContentSelectViewH: NSLayoutConstraint!
    
    
    @IBOutlet weak var moneyL: UILabel!
    
    

    var ImgArr = [UIImageView]()
    var selectedImgArr = [UIImage]()
    
    
    var deleteBtnArr = [UIButton]()


    
    var showItemsArray = [makeSureItemsReturnObjModel]()
    var selectedItemsArray = [makeSureItemsReturnObjModel]()

    var selectedItemModel : makeSureItemsReturnObjModel?  //下拉选中的还没确定的

    
    var downDropDownMenu = XDSDropDownMenu()
    @IBOutlet weak var selectedItemL: UILabel!
    
   
    @IBOutlet weak var payOnlineBtn: UIButton!
    @IBAction func payOnlieClick(_ sender: UIButton) {
        
        self.payOnlineBtn.isSelected = true
        self.payMoneyBtn.isSelected = false
    }
    
    @IBOutlet weak var payMoneyBtn: UIButton!
    @IBAction func payMoneyClick(_ sender: UIButton) {
    
        self.payOnlineBtn.isSelected = false
        self.payMoneyBtn.isSelected = true
    }

    
    class func getVC() ->  makeSureOrderVC {
        
        let sb = UIStoryboard(name: "makeSureOrder", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "makeSureOrderVC") as! makeSureOrderVC
        
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "确认工单"
        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        
        self.textView.placeholder = "请描述状况，限300字..."
        self.textView.placeholderColor = RGBCOLOR(r: 153, 153, 153)
        self.textView.delegate = self
        self.textView.tag = 4000
        self.textView.tintColor = self.view.tintColor
        self.textView.text = ""
        
        
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

        
        self.tableView.register(UINib.init(nibName: "makeSureOrderCell", bundle:Bundle.main ), forCellReuseIdentifier:makeSureOrderCell_id )
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.getItems()
        
        self.downDropDownMenu.tag = 1000;
        
        self.payOnlineBtn.isSelected = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    func getRepairSelectViewContent() {
        
 
//        "returnObj": [{
//        "dealCode": "DW0101",
//        "dealName": "开阀门",
//        "companyCode": "0000",
//        "workClass": "W01",
//        "dealTime": 10,
//        "status": 1,
//        "createDate": 1531457998000
//        }, {
    
//    http://plat.znxk.net:6801/workOrder/getWorkClassDeal?companyCode=1009&orgCode=1009001&empNo=E100900003&empName=zf%E6%9C%BA%E6%9E%84&workClass=W01
    
    }
    
    //MARK: - 维修配件
    @IBAction func selectItems(_ sender: UIButton) {
        
        downDropDownMenu.delegate = self;//代理
        
        if !(self.showItemsArray.count > 0) {
            
            return
        }
        
        
        let btnFrame = sender.superview?.convert(sender.frame, to: self.view)//如果按钮在UITabelView上用这个
        
        if(downDropDownMenu.tag == 1000){
            
            /*
             如果dropDownMenu的tag值为1000，表示dropDownMenu没有打开，则打开dropDownMenu
             */
            
            var titleArr = [Any]()
            
            for model:makeSureItemsReturnObjModel in self.showItemsArray {
                
                titleArr.append(model.goodsName ?? "")
                
            }
            
            //初始化选择菜单
            self.downDropDownMenu.show(sender, withButtonFrame: btnFrame ?? CGRect.init(x: 0, y: 0, width: 0, height: 0), arrayOfTitle: titleArr, arrayOfImage:nil, animationDirection:"down")
            
            //添加到主视图上
            self.view.addSubview(downDropDownMenu)
            
            downDropDownMenu.tag = 2000;
            
        }else {
            
            /*
             如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
             */
            
            self.downDropDownMenu.hide(withBtnFrame:btnFrame ?? CGRect.init(x: 0, y: 0, width: 0, height: 0))
            downDropDownMenu.tag = 1000;
        }
        
    }
    
    //MARK: - 配件列表 获取
    func getItems() {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode": userModel.companyCode ?? "",
                "orgCode": userModel.orgCode ?? "",
                "empNo": userModel.empNo ?? "",
                "empName": userModel.empName ?? "",
                "id": self.orderNo,
                ] as [String : Any]
            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getConfirmOrderURL, modelClass: "makeSureItemsModel", response: { (obj) in

                let model : makeSureItemsModel = obj as! makeSureItemsModel

                if model.statusCode == 800 {

                    self.showItemsArray = model.returnObj ?? [makeSureItemsReturnObjModel]()
                    //                    self.dropDownMenu.reloadAllComponents()

                }


            }, failture: { (error) in



            })
        }
        
        
    }
    
    //MARK: -  添加配件按钮点击
    
    @IBAction func addItemsBtnClick(_ sender: UIButton) {
        
        if self.selectedItemModel == nil {
            
            ZNCustomAlertView.handleTip("请选择配件", isShowCancelBtn: false) { (sure) in
                
            }
            
            return
        }
        
        
        let hasItem = self.selectedItemsArray.contains { (obj) -> Bool in
            
            return obj.goodsNo == self.selectedItemModel?.goodsNo
        }
        
        if hasItem {
            
            YJProgressHUD.showMessage("配件已经添加", in: UIApplication.shared.keyWindow, afterDelayTime: Int(1.5))
            

        }else{
            
            //刷新数据
            self.selectedItemsArray.insert(self.selectedItemModel!, at: 0)
            
            self.calculateMoney()
            self.tableView.reloadData()
            
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
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 2 || section == 3{
            
            return 0
        }
        return 10
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2{
            
            return self.selectedItemsArray.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell:makeSureOrderCell = tableView.dequeueReusableCell(withIdentifier: makeSureOrderCell_id, for: indexPath) as! makeSureOrderCell
            
            let model : makeSureItemsReturnObjModel = self.selectedItemsArray[indexPath.row]
            
            cell.titleL.text = model.goodsName
            
            cell.delegate = self
            
//            if let url = model.imgUrl {
//
//                cell.img.kf.setImage(with: URL.init(string:url), placeholder: UIImage.init(named: "站位图小"), options: nil, progressBlock: { (a, b) in
//
//                }, completionHandler: { (img) in
//
//                })
//
//            }
//            cell.titleL.text = model.title ?? ""
//            cell.contentL.text = model.knowledgeDesc ?? ""
//            cell.timeL.text = self.timeStampToString(timeStamp: model.createDate ?? "")
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0 ){
            
            return 300
        }else if indexPath.section == 2 {
            
            return 40
        }
        
        return 45
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
    
    // MARK: - cell delegate
    func deleteBtnCli(index: Int) {
        
        self.selectedItemsArray.remove(at: index)
        
        self.calculateMoney()
        self.tableView.reloadData()
        
    }
    
    func numOf(num: Int, index: Int) {
        
        let model : makeSureItemsReturnObjModel = self.selectedItemsArray[index]
        model.num = num
        
        //刷新价格
        self.calculateMoney()
    }
    
    
    // MARK: - 计算价格
    
    func calculateMoney() {
        
        var money = 0.0
        
        for model in self.selectedItemsArray {
            
            let itemMoney = Double(model.num) * model.retailPrice!
            money += itemMoney
        }
        
        self.moneyL.text = NSString.init(format: "%.2f", money) as String;
        
    }
    
    // MARK: - 提交
    @IBAction func sureBtnClick(_ sender: UIButton) {
        
//        if !(self.textView.text.characters.count > 0){
//
//            ZNCustomAlertView.handleTip("请填写报修内容或勾选一种维修内容", isShowCancelBtn: false) { (sure) in
//
//            }
//            return
//        }
     
//        UserCenter.shared.userInfo { (islogin, userModel) in
//
//            let para = [
//
//                "companyCode": userModel.companyCode ?? "",
//                "orgCode": userModel.orgCode ?? "",
//                "empNo": userModel.empNo ?? "",
//                "empName": userModel.empName ?? "",
//                "id": self.orderNo,
//                ] as [String : Any]
//
//            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi:getConfirmOrderURL, modelClass: "makeSureItemsModel", response: { (obj) in
//
//                let model : makeSureItemsModel = obj as! makeSureItemsModel
//
//                if model.statusCode == 800 {
//
//                    self.showItemsArray = model.returnObj ?? [makeSureItemsReturnObjModel]()
//                    //                    self.dropDownMenu.reloadAllComponents()
//
//                }
//
//
//            }, failture: { (error) in
//
//
//
//            })
//        }
        
        
    }
    

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
