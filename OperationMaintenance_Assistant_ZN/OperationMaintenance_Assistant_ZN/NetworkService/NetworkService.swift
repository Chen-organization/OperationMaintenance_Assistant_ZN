//
//  NetworkService.swift
//  swift_test
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

import Foundation
import HandyJSON
import SystemConfiguration
import Alamofire


public struct NetworkService {

    public static func networkPostrequest(currentView : UIView , parameters: [String : Any], requestApi: String, modelClass :String, response: @escaping (_ responseObject : AnyObject) -> (), failture : @escaping (_ error : NSError)->())  {
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            

        }else{
            
            ZNCustomAlertView.handleTip("网络不可用，请检查网络是否连接！", isShowCancelBtn: false, completion: { (isure) in
                
            })
            YJProgressHUD.hide()
            currentView.endLoading()
            return
        }
        
            NetworkRequest.sharedInstance.NetworkPostRequest(URL: requestApi, params:parameters as [String : AnyObject] , success: { (responseObject) in
                
                //转模
//                var Model = swiftClassFromString(className:modelClass)
                
                let model = (swiftClassFromString(className: modelClass) as? HandyJSON.Type )?.deserialize(from: responseObject)
                
                if ( model != nil) {

                    response(model! as AnyObject)

                }
                
            }) { (Error) in
                
                
//                ZNCustomAlertView.handleTip("网络开小差了，请稍后重试...", isShowCancelBtn: false, completion: { (isure) in
//
//                })
                
                failture(Error)
    
                print(Error);
                
        }
    }
    
    
    
    public static func networkGetrequest(currentView : UIView , parameters: [String : Any], requestApi: String, modelClass :String, response: @escaping (_ responseObject : AnyObject) -> (), failture : @escaping (_ error : NSError)->())  {
        
        //无网络判断
        let net = NetworkReachabilityManager()
        if net?.isReachable ?? false {
            
            
        }else{
            

            YJProgressHUD.hide()
            currentView.endLoading()
            ZNCustomAlertView.handleTip("网络不可用，请检查网络是否连接！", isShowCancelBtn: false, completion: { (isure) in
                
            })
            
            return
        }
        
        NetworkRequest.sharedInstance.NetworkGetRequest(URL: requestApi, params: parameters as [String : AnyObject], success: { (responseObject) in
            
            //转模
            //                var Model = swiftClassFromString(className:modelClass)
            
            let model = (swiftClassFromString(className: modelClass) as? HandyJSON.Type )?.deserialize(from: responseObject)
            
            if ( model != nil) {
                
                response(model! as AnyObject)
                
            }else{
                
                response(responseObject as AnyObject)

            }
            
            print(responseObject);

            
        }) { (Error) in
            
//            YJProgressHUD.showMessage("网络连接错误！", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
            
//            ZNCustomAlertView.handleTip("网络开小差了，请稍后重试...", isShowCancelBtn: false, completion: { (sure) in
//                
//            })
            
            failture(Error)
            
            print(Error);
        }
        

    }

}

    // create a static method to get a swift class for a string name
     func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = appName + "." + className
            // return the class!b
            return NSClassFromString(classStringName)
        }
        return nil;
    }



