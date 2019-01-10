//
//  OrderDetailCell.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let OrderDetailCell_id = "OrderDetailCell"

class OrderDetailCell: UITableViewCell {
    
    @IBOutlet weak var levelL: UILabel!
    
    @IBOutlet weak var contentL: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.levelL.layer.cornerRadius = 9
        self.levelL.layer.borderWidth = 0.5
        self.levelL.layer.borderColor = UIColor.gray.cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
