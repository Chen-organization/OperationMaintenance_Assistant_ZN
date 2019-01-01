//
//  myOrdersVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit


class myOrdersVC:UIViewController,MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {

    
    let segmentedPager = MXSegmentedPager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的工单"
        
        self.view.backgroundColor = .white
        
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
        segmentedPager.segmentedControl.borderColor = RGBCOLOR(r: 235, 235, 235)
        segmentedPager.segmentedControl.borderWidth = -10
        
        segmentedPager.segmentedControlEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        self.segmentedPager.frame = self.view.bounds
        
        super.viewWillLayoutSubviews()
        
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
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        
        return [UITableViewController(),UITableViewController(),UITableViewController()][index]
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        return [UITableView(),UITableView(),UITableView()][index]
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
