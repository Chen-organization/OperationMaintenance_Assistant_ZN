//
//  MeVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/12/13.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Kingfisher

class MeVC: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的"
        
        self.fd_prefersNavigationBarHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)

        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)

        
        self.headImg.isUserInteractionEnabled = true
        let singleTap =  UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        self.headImg.addGestureRecognizer(singleTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = ["userId":model.empNo]
            
            NetworkService.networkGetrequest(currentView: self.view, parameters: para as [String : Any], requestApi: getSysUserUrl, modelClass: "", response: { (obj) in
                
                
                
            }, failture: { (error) in
                
                
            })
            
            
        }
        
    }
    
    
    @objc private func handleSingleTap(tap:UITapGestureRecognizer) {
        print("单击")
        
        let actionSheet=UIActionSheet()
        
        actionSheet.addButton(withTitle:"取消" )//addButtonWithTitle("取消")
        actionSheet.addButton(withTitle:"拍照" )//addButtonWithTitle("动作1")
        actionSheet.addButton(withTitle:"从相册选择" )//addButtonWithTitle("动作2")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.show(in: self.view)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 1{
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ChangePwVC") as! ChangePwVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if indexPath.section == 1{
            
            switch indexPath.row {
                
                case 0:
   
                break
                case 1:

                    break
                case 2:
        
                    break
                case 3:
              
                    break
                case 4:
                     UIApplication.shared.openURL(NSURL.init(string: "tel://01062019488")! as URL)
                    break
                
                default:
                    break
                
            }
            
            
        }else{
            
            if indexPath.row == 0{
                
                
                let sb = UIStoryboard(name: "Me", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "aboutUsVC") as! aboutUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                //退出登录
                ZNCustomAlertView.handleTip("是否确定退出？", isShowCancelBtn: true) { (issure) in
                    
                    if(issure){
                        
                        UserCenter.shared.logOut()
                        let vc = LoginVC.getLoginVC()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                    }
                    
                }
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK : - 控制器方法
    
    
    
    //MARK : - 头像
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        self.headImg.image = image
        
        
        let data = image.jpegData(compressionQuality: 0.4)
        let imageBase64String = data?.base64EncodedString()
        
        self.sendImg(imgStr: imageBase64String!)
        
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func sendImg(imgStr:String) {
        
//        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        YJProgressHUD.showProgress("图片上传..", in: UIApplication.shared.keyWindow)
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = [
                        "empNo":userInfo.empNo ,
                        "file":imgStr
            ]
            
            NetworkService.networkPostrequest(currentView : self.view, parameters: para as! [String : String], requestApi: getModifyAvatarUrl, modelClass: "sendHeadImgModel", response: { (obj) in
                
                let model = obj as! sendHeadImgModel
                
                if model.statusCode == 800{
                    
                    let urlStr = model.returnObj
                    self.headImg.kf.setImage(with: URL.init(string:urlStr!))
                    
                    YJProgressHUD.showSuccess("头像修改成功", inview: UIApplication.shared.keyWindow)
                    
                }else{
                    
                    YJProgressHUD.showSuccess(model.msg, inview: UIApplication.shared.keyWindow)
                }
                
                
            }, failture: { (error) in
                
                
            })
            
        }
        
    }
    
    
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            scrollView.contentOffset.y = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
