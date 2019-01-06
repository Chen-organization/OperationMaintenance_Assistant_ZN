//
//  MyOrdersCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/4.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let MyOrdersCell_id = "MyOrdersCell"

class MyOrdersCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var TimeL: UILabel!
    @IBOutlet weak var orderNoL: UILabel!
    
    @IBOutlet weak var distanceL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    
    
    @IBOutlet weak var bottom1: UILabel!
    @IBOutlet weak var bottom2: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
