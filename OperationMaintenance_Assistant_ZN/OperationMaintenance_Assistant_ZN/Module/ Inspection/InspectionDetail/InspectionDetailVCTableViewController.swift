//
//  InspectionDetailVCTableViewController.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2019/1/24.
//  Copyright © 2019 Chen. All rights reserved.
//

import UIKit

class InspectionDetailVCTableViewController: UITableViewController,UIGestureRecognizerDelegate {

    
    
    class func getVC() ->  InspectionDetailVCTableViewController {
        
        let sb = UIStoryboard(name: "Inspection", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InspectionDetailVCTableViewController") as! InspectionDetailVCTableViewController
        
        return vc
    }

    var patrolId = ""
    
    
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    
    var ImgArr = [UIImageView]()
    var ImgUrlArr = [String]()

    
    
    var addressCellHeight = 48.0
    var contentCellHeight = 48.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "巡检详情"

        
        ImgArr = [contentImg1,contentImg2,contentImg3]
        
        for i in 0..<ImgArr.count {
            
            
            let img = ImgArr[i]
            img.tag = i

            img.isHidden = true
  
            
            let tap1:UITapGestureRecognizer = UITapGestureRecognizer.init()
            tap1.numberOfTapsRequired = 1 //轻点次数
            tap1.numberOfTouchesRequired = 1 //手指个数
            tap1.delegate = self
            tap1.addTarget(self, action: #selector(tapImgView(action:)))
            img.addGestureRecognizer(tap1)
            
        }
        

        self.getData()
       
    }
    
    
    @IBAction func toRepair(_ sender: UIButton) {
        
        var imgs = [UIImage]()
        
        for i in 0..<self.ImgUrlArr.count {
            
            let img = self.ImgArr[i]
            imgs.append(img.image!)
            
        }
        
        let vc : onlineRepaire = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "onlineRepaire") as! onlineRepaire
        vc.wokerName = self.nameL.text ?? ""
        vc.address = self.addressL.text ?? ""
        vc.contentText = self.contentL.text ?? ""
        vc.imageArr = imgs
        
        
        vc.patrolId = self.patrolId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - 手势
    @objc func tapImgView(action:UIGestureRecognizer)  {
        
        
            //查看
            let img :UIImageView = action.view as! UIImageView
            
            PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: 0) { () -> [Any]? in
                
                let pbModel = PhotoModel()
                pbModel.mid = 1
                pbModel.image = img.image
                
                return [pbModel]
                
            }
            
  
        
        
    }
    
    func getData() {
        
        
        
        UserCenter.shared.userInfo { (islogin, userModel) in
            
            
            let para = [
                
                "companyCode": userModel.companyCode ?? "",
                "orgCode": userModel.orgCode ?? "",
                "empNo": userModel.empNo ?? "",
                "empName": userModel.empName ?? "",
                "patrolId": self.patrolId,
                ]

            
            NetworkService.networkPostrequest(currentView: self.view, parameters: para, requestApi: getPatrolDetailsURL, modelClass: "InspectionDetailModel", response: { (obj) in
                
                let model : InspectionDetailModel = obj as! InspectionDetailModel
                if model.statusCode == 800 {
                    
                    self.dateL.text = self.timeStampToString(timeStamp: (model.returnObj?.content?.createDate ?? ""))
                    self.addressL.text = (model.returnObj?.content?.address ?? "")
                    self.nameL.text = (model.returnObj?.content?.empName ?? "")
                    self.contentL.text = (model.returnObj?.content?.patrolContent ?? "")

             
                    let size = (model.returnObj?.content?.address ?? "").boundingRect(with: CGSize(width: self.addressL.frame.width, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.addressL.font], context: nil)
                    self.addressCellHeight = Double(size.height + 25.0)
                    
                    
                    let contentSize = (model.returnObj?.content?.patrolContent ?? "").boundingRect(with: CGSize(width: self.contentL.frame.width, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.contentL.font], context: nil)
                    self.contentCellHeight = Double(contentSize.height + 25.0)
                  
                    for m : InspectionDetailPriceModel in (model.returnObj?.price ?? []) {
                        
                        self.ImgUrlArr.append(m.imgUrl ?? "")
                        
                    }
                    
                    for i in 0..<self.ImgUrlArr.count {
                        
                        let img = self.ImgArr[i]
                        img.kf.setImage(with: URL.init(string:self.ImgUrlArr[i]), placeholder: UIImage.init(named: "站位图"), options: nil, progressBlock: { (a, b) in
                            
                        }, completionHandler: { (img) in
                            
                        })
                        img.isHidden = false
                        
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }else{
                    
                    YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)

                    
                }
                
                
            }, failture: { (error) in
                
                
                
            })
            
            
            
        }
        
        
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0 || indexPath.row == 2) {
            
            return 48
            
        }else  if (indexPath.row == 1) {
            
            return CGFloat(self.addressCellHeight);
        }else  if (indexPath.row == 3) {
            
            return CGFloat(self.contentCellHeight);
        }else{
            
            return self.ImgUrlArr.count > 0 ?  93 : 0
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
