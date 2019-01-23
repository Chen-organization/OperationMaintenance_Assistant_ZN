//
//  PatrolListCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/24.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let PatrolListCell_id = "PatrolListCell"

class PatrolListCell: UITableViewCell {

    @IBOutlet weak var contentL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
