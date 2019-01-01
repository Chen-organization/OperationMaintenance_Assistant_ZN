//
//  myMessageCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/1.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let myMessageCell_id = "myMessageCell"

class myMessageCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
