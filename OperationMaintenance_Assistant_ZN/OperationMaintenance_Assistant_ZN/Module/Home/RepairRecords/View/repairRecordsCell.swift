//
//  repairRecordsCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/25.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit


let repairRecordsCell_id = "repairRecordsCell"


class repairRecordsCell: UITableViewCell {
    
    
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
