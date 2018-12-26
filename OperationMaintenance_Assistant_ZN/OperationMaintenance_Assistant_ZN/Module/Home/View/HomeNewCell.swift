//
//  HomeNewCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/26.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

let HomeNewCell_id = "HomeNewCell"


class HomeNewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
