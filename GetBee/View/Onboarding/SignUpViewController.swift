//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFullname: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet weak var mViewConfirmPass: UIView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var mView: UIView!
    @IBOutlet var mViewPopUp: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgNoteUser: UIImageView!
    @IBOutlet weak var imgNoteEMail: UIImageView!
    @IBOutlet weak var imgNotePhone: UIImageView!
    @IBOutlet weak var verticalUser: UIView!
    @IBOutlet weak var verticalEmail: UIView!
    @IBOutlet weak var verticalPhone: UIView!
    
    var viewModel = SignUpViewModelWithEmail()
    var effect:UIVisualEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.setRoundBorders(22)
        viewModel.onFormChange = { [unowned self] in
            self.signUp.isEnabled = self.viewModel.hasValidData
        }
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        mViewPopUp.layer.cornerRadius = 5
        
        mViewEmail.layer.borderWidth = 0.5
        mViewEmail.layer.borderColor = UIColor.black.cgColor
        mViewPassword.layer.borderWidth = 0.5
        mViewPassword.layer.borderColor = UIColor.black.cgColor
        mViewConfirmPass.layer.borderWidth = 0.5
        mViewConfirmPass.layer.borderColor = UIColor.black.cgColor
        
        signUp.layer.cornerRadius = 5
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor.clear.cgColor
        
        jobTextField.layer.cornerRadius = 5.0
        jobTextField.layer.borderWidth = 0.5
        jobTextField.layer.borderColor = UIColor.black.cgColor
        
        addTextField.layer.cornerRadius = 5.0
        addTextField.layer.borderWidth = 0.5
        addTextField.layer.borderColor = UIColor.black.cgColor
        
        jobTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: jobTextField.frame.height))
        jobTextField.leftViewMode = .always
        
        addTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: addTextField.frame.height))
        addTextField.leftViewMode = .always
        
        self.textFieldEmail.delegate = self
        self.textFieldFullname.delegate = self
        self.textFieldPhone.delegate = self
        self.jobTextField.delegate = self
        self.addTextField.delegate = self
        
        self.textFieldEmail.addTarget(self, action: #selector(textFieldEmailDidChange(_:)), for: .editingChanged)
        self.textFieldFullname.addTarget(self, action: #selector(textFieldFullNameDidChange(_:)), for: .editingChanged)
        self.textFieldPhone.addTarget(self, action: #selector(textFieldPhoneDidChange(_:)), for: .editingChanged)
    }
    @objc func textFieldEmailDidChange(_ textField: UITextField) {
        imgNoteEMail.isHidden = false
        imgNoteEMail.visible()
        imgNoteEMail.image = StringUtils.shared.isValidEmail(testStr: self.textFieldEmail.text!) ? UIImage(named: "tickok") : UIImage(named: "note")
    }
    @objc func textFieldFullNameDidChange(_ textField: UITextField) {
        imgNoteUser.isHidden = true
    }
    @objc func textFieldPhoneDidChange(_ textField: UITextField) {
        imgNotePhone.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.imgUser.image = textField == textFieldFullname.self ? UIImage(named: "Shape_focus") : UIImage(named: "Shape")
        self.imgEmail.image = textField == textFieldEmail.self ? UIImage(named: "mail_focus") : UIImage(named: "mail")
        self.imgPhone.image = textField == textFieldPhone.self ? UIImage(named: "phone_focus") : UIImage(named: "phone")
        
        mViewEmail.layer.borderColor = textField == textFieldFullname.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        mViewPassword.layer.borderColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        mViewConfirmPass.layer.borderColor = textField == textFieldPhone.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        
        verticalUser.layer.backgroundColor = textField == textFieldFullname.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        verticalEmail.layer.backgroundColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        verticalPhone.layer.backgroundColor = textField == textFieldPhone.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        
        jobTextField.layer.borderColor = textField == jobTextField.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
        addTextField.layer.borderColor = textField == addTextField.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : UIColor.black.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    func animateIn() {
        self.view.addSubview(mViewPopUp)
        mViewPopUp.center = self.view.center
        
        mViewPopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mViewPopUp.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            
            self.visualEffectView.isHidden = false
            self.mViewPopUp.alpha = 1
            self.mViewPopUp.transform = CGAffineTransform.identity
        }
    }
    
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.mViewPopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mViewPopUp.alpha = 0
            
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.mViewPopUp.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.mView.layer.masksToBounds = false
        self.mView.layer.shadowColor = UIColor.black.cgColor
        self.mView.layer.shadowOpacity = 0.5
        self.mView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.mView.layer.shadowRadius = 5
        self.mView.layer.shadowPath = UIBezierPath(rect: self.mView.bounds).cgPath
        self.mView.layer.shouldRasterize = true
        self.mView.layer.rasterizationScale = UIScreen.main.scale
    }
    @IBAction func dismissPopUpTuoch(_ sender: Any) {
        animateOut()
        performSegue(withIdentifier: "gotosignin", sender: self)
    }
    @IBAction func formEditingChange(_ sender: UITextField) {
        let newValue = sender.text ?? ""
        switch sender {
            //        case textFieldEmail:
            //            viewModel.email = newValue
            //        case passwordField:
            //            viewModel.password = newValue
            //        case passwordConfirmationField:
        //            viewModel.passwordConfirmation = newValue
        default: break
        }
    }
    
    @IBAction func tapOnSignUpButton(_ sender: Any) {
        let fullname = textFieldFullname.text!
        let email = textFieldEmail.text!
        let phone = textFieldPhone.text!
        if fullname.count == 0 && email.count == 0 && phone.count == 0 {
            self.imgNoteUser.isHidden = false
            var placeHolder = NSMutableAttributedString()
            let Name  = NSLocalizedString("input_name", comment: "")
            placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))
            
            textFieldFullname.attributedPlaceholder = placeHolder
            self.imgNotePhone.isHidden = false
            var placeHolderPhone = NSMutableAttributedString()
            let sdt  = NSLocalizedString("input_phone", comment: "")
            placeHolderPhone = NSMutableAttributedString(string:sdt, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolderPhone.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:sdt.count))
            
            textFieldPhone.attributedPlaceholder = placeHolderPhone
            self.imgNoteEMail.isHidden = false
            var placeHolderMail = NSMutableAttributedString()
            let Mail  = NSLocalizedString("input_email", comment: "")
            placeHolderMail = NSMutableAttributedString(string:Mail, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolderMail.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Mail.count))
            
            textFieldEmail.attributedPlaceholder = placeHolderMail
        } else if fullname.count == 0 {
            self.imgNoteUser.isHidden = false
            var placeHolder = NSMutableAttributedString()
            let Name  = NSLocalizedString("input_name", comment: "")
            placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))
            
            textFieldFullname.attributedPlaceholder = placeHolder
            } else if email.count == 0 {
            self.imgNoteEMail.isHidden = false
            var placeHolderMail = NSMutableAttributedString()
            let Mail  = NSLocalizedString("input_email", comment: "")
            placeHolderMail = NSMutableAttributedString(string:Mail, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolderMail.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Mail.count))
            
            textFieldEmail.attributedPlaceholder = placeHolderMail
            } else if phone.count == 0 {
            self.imgNotePhone.isHidden = false
            var placeHolderPhone = NSMutableAttributedString()
            let sdt  = NSLocalizedString("input_phone", comment: "")
            placeHolderPhone = NSMutableAttributedString(string:sdt, attributes: [NSAttributedStringKey.font:UIFont(name: "Nunito-Regular", size: 18.0)!])
            placeHolderPhone.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:sdt.count))
            
            textFieldPhone.attributedPlaceholder = placeHolderPhone
            }else {
                viewModel.signup(email: self.textFieldEmail.text!, address: self.addTextField.text!, carrer: self.jobTextField.text!, fullName: self.textFieldFullname.text!, phone: self.textFieldPhone.text!, success: {
                    self.animateIn()
                }, failure: {error in
                    debugLog(object: error)
                    if error == "error.userexists" {
                        debugLog(object: "Địa chỉ email này đã tồn tại trong hệ thống, vui lòng đăng ký e-mail khác")
                        self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("email_esxit", comment: ""))
                    }
                })
        }
    }
}
