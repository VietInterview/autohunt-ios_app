///**
/**
Created by: Hiep Nguyen Nghia on 10/14/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import ACFloatingTextfield_Swift
import Toaster

class ChangePasswordController: BaseViewController {

    @IBOutlet weak var textFieldRetypePass: ACFloatingTextfield!
    @IBOutlet weak var textFieldNewPass: ACFloatingTextfield!
    @IBOutlet weak var textFieldOldPass: ACFloatingTextfield!
    var homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "tick_blue.png"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.tappedMe), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = StringUtils.hexStringToUIColor(hex: "#3C84F7")
        
        textFieldOldPass.font = UIFont(name: "Roboto-Regular", size: 20)
        textFieldNewPass.font = UIFont(name: "Roboto-Regular", size: 20)
        textFieldRetypePass.font = UIFont(name: "Roboto-Regular", size: 20)
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
    @objc override func tappedMe(sender: UITapGestureRecognizer){
        let newpass = self.textFieldNewPass.text!
        let oldpass = self.textFieldOldPass.text!
        let retypepass = self.textFieldRetypePass.text!
        if oldpass.count < 6 || newpass.count < 6 || retypepass.count < 6{
            self.showToast(title: "min_6_character".localize())
        } else if oldpass == newpass {
            let toast = Toast(text: NSLocalizedString("compare_old_new_pass", comment: ""))
            toast.show()
        } else if newpass != retypepass {
            let toast = Toast(text: NSLocalizedString("compare_new_retype_pass", comment: ""))
            toast.show()
        } else {
            self.changePassword()
        }
    }
    func changePassword(){
        view.endEditing(true)
        self.homeViewModel.changePassword(currentPass: self.textFieldOldPass.text!, newPass: self.textFieldNewPass.text!, success: {
            
            }, failure: {error, statusCode in
                if statusCode == 200 {
                    let toast = Toast(text: NSLocalizedString("change_password_success", comment: ""))
                    toast.show()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: InfoAccountController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                } else {
                    if statusCode == 0 {
                        let toast = Toast(text: "Đường truyền bị gián đoan. Vui lòng kiểm tra kết nối mạng.")
                        toast.show()
                    } else {
                        let toast = Toast(text: error)
                        toast.show()
                    }
                }
        })
    }
}
