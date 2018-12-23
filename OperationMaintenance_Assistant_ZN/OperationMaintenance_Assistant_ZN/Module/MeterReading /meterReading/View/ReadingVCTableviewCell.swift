//
//  ReadingVCTableviewCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/23.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

let ReadingVCTableviewCell_id = "ReadingVCTableviewCell"

class ReadingVCTableviewCell: UITableViewCell {

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var value0: UILabel!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var value2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)



    }
    
}
