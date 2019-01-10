//
//  OrderDetailHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class OrderDetailHeaderView: UIView {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var longTimeL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var orderNoL: UILabel!
    
    @IBOutlet weak var connectPersonL: UILabel!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var telL: UILabel!
    
    @IBOutlet weak var addressL: UILabel!
    
    @IBOutlet weak var telBtn: UIButton!
    
    @IBAction func telBtnClick(_ sender: Any) {
        
        let globalQueue = DispatchQueue.global()
       
            globalQueue.async {

                UIApplication.shared.openURL(URL(string: "telprompt://" + self.telL.text! )!)

        }
        
        
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        
    }
    

}
