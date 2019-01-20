//
//  myGrabOrderListCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let myGrabOrderListCell_id = "myGrabOrderListCell"

@objc protocol myGrabOrderListCellDelegate{
    
    
    
    func deleteOrder(cellIndex:Int);
    
}


class myGrabOrderListCell: UITableViewCell {
    
    
    weak var  delegate: myGrabOrderListCellDelegate?

    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var grabDateL: UILabel!

    @IBOutlet weak var orderNoL: UILabel!
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
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        self.delegate?.deleteOrder(cellIndex:self.index)
        
    }

    
    @IBOutlet weak var distanceL: UILabel!
    @IBOutlet weak var distanceContentView: UIView!
    
    
    var index = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
