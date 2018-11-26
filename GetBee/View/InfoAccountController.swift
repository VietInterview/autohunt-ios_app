///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ACFloatingTextfield_Swift
import Toaster

class InfoAccountController: UIViewController, ChooseMultiDelegate {
    
    @IBOutlet weak var mViewCarrerHunt: UIView!
    @IBOutlet weak var textViewCarrerHunt: UITextView!
    var vc = CarrerOrCityController()
    @IBOutlet weak var textFieldCarrer: ACFloatingTextfield!
    @IBOutlet weak var textFieldAdd: ACFloatingTextfield!
    @IBOutlet weak var textFieldEmail: ACFloatingTextfield!
    @IBOutlet weak var textfieldPhone: ACFloatingTextfield!
    @IBOutlet weak var textfieldFullname: ACFloatingTextfield!
    var desideratedCareer = [DesideratedCareer]()
    var viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        self.title = "Thông tin cá nhân"
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.mViewCarrerHunt.addGestureRecognizer(gestureSwift2AndHigher)
        self.textViewCarrerHunt.addGestureRecognizer(gestureSwift2AndHigher)
        textfieldFullname.font = UIFont(name: "Nunito-Regular", size: 20)
        textfieldPhone.font = UIFont(name: "Nunito-Regular", size: 20)
        textFieldEmail.font = UIFont(name: "Nunito-Regular", size: 20)
        textFieldAdd.font = UIFont(name: "Nunito-Regular", size: 20)
        textFieldCarrer.font = UIFont(name: "Nunito-Regular", size: 20)
        
        //        textFieldCarrer.rightViewMode = UITextFieldViewMode.always
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //        let image = UIImage(named: "note")
        //        imageView.image = image
        //        textFieldCarrer.rightView = imageView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        
        viewModel.loadUserProfile(success: { userProfile in
            self.textfieldFullname.text = StringUtils.shared.checkEmpty(value: userProfile.fullNameColl)
            self.textfieldPhone.text = StringUtils.shared.checkEmpty(value: userProfile.phoneColl)
            self.textFieldEmail.text = StringUtils.shared.checkEmpty(value: userProfile.emailColl)
            self.textFieldAdd.text = StringUtils.shared.checkEmpty(value: userProfile.addressColl)
            self.textFieldCarrer.text = StringUtils.shared.checkEmpty(value: userProfile.careerColl)
            var appenString: String = ""
            if let arrCarrer = userProfile.desideratedCareer {
                self.desideratedCareer = arrCarrer
                for i in 0...arrCarrer.count - 1 {
                    if i == arrCarrer.count - 1{
                        appenString.append(arrCarrer[i].name!)
                    } else {
                        appenString.append("\(arrCarrer[i].name!), ")
                    }
                }
                self.textViewCarrerHunt.text = appenString
            }
        }, failure: { error in
            print("User Profile Error: " + error)
        })
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        vc.isCarrer = true
        vc.isStatus = false
        vc.isCity = false
        vc.isCity = false
        vc.isMultiChoice = true
        vc.title = "Ngành nghề"
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changePassTouchup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
        vc.title = "Thay đổi mật khẩu"
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func saveProfileTouch(_ sender: Any) {
        if self.mychooseMulti.count > 0 {
            self.desideratedCareer.removeAll()
            for i in 0...self.mychooseMulti.count - 1 {
                self.desideratedCareer.append(DesideratedCareer(id: mychooseMulti[i].id,name: mychooseMulti[i].name))
            }
        }
        viewModel.saveMyProfile(fullName: self.textfieldFullname.text!, phone: self.textfieldPhone.text!, address: self.textFieldAdd.text!, carrer: self.textFieldCarrer.text!, arrCaerrerhunt: self.desideratedCareer, success: {user in
            let toast = Toast(text: "Update success")
            toast.show()
        }, failure: {error in
            let toast = Toast(text: "Update fail")
            toast.show()
        })
    }
    var mychooseMulti = [MyChoose]()
    func didChooseMulti(mychooseMulti: [MyChoose]) {
        self.mychooseMulti = mychooseMulti
        var appenString: String = ""
        for i in 0...mychooseMulti.count - 1 {
            if i == mychooseMulti.count - 1{
                appenString.append(mychooseMulti[i].name)
            } else {
                appenString.append("\(mychooseMulti[i].name), ")
            }
        }
        self.textViewCarrerHunt.text = appenString
    }
    
}
