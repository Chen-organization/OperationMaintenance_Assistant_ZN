//
//  readingVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/16.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import Photos
//import WCQRCodeVC

class readingVC: UITableViewController {

    @IBOutlet weak var scanBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        
        //二维码
        
        if self.checkCameraPermission() {
            
        
            self.navigationController?.pushViewController(ScanViewController(), animated: true)
            
        }
        
        
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        
        
    }
    
    
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
