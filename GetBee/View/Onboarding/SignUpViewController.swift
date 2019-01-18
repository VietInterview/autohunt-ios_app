//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, UITextFieldDelegate {
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
        
        mViewEmail.layer.borderWidth = 1
        mViewEmail.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        mViewPassword.layer.borderWidth = 1
        mViewPassword.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        mViewConfirmPass.layer.borderWidth = 1
        mViewConfirmPass.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        
        signUp.layer.cornerRadius = 5
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor.clear.cgColor
        
        jobTextField.layer.cornerRadius = 5.0
        jobTextField.layer.borderWidth = 1
        jobTextField.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        
        addTextField.layer.cornerRadius = 5.0
        addTextField.layer.borderWidth = 1
        addTextField.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        
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
        
        mViewEmail.layer.borderColor = textField == textFieldFullname.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        mViewPassword.layer.borderColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        mViewConfirmPass.layer.borderColor = textField == textFieldPhone.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        
        verticalUser.layer.backgroundColor = textField == textFieldFullname.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalEmail.layer.backgroundColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalPhone.layer.backgroundColor = textField == textFieldPhone.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        
        jobTextField.layer.borderColor = textField == jobTextField.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        addTextField.layer.borderColor = textField == addTextField.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
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
        super.viewDidAppear(true)
        self.mView.layer.masksToBounds = false
        self.mView.layer.shadowColor = StringUtils.shared.hexStringToUIColor(hex: "#191830").cgColor
        self.mView.layer.shadowOpacity = 15/100
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
        _ = sender.text ?? ""
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
            textFieldFullname.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_name", comment: ""),
                                                                         attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
            self.imgNotePhone.isHidden = false
            textFieldPhone.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_phone", comment: ""),
                                                                      attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
            self.imgNoteEMail.isHidden = false
            textFieldEmail.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_email", comment: ""),
                                                                      attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if fullname.count == 0 {
            self.imgNoteUser.isHidden = false
            textFieldFullname.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_name", comment: ""),
                                                                         attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if email.count == 0 {
            self.imgNoteEMail.isHidden = false
            textFieldEmail.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_email", comment: ""),
                                                                      attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if phone.count == 0 {
            self.imgNotePhone.isHidden = false
            textFieldPhone.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_phone", comment: ""),
                                                                      attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        }else {
            viewModel.signup(email: self.textFieldEmail.text!, address: self.addTextField.text!, carrer: self.jobTextField.text!, fullName: self.textFieldFullname.text!, phone: self.textFieldPhone.text!,companyName: "companyName:String",mType: 2,contact: "contact:String",birthday: 19910812 , success: {
                self.animateIn()
            }, failure: {error in
                if error == "error.userexists" {
                    self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("email_esxit", comment: ""))
                }
            })
        }
    }
}
