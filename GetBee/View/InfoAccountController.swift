///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ACFloatingTextfield_Swift
import Toaster

class InfoAccountController: BaseViewController,UIGestureRecognizerDelegate, ChooseMultiDelegate {
    
    @IBOutlet weak var lblCarrerHunt: UILabel!
    @IBOutlet weak var mViewCarrerHunt: UIView!
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
        self.title = NSLocalizedString("profile", comment: "")
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        gestureSwift2AndHigher.delegate = self
        self.lblCarrerHunt.isUserInteractionEnabled = true
        self.lblCarrerHunt.addGestureRecognizer(gestureSwift2AndHigher)
        textfieldFullname.font = UIFont(name: "Roboto-Regular", size: 20)
        textfieldPhone.font = UIFont(name: "Roboto-Regular", size: 20)
        textFieldEmail.font = UIFont(name: "Roboto-Regular", size: 20)
        textFieldAdd.font = UIFont(name: "Roboto-Regular", size: 20)
        textFieldCarrer.font = UIFont(name: "Roboto-Regular", size: 20)
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
                self.lblCarrerHunt.text = appenString
            }
        }, failure: { error in
            print("User Profile Error: " + error)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func gotoCarrerTouch(_ sender: Any) {
        vc.isCarrer = true
        vc.isStatus = false
        vc.isCity = false
        vc.isCity = false
        vc.isMultiChoice = true
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        vc.isCarrer = true
        vc.isStatus = false
        vc.isCity = false
        vc.isCity = false
        vc.isMultiChoice = true
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changePassTouchup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
        vc.title = NSLocalizedString("change_pass_tit", comment: "")
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func saveProfileTouch(_ sender: Any) {
        view.endEditing(true)
        if self.mychooseMulti.count > 0 {
            self.desideratedCareer.removeAll()
            for i in 0...self.mychooseMulti.count - 1 {
                self.desideratedCareer.append(DesideratedCareer(id: mychooseMulti[i].id,name: mychooseMulti[i].name))
            }
        }
        viewModel.saveMyProfile(fullName: self.textfieldFullname.text!, phone: self.textfieldPhone.text!, address: self.textFieldAdd.text!, carrer: self.textFieldCarrer.text!, arrCaerrerhunt: self.desideratedCareer, success: {user in
            let toast = Toast(text: NSLocalizedString("update_profile_success", comment: ""))
            toast.show()
        }, failure: {error in
            let toast = Toast(text: NSLocalizedString("update_profile_fail", comment: ""))
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
        self.lblCarrerHunt.text = appenString
    }
    
}
extension UILabel {
    
    func addImageWith(name: String, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
