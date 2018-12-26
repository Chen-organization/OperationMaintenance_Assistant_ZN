//
//  HomeVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/12/13.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UITableViewController {

    
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var taskBtn: UIButton!
    @IBOutlet weak var repairBtn: UIButton!
    @IBOutlet weak var orderPoolBtn: UIButton!
    
    @IBOutlet weak var repairNumL: UILabel!
    @IBOutlet weak var repairingNumL: UILabel!
    @IBOutlet weak var repairedNumL: UILabel!
    
    @IBOutlet weak var repairView: UIView!
    @IBOutlet weak var repairingView: UIView!
    @IBOutlet weak var repairedView: UIView!
    
    
    var headLinesData = [TheHeadlinesReturnObjModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "首页"
        
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        self.fd_prefersNavigationBarHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)

        self.taskBtn.set(icon: UIImage.init(named: "任务清单1"), title: "任务清单", titleLocation: .bottom, padding: 0, state: .normal)
        self.repairBtn.set(icon: UIImage.init(named: "故障报修1"), title: "故障报修", titleLocation: .bottom, padding: 0, state: .normal)
        self.orderPoolBtn.set(icon: UIImage.init(named: "抢单池1"), title: "抢单池", titleLocation: .bottom, padding: 0, state: .normal)
        
        
        self.tableView.register(UINib.init(nibName: "HomeNewCell", bundle:Bundle.main ), forCellReuseIdentifier: HomeNewCell_id)
        
        
        self.tableView.tableHeaderView?.height = ScreenW * 510 / 1080.0;
        // 网络图，本地图混合
        let imagesURLStrings = [
            "banner1",
            "banner2",
            "banner3",
            ]
        // Demo--点击回调
        let bannerDemo = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y:0, width: ScreenW, height: ScreenW * 510 / 1080.0), imageURLPaths: imagesURLStrings, titles:nil, didSelectItemAtIndex: { index in
            print("当前点击图片的位置为:\(index)")
        })
        
        bannerDemo.lldidSelectItemAtIndex = { index in
            
        }
        bannerDemo.customPageControlStyle = .fill
        bannerDemo.customPageControlInActiveTintColor = UIColor.red
        bannerDemo.pageControlPosition = .center
        bannerDemo.pageControlLeadingOrTrialingContact = 28
        
        // 下边约束
        bannerDemo.pageControlBottom = 15
        self.headView.addSubview(bannerDemo)
        
//        self.tableView.contentOffset.y = 44//statusBarheight


        self.getTheHeadlines()
        
        self.getJobOrders()
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 3{
            
            return 0
        }
        return 10
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            
            return self.headLinesData.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3 {
            let cell:HomeNewCell = tableView.dequeueReusableCell(withIdentifier: HomeNewCell_id, for: indexPath) as! HomeNewCell
            
            let model : TheHeadlinesReturnObjModel = self.headLinesData[indexPath.row]
            
            if let url = model.imgUrl {
                
                cell.img.kf.setImage(with: URL.init(string: url))

            }
            cell.titleL.text = model.title ?? ""
            cell.contentL.text = model.knowledgeDesc ?? ""
            cell.timeL.text = self.timeStampToString(timeStamp: model.createDate ?? "")
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.section == 0 || indexPath.section == 1){

            return 100
        }else if indexPath.section == 2 {
            
            return 40
        }

        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            scrollView.contentOffset.y = 0
        }
        
    }
    
    
    //MARK: - 方法
    func getTheHeadlines() {
        
        let para = ["start": "1",
                    "end": "3",
                    ]
        
        NetworkService.networkGetrequest(currentView: self.view, parameters: para, requestApi: getTheHeadlinesUrl, modelClass: "TheHeadlinesModel", response: { (obj) in
            
            let model : TheHeadlinesModel = obj as! TheHeadlinesModel
            
            if model.statusCode == 800 {
                
                self.headLinesData = model.returnObj ?? []
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            
        }
    }
    
    func getJobOrders() {
        
        NetworkService.networkGetrequest(currentView: self.view, parameters: [:], requestApi: getJobOrderUrl, modelClass: "jobOrdersModel", response: { (obj) in
            
            let model:jobOrdersModel = obj as! jobOrdersModel
            
            if model.statusCode == 800 {
                
                self.repairNumL.text = model.returnObj?[0].count ?? "0"
                
                self.repairingNumL.text = model.returnObj?[1].count ?? "0"

                self.repairedNumL.text = model.returnObj?[2].count ?? "0"

                
            }
            
            
        }) { (error) in
            
            
            
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIButton{
    func set(icon image: UIImage?, title: String, titleLocation: UIView.ContentMode, padding: CGFloat, state: UIControl.State ) {
        self.imageView?.contentMode = .center
        self.setImage(image, for: state)
        relativeLocation(title: title, location: titleLocation, padding: padding)
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func relativeLocation(title: String, location: UIView.ContentMode, padding: CGFloat){
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font : titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch location {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + padding),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + padding))
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + padding),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: -titleSize.width)
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -padding)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

