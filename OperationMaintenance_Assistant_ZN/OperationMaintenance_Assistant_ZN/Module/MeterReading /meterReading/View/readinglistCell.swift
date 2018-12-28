//
//  readinglistCell.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Apple on 2018/12/27.
//  Copyright © 2018 Chen. All rights reserved.
//

import UIKit

let readinglistCell_id = "readinglistCell"


@objc protocol readinglistCellDelegate{
    
    func cellDeleteWithIndex(index: Int)
    
}

class readinglistCell: UITableViewCell {
    
    
    weak var  cellDelegate: readinglistCellDelegate?
    
    var index : Int!
    
    @IBOutlet weak var NoL: UILabel!

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var value0: UILabel!
    @IBOutlet weak var value1: UILabel!
    

    @IBOutlet weak var deleteBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleColor(CanDelete:Bool)  {
        
        if CanDelete {
            
            self.NoL.textColor = RGBCOLOR(r: 31, 182, 167)
            self.nameL.textColor = RGBCOLOR(r: 31, 182, 167)
            self.value1.textColor = RGBCOLOR(r: 31, 182, 167)
            self.value0.textColor = RGBCOLOR(r: 31, 182, 167)
            
            
        }else{
            
            self.NoL.textColor = .gray
            self.nameL.textColor = .gray
            self.value1.textColor = .gray
            self.value0.textColor = .gray
        }
        
        self.deleteBtn.isHidden = !CanDelete
    }
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        
        self.cellDelegate?.cellDeleteWithIndex(index: self.index)

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
