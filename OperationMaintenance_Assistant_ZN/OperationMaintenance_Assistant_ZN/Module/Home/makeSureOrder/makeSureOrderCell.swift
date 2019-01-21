//
//  makeSureOrderCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/21.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

let makeSureOrderCell_id = "makeSureOrderCell"

@objc protocol makeSureOrderCellDelegate{
    
    func deleteBtnCli(index: Int)
    
    func numOf(num:Int ,index: Int)

    
}

class makeSureOrderCell: UITableViewCell {
    
    weak var  delegate: makeSureOrderCellDelegate?
    
    var index = 0
    

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!

    @IBOutlet weak var minusBtn: UIButton!
    
    @IBAction func minusBtnClick(_ sender: UIButton) {
        
        if let numStr = numberL.text {
            
            var num = Int(numStr)
            
            if num! > 1{
                
                num! -= 1
            }
            
            self.delegate?.numOf(num: num!, index: self.index)
            self.numberL.text = num?.description
            
        }
        
    }
    
    
    @IBOutlet weak var numberL: UILabel!
    
    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        
        if let numStr = numberL.text {
            
            var num = Int(numStr)
            num! += 1
            
            self.delegate?.numOf(num: num!, index: self.index)
            self.numberL.text = num?.description
            

        }
        
    }
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        
        self.delegate?.deleteBtnCli(index: self.index)
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
