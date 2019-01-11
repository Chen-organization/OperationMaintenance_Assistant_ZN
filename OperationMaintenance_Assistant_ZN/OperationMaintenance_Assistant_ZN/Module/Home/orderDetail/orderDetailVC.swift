//
//  orderDetailVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/10.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit

class orderDetailVC: UITableViewController {

    //订单号
    var orderNo = ""
    
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var longTimeL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var orderNoL: UILabel!
    @IBOutlet weak var connectPersonL: UILabel!
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
    
    //MARK: - 报修内容
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var repairContentL: UILabel!
    
    @IBOutlet weak var contentImg1: UIImageView!
    @IBOutlet weak var contentImg2: UIImageView!
    @IBOutlet weak var contentImg3: UIImageView!
    
    //MARK: - 现场a拍摄
    @IBOutlet weak var sceneTimeL: UILabel!
    
    @IBOutlet weak var sceneImg1: UIImageView!
    @IBOutlet weak var sceneImg2: UIImageView!
    @IBOutlet weak var sceneImg3: UIImageView!
    
    
    //MARK: - 维修内容
    @IBOutlet weak var repairedContentL: UILabel!
    
    @IBOutlet weak var repairedImg1: UIImageView!
    @IBOutlet weak var repairedImg2: UIImageView!
    @IBOutlet weak var repairedImg3: UIImageView!
    
    
    @IBOutlet weak var fittingSContentView: UIView!
    @IBOutlet weak var moneyL: UILabel!
    
    @IBOutlet weak var repairManL: UILabel!
    @IBOutlet weak var signImg: UIImageView!
    
    
    
    @IBAction func completeBtn(_ sender: UIButton) {
    }
    
    class func getOrderDetailVC() ->  orderDetailVC {
        
        let sb = UIStoryboard(name: "orderDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "orderDetailVC") as! orderDetailVC
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
