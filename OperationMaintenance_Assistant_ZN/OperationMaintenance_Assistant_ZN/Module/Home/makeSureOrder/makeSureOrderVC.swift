//
//  makeSureOrderVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/21.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class makeSureOrderVC: UITableViewController,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,XDSDropDownMenuDelegate {
    
    
    func setDropDown(_ sender: XDSDropDownMenu!) {
        
        self.selectedItemModel = self.showItemsArray[sender.selectedIndex]
        
    }
    
    var orderNo = ""
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    @IBOutlet weak var contentImg4: UIImageView!

    var ImgArr = [UIImageView]()
    var selectedImgArr = [UIImage]()

    
    var showItemsArray = [makeSureItemsReturnObjModel]()
    var selectedItemsArray = [makeSureItemsReturnObjModel]()

    var selectedItemModel = makeSureItemsReturnObjModel()  //下拉选中的还没确定的

    
    var downDropDownMenu = XDSDropDownMenu()
    @IBOutlet weak var selectedItemL: UILabel!
    
    
    
    class func getVC() ->  makeSureOrderVC {
        
        let sb = UIStoryboard(name: "makeSureOrder", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "makeSureOrderVC") as! makeSureOrderVC
        
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "确认工单"
        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        ImgArr = [contentImg1,contentImg2,contentImg3,contentImg4]

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
        
        
        self.tableView.register(UINib.init(nibName: "makeSureOrderCell", bundle:Bundle.main ), forCellReuseIdentifier:makeSureOrderCell_id )
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            
            for model:makeSureItemsReturnObjModel in self.selectedItemsArray {
                
                titleArr.append(model.goodsName)
                
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
    
    func getChangeReason(meterNo:String) {
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            let para = [
                
                "companyCode": userModel.companyCode ?? "",
                "orgCode": userModel.orgCode ?? "",
                "empNo": userModel.empNo ?? "",
                "empName": userModel.empName ?? "",
                "id": self.orderNo,
                "deviceNo": meterNo ,
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
    
    //MARK: - 添加配件按钮点击
    
    @IBAction func addItemsBtnClick(_ sender: UIButton) {
        
        
        let hasItem = self.selectedItemsArray.contains { (obj) -> Bool in
            
            return obj.goodsNo == self.selectedItemModel.goodsNo
        }
        
        if hasItem {
            
            ZNCustomAlertView.handleTip("请选择配件", isShowCancelBtn: false) { (sure) in
                
            }
        }else{
            
            //刷新数据
            self.selectedItemsArray.insert(self.selectedItemModel, at: 0)
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
    
    //MARK: - 手势
    @objc func tapImgView(action:UIGestureRecognizer)  {
        
        if action.view!.tag == self.selectedImgArr.count  {
            
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
            
            return 260
        }else if indexPath.section == 2 {
            
            return 35
        }
        
        return 40
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
