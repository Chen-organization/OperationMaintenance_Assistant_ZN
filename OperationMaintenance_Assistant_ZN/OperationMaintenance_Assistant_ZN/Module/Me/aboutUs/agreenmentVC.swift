//
//  agreenmentVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2018/12/27.
//  Copyright © 2018年 Chen. All rights reserved.
//

import UIKit
import WebKit


class agreenmentVC: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "法律条款"
        
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: CGFloat(NavHeight), left: 0, bottom: 0, right: 0))
            
        }
        
        let path = Bundle.main.path(forResource: "agreement", ofType: "html")
        let urlStr = NSURL.fileURL(withPath: path!)
        webView.load(URLRequest.init(url: urlStr)) ///t(NSURLRequest(URL: urlStr))
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
