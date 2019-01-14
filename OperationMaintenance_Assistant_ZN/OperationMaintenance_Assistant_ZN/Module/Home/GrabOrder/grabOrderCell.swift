//
//  grabOrderCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/13.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit


@objc protocol grabOrderCellDelegate{
    
    func grabOrder(index: Int)
    
}

let grabOrderCell_id = "grabOrderCell"


class grabOrderCell: UITableViewCell {
    
    weak var  grabDelegate: grabOrderCellDelegate?

    var Index: Int = 0
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var conentL: UILabel!
    
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var distanceL: UILabel!
    
    @IBOutlet weak var grabBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func grabBtnClick(_ sender: UIButton) {
        
        self.grabDelegate?.grabOrder(index: self.Index)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
