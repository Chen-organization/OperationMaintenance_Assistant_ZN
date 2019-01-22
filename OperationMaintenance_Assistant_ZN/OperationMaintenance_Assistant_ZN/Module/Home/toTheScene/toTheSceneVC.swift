//
//  toTheSceneVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/14.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON


class toTheSceneVC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var orderNo = ""
    
    
    @IBOutlet weak var addView: toTheSceneAddPhotoView!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    var imageArr : NSMutableArray = NSMutableArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "到达现场"
        
        addView.addPicturesBlock = {
            
            var sourceType: UIImagePickerController.SourceType = .photoLibrary
           
            //拍照
            sourceType = .camera
            
            let pickerVC = UIImagePickerController()
            pickerVC.view.backgroundColor = UIColor.white
            pickerVC.delegate = self
            pickerVC.allowsEditing = false
            pickerVC.sourceType = sourceType
            self.present(pickerVC, animated: true, completion: nil)
          
            
        }
        weak var weakSelf = self
        
        addView.deleteTweetImageBlock = {
            index in
            
            weakSelf?.imageArr.removeObject(at: Int(index))
            weakSelf?.addView.setDataArray(weakSelf?.imageArr as! [Any], isLoading: false)
        }
        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        //获得照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        self.imageArr.add(image)
        
        self.addView.setDataArray(self.imageArr as! [Any], isLoading: false)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func sureBtnClick(_ sender: UIButton) {
        
        
//        if !(self.imageArr.count > 0) {
//
//            YJProgressHUD.showMessage("请上传图片", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
//            return
//        }
        
        UserCenter.shared.userInfo { (islogin, user) in
            
            
            
//            http://plat.znxk.net:6801/first/getUploadPictures?companyCode=1009&orgCode=1009001&empNo=E100900003&empName=zf%E6%9C%BA%E6%9E%84&workNo=W100920190100001&type=2
            
            
            var ImgStrArr = [String]()
            
            for i in 0..<self.imageArr.count {
                
                let image = self.imageArr[i] as! UIImage
                let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
                
//                let imageName = self.milliStamp + ".jpeg" //i.description +
                
                // NSData 转换为 Base64编码的字符串
                let base64String:String = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) ?? ""
                
                ImgStrArr.append(base64String)
            }

            
            if (!JSONSerialization.isValidJSONObject(ImgStrArr)) {
                print("无法解析出JSONString")
            }
            
            let data : NSData! = try? JSONSerialization.data(withJSONObject: ImgStrArr, options: []) as NSData!
            let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)

//            let para = [
//                "companyCode":user.companyCode ?? "",
//                        "empNo":user.empNo ?? "",
//                        "empName":user.empName ?? "",
//                        "orgCode":user.orgCode ?? "",
//                        "workNo":self.orderNo ,
//                        "type" : "2",
////                        "File" : ImgStrArr.first,
////                        "File" : ImgStrArr.first
//                ]
            
            
            var para = String()
            
            for str in ImgStrArr{
             
                if para.characters.count > 0{
                    
                    para = para + "&"
                }
                
                para = para + "File=" + str
                
                
            }
            
            
            
//            NetworkService.networkPostrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getUploadPicturesURL, modelClass: "BaseModel", response: { (obj) in
//
//
//
//            }, failture: { (error) in
//
//
//
//            })
            
     
            var URL = getUploadPicturesURL+"?companyCode="
            
            URL = URL + user.companyCode! + "&empName="
            
            URL = URL + user.empName! + "&empNo="

            URL = URL + user.empNo! + "&orgCode="

            URL = URL + user.orgCode! + "&type=2&workNo="

            URL = URL + self.orderNo

            
            
            let manager = AFHTTPSessionManager.init()
            manager.requestSerializer.timeoutInterval = 40;
            manager.responseSerializer.acceptableContentTypes = NSSet(arrayLiteral: "text/plain", "application/json", "text/html", "image/jpeg", "image/png", "application/octet-stream", "text/json") as? Set<String>

            let headers: HTTPHeaders =  [    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                                             "Accept": "application/json",
                                             "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                                             ]
            
            
            manager.post(URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "", parameters:para.data(using: .utf8), headers: headers, progress: { (progress) in


            }, success: { (task, response) in

                //如果response不为空时
                if response != nil {

                    print(task)

                    print(response)

                }
            }, failure: { (task, error) in


                //打印连接失败原因
                print(error)
            })
            
            
            
            
            
            
            
            
            
//            let session = URLSession(configuration: .default)
//            // 设置URL(该地址不可用，写你自己的服务器地址)
//            let url = URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//            var request = URLRequest(url: NSURL.init(string: url)! as URL)
//            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            request.setValue("Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==", forHTTPHeaderField: "Authorization")
//            request.setValue("okhttp/3.10.0", forHTTPHeaderField: "User-Agent")
//            request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
//            request.setValue("en", forHTTPHeaderField: "Accept-Language")
//
//
//
//            request.httpMethod = "POST"
//            // 设置要post的内容，字典格式
////            let postData = ["name":"\(name)","password":"\(password)"]
////            let postString = postData.compactMap({ (key, value) -> String in
////                return "\(key)=\(value)"
////            }).joined(separator: "&")
//
//
//
//
//
//            request.httpBody = para.data(using: .utf8)
//            // 后面不解释了，和GET的注释一样
//            let task = session.dataTask(with: request) {(data, response, error) in
//                do{
//                    //              将二进制数据转换为字典对象
//                    if let jsonObj:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
//                    {
//                        print(jsonObj)
//                        //主线程
//                        DispatchQueue.main.async{
//
//                        }
//                    }
//                } catch{
//                    print("Error.")
//                    DispatchQueue.main.async{
//
//                    }
//
//                }
//                }
//
//            task.resume()
//
//
            
            
            
            
            
            
            
            

//            manager.post(getUploadPicturesURL, parameters: para as [String : AnyObject], headers: headers, constructingBodyWith: { (multipartFormData) in
//
//
//                //采用post表单上传
//                for str in ImgStrArr{
//
////                    multipartFormData.append( str.data(using: String.Encoding.utf8)! , withName: "File")
//
//                    multipartFormData.appendPart(withForm: str.data(using: String.Encoding.utf8)!, name: "File")
//
//
//                }
//
//
//
//////                    for i in 0..<self.imageArr.count {
////
////                        let image = UIImage.init(named:"图一") //self.imageArr[i] as! UIImage
////                        let data = image!.compress(withMaxLength: 1 * 1024 * 1024 / 8)
////
////                        let imageName = self.milliStamp + ".jpeg" //i.description +
////
////                        multipartFormData.appendPart(withFileData: data!, name: "File", fileName:"", mimeType: "")
////
//////                    }
//
//
//            }, progress: { (progress) in
//
//                print("图片上传进度: \(progress.fractionCompleted)")
//
//
//            }, success: { (task, response) in
//
//                //如果response不为空时
//                if response != nil {
//
//                    print(task)
//
//                    print(response)
//
//                }
//
//            }, failure: { (task, error) in
//
//
//                //打印连接失败原因
//                print(error)
//            })


//
//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//
//                //参数
////                for (key , value) in para{
////
////                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
////
////
////                }
//
//                //采用post表单上传
//                for str in ImgStrArr{
//
//                    multipartFormData.append( str.data(using: String.Encoding.utf8)! , withName: "File")
//
//                }
//
//                // 参数解释：
//                //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下\
//
////                for i in 0..<self.imageArr.count {
////
////                    let image = self.imageArr[i] as! UIImage
////                    let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
////
////                    let imageName = self.milliStamp + i.description + ".jpeg"
////
////                    multipartFormData.append(data!, withName: "File", fileName: imageName, mimeType: "image/jpeg")
////                }
//
//
//
//
//            }, usingThreshold: UInt64.init(), to: URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "", method: .post, headers: headers, encodingCompletion: { (encodingResult) in
//
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    //连接服务器成功后，对json的处理
//                    upload.responseJSON { response in
//                        //解包
//                        guard let result = response.result.value else { return }
//                        print("json:\(result)")
//
//                        //                            let model = (swiftClassFromString(className: "BaseModel") as? HandyJSON.Type )?.deserialize(from: response)
//
//
//                    }
//                    //获取上传进度
//                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                        print("图片上传进度: \(progress.fractionCompleted)")
//
//
//
//                    }
//                case .failure(let encodingError):
//                    //打印连接失败原因
//                    print(encodingError)
//                }
//
//            })
//
            
            
            
//
//            //上传图片到服务器
//                Alamofire.upload(
//                    multipartFormData: { multipartFormData in
//                        //采用post表单上传
//
//                        for (key , value) in para{
//
//                            multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
//
//
//                        }
//
//                        // 参数解释：
//                        //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下\
//
//                        for i in 0..<self.imageArr.count {
//
//                            let image = self.imageArr[i] as! UIImage
//                            let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
//
//                            let imageName = self.milliStamp + i.description + ".jpeg"
//
//                            multipartFormData.append(data!, withName: "File", fileName: imageName, mimeType: "image/jpeg")
//                        }
//
//
//                },to:getUploadPicturesURL ,encodingCompletion: { encodingResult in
//                    switch encodingResult {
//                    case .success(let upload, _, _):
//                        //连接服务器成功后，对json的处理
//                        upload.responseJSON { response in
//                            //解包
//                            guard let result = response.result.value else { return }
//                            print("json:\(result)")
//
////                            let model = (swiftClassFromString(className: "BaseModel") as? HandyJSON.Type )?.deserialize(from: response)
//
//
//                        }
//                        //获取上传进度
//                        upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                            print("图片上传进度: \(progress.fractionCompleted)")
//
//
//
//                        }
//                    case .failure(let encodingError):
//                        //打印连接失败原因
//                        print(encodingError)
//                    }
//                })
//
            
        }
        
//        let vc = orderDetailVC()
//        vc.orderNo = self.orderNo
//        vc.repairType = orderDetailType.repairing
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    /// 获取当前时间 毫秒级 时间戳 - 13位
    var milliStamp : String {
        
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
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
