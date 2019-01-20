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
        
        
        if !(self.imageArr.count > 0) {
            
            YJProgressHUD.showMessage("请上传图片", in: UIApplication.shared.keyWindow, afterDelayTime: 2)
            return
        }
        
        UserCenter.shared.userInfo { (islogin, user) in
            
            
//            http://plat.znxk.net:6801/first/getUploadPictures?companyCode=1009&orgCode=1009001&empNo=E100900003&empName=zf%E6%9C%BA%E6%9E%84&workNo=W100920190100001&type=2
            
            
            let para = [
                        "companyCode":user.companyCode,
                        "empNo":user.empNo,
                        "empName":user.empName,
                        "orgCode":user.orgCode,
                        "workNo":self.orderNo,
                        "type" : "2"
                        ]
            
      
//
//            let manager = AFHTTPSessionManager.init()
//            manager.requestSerializer.timeoutInterval = 40;
//            manager.responseSerializer.acceptableContentTypes = NSSet(arrayLiteral: "text/plain", "multipart/form-data", "application/json", "text/html", "image/jpeg", "image/png", "application/octet-stream", "text/json") as? Set<String>
//
//            let headers: HTTPHeaders =  [    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//                                             "Accept": "application/json",
//                                             ]
//
//            manager.post(getUploadPicturesURL, parameters: para, headers: headers, constructingBodyWith: { (multipartFormData) in
//
//
//
//                    for i in 0..<self.imageArr.count {
//
//                        let image = self.imageArr[i] as! UIImage
//                        let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
//
//                        let imageName = self.milliStamp + i.description + ".jpeg"
//
//                        multipartFormData.appendPart(withFileData: data!, name: "File", fileName: imageName, mimeType: "image/jpeg")
//
//                    }
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
            
            //上传图片到服务器
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        //采用post表单上传

                        for (key , value) in para{
            
                            multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)


                        }

                        // 参数解释：
                        //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下\

                        for i in 0..<self.imageArr.count {

                            let image = self.imageArr[i] as! UIImage
                            let data = image.compress(withMaxLength: 1 * 1024 * 1024 / 8)
                            
                            let imageName = self.milliStamp + i.description + ".jpeg"

                            multipartFormData.append(data!, withName: "File", fileName: imageName, mimeType: "image/jpeg")
                        }
                        

                },to:getUploadPicturesURL ,encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        //连接服务器成功后，对json的处理
                        upload.responseJSON { response in
                            //解包
                            guard let result = response.result.value else { return }
                            print("json:\(result)")

//                            let model = (swiftClassFromString(className: "BaseModel") as? HandyJSON.Type )?.deserialize(from: response)


                        }
                        //获取上传进度
                        upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                            print("图片上传进度: \(progress.fractionCompleted)")

                            

                        }
                    case .failure(let encodingError):
                        //打印连接失败原因
                        print(encodingError)
                    }
                })
            
            
        }
        
        let vc = orderDetailVC()
        vc.orderNo = self.orderNo
        vc.repairType = orderDetailType.repairing

        self.navigationController?.pushViewController(vc, animated: true)
        
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
