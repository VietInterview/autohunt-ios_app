///**
/**
Created by: Hiep Nguyen Nghia on 10/14/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import ACFloatingTextfield_Swift
import Toaster

class ChangePasswordController: UIViewController {

    @IBOutlet weak var textFieldRetypePass: ACFloatingTextfield!
    @IBOutlet weak var textFieldNewPass: ACFloatingTextfield!
    @IBOutlet weak var textFieldOldPass: ACFloatingTextfield!
    var homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "tick_black.png"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.tappedMe), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        textFieldOldPass.font = UIFont(name: "Nunito-Regular", size: 20)
        textFieldNewPass.font = UIFont(name: "Nunito-Regular", size: 20)
        textFieldRetypePass.font = UIFont(name: "Nunito-Regular", size: 20)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "note")
        imageView.image = image
        textFieldOldPass.rightViewMode = UITextFieldViewMode.never
        textFieldOldPass.rightView = imageView
        textFieldNewPass.rightViewMode = UITextFieldViewMode.never
        textFieldNewPass.rightView = imageView
        textFieldRetypePass.rightViewMode = UITextFieldViewMode.never
        textFieldRetypePass.rightView = imageView
    }
    @objc func tappedMe(sender: UITapGestureRecognizer){
        let newpass = self.textFieldNewPass.text!
        let oldpass = self.textFieldOldPass.text!
        let retypepass = self.textFieldRetypePass.text!
        if oldpass.count < 6 || newpass.count < 6 || retypepass.count < 6{
            let toast = Toast(text: "Mật khẩu hợp lệ từ 6 ký tự trở lên")
            toast.show()
        } else if oldpass == newpass {
            let toast = Toast(text: "Mật khẩu mới không được trùng với mật khẩu cũ")
            toast.show()
        } else if newpass != retypepass {
            let toast = Toast(text: "Mật khẩu mới không trùng, vui lòng nhập lại")
            toast.show()
        } else {
            self.changePassword()
        }
    }
    func changePassword(){
        self.homeViewModel.changePassword(currentPass: self.textFieldOldPass.text!, newPass: self.textFieldNewPass.text!, success: {[unowned self]  in
            
            }, failure: {error, statusCode in
                if statusCode == 200 {
                    let toast = Toast(text: "Thay đổi mật khẩu thành công")
                    toast.show()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: InfoAccountController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                } else {
                    let toast = Toast(text: "Mật khẩu không đúng vui lòng thử lại")
                    toast.show()
                }
        })
    }
}
