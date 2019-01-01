//
//  headerLinesDetailVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/31.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit

class headerLinesDetailVC: UIViewController {
    
    var url = ""
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "运维头条"
        
        self.webView.backgroundColor = .white
        
        let weburl = NSURL(string: self.url)
        webView.loadRequest(NSURLRequest(url: weburl! as URL) as URLRequest)
        self.view.addSubview(webView)
    }
    
    

    @IBAction func menuBtnClick(_ sender: UIButton) {
        
        
        
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
