//
//  meterReadingSignVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/23.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

@objc protocol meterReadingSignVCDelegate {
    
    func meterReadingedWithImg(img: UIImage)

    
}

class meterReadingSignVC: UIViewController,PopSignatureViewDelegate {
    
    weak var  signDelegate: meterReadingSignVCDelegate?

    
    
    @IBOutlet weak var meterNameL: UILabel!
    @IBOutlet weak var lastTimeMeterNumL: UILabel!
    @IBOutlet weak var NowMeterNumL: UILabel!
    
    @IBOutlet weak var numL: UILabel!
    @IBOutlet weak var meterNo: UILabel!
    
    @IBOutlet weak var signContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let signView = PopSignatureView()
        signView.delegate = self
        self.signContentView.addSubview(signView)
        signView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.signContentView).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }

    }

    //确认签名
    func onSubmitBtn(_ signatureImg: UIImage!) {
        
        self.signDelegate?.meterReadingedWithImg(img: signatureImg)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}



