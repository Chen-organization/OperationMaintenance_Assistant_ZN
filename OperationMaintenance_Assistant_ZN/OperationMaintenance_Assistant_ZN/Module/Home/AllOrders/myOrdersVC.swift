//
//  myOrdersVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

enum ordersTableViewType : Int {
    case repair=1, repairing, repaired
}

import UIKit


class myOrdersVC:UIViewController,MXSegmentedPagerDelegate, MXSegmentedPagerDataSource,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {

    var selectedIndex = 0
    
    
    let segmentedPager = MXSegmentedPager()
    
    var repairTableview = BasePullTableView()
    var repairingTableview = BasePullTableView()
    var repairedTableview = BasePullTableView()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的工单"
        
        self.view.backgroundColor = .white
        
        self.edgesForExtendedLayout = []

        
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        segmentedPager.backgroundColor = .white
        self.view.addSubview(segmentedPager)

        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = .white
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : RGBCOLOR(r: 24, 151, 138), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        segmentedPager.segmentedControl.selectionStyle = .textWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = RGBCOLOR(r: 24, 151, 138)
        segmentedPager.segmentedControl.selectionIndicatorHeight = 2
        segmentedPager.segmentedControl.borderType = .bottom
        segmentedPager.segmentedControl.borderColor = RGBCOLOR(r: 245, 245, 245)
        segmentedPager.segmentedControl.borderWidth = -10
        segmentedPager.segmentedControlEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        
        self.repairTableview.tag = ordersTableViewType.repair.rawValue
        self.repairingTableview.tag = ordersTableViewType.repairing.rawValue
        self.repairedTableview.tag = ordersTableViewType.repaired.rawValue

        self.repairTableview.delegate = self
        self.repairingTableview.delegate = self
        self.repairedTableview.delegate = self
        
        self.repairTableview.dataSource = self
        self.repairingTableview.dataSource = self
        self.repairedTableview.dataSource = self
        
        self.repairTableview.pullDelegate = self
        self.repairingTableview.pullDelegate = self
        self.repairedTableview.pullDelegate = self
        
        self.repairTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)
        self.repairingTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)
        self.repairedTableview.register(UINib.init(nibName: "MyOrdersCell", bundle: nil), forCellReuseIdentifier: MyOrdersCell_id)

        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        segmentedPager.pager.showPage(at: selectedIndex, animated: false)

    }
    
    override func viewWillLayoutSubviews() {
        
        self.segmentedPager.frame = self.view.bounds
        
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK: - 数据
    func getDataWith(page:Int , type:ordersTableViewType) {
        
        
        
    }
    
    
    //MARK: - SEGMENT
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["待维修", "维修中", "已完成"][index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        
        return 3
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        return [repairTableview,repairingTableview,repairedTableview][index]
    }

    
    // MARK: - TableView Delegate  DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyOrdersCell = tableView.dequeueReusableCell(withIdentifier: MyOrdersCell_id, for: indexPath) as! MyOrdersCell
        

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    func pullTableViewDidTriggerRefresh(_ pullTableView: BasePullTableView!) {
        
        
    }
    
    func pullTableViewDidTriggerLoadMore(_ pullTableView: BasePullTableView!) {
        
        
        
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
