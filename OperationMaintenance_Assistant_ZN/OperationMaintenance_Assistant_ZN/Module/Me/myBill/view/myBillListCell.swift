//
//  myBillListCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let myBillListCell_id = "myBillListCell"

class myBillListCell: UITableViewCell {
    
    
    @IBOutlet weak var moneyL: UILabel!
    
    
    @IBOutlet weak var goodTitleTopH: NSLayoutConstraint!
    @IBOutlet weak var goodsTitleL: UILabel!
    @IBOutlet weak var goodsL: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var payTypeL: UILabel!
    
    @IBAction func payBtnClick(_ sender: UIButton) {
    }
    
    @IBOutlet weak var dealTimeL: UILabel!
    @IBOutlet weak var payTimeL: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
