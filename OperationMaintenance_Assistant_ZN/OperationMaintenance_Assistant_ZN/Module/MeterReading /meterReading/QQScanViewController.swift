//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

@objc protocol ScanViewControllerDelegate{
    
    
    
    func ScanViewInfo(answer: String)
    
}

class QQScanViewController: LBXScanViewController {

    
    weak var  scanDelegate: ScanViewControllerDelegate?

    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle: UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false

// MARK: - 底部几个功能：开启闪光灯、相册、我的二维码

    //底部显示的功能项
    var bottomItemsView: UIView?

    //闪光灯
    var btnFlash: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "扫码"

        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)

        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        drawBottomItems()
    }

    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
                
                self.navigationController?.popViewController(animated: true)
                self.scanDelegate?.ScanViewInfo(answer: str)

                
            }
        }

    }

    func drawBottomItems() {
        if (bottomItemsView != nil) {

            return
        }

        let yMax = self.view.frame.maxY - self.view.frame.minY

        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )

        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        self.view .addSubview(bottomItemsView!)

        let size = CGSize(width: 65, height: 87)

        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)

        btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControl.Event.touchUpInside)
        

     
        bottomItemsView?.addSubview(btnFlash)

        self.view .addSubview(bottomItemsView!)

    }
    
    @objc func openLocalPhotoAlbum()
    {
        let alertController = UIAlertController(title: "title", message:"使用首页功能", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title:  "知道了", style: UIAlertAction.Style.default) { (alertAction) -> Void in

        }

        alertController.addAction(alertAction)

        present(alertController, animated: true, completion: nil)
    }

    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)

        }
    }

    @objc func myCode() {
//        let vc = MyCodeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
