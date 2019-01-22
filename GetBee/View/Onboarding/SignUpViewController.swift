//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldCompanyName: UITextField!
    @IBOutlet weak var textFieldBirthday: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFullname: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var jobTextField: UITextField!
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
    @IBOutlet weak var imgBirthday: UIImageView!
    @IBOutlet weak var viewChooseDateTime: UIView!
    @IBOutlet weak var imgPolicy: UIImageView!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var lblPolicy: UILabel!
    
    var viewModel = SignUpViewModelWithEmail()
    var effect:UIVisualEffect!
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    var isAgree:Bool = false
    
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
        signUp.layer.cornerRadius = 5
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor.clear.cgColor
        self.textFieldEmail.delegate = self
        self.textFieldFullname.delegate = self
        self.textFieldPhone.delegate = self
        self.jobTextField.delegate = self
        self.textFieldEmail.addTarget(self, action: #selector(textFieldEmailDidChange(_:)), for: .editingChanged)
        self.textFieldFullname.addTarget(self, action: #selector(textFieldFullNameDidChange(_:)), for: .editingChanged)
        self.textFieldPhone.addTarget(self, action: #selector(textFieldPhoneDidChange(_:)), for: .editingChanged)
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imgBirthday.isUserInteractionEnabled = true
        self.imgBirthday.addGestureRecognizer(gestureSwift2AndHigher2)
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction3))
        self.viewPolicy.isUserInteractionEnabled = true
        self.viewPolicy.addGestureRecognizer(gestureSwift2AndHigher3)
    }
    @objc func someAction3(sender:UITapGestureRecognizer){
        if self.isAgree {
            self.isAgree = false
            self.imgPolicy.image = UIImage(named: "oval-1")
        } else {
            self.isAgree = true
            self.imgPolicy.image = UIImage(named: "tickok")
        }
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        view.endEditing(true)
        viewChooseDateTime.isHidden = false
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 200))
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.locale! = Locale(identifier: "vi-VI")
        self.datePicker?.datePickerMode = UIDatePickerMode.date
        viewChooseDateTime.addSubview(self.datePicker)
        toolBar = UIToolbar()
        toolBar!.barStyle = .default
        toolBar!.isTranslucent = true
        toolBar!.tintColor = UIColor.black
        toolBar!.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateEditInterviewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateEditInterviewController.cancelClick))
        toolBar!.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar!.items![0].setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        toolBar!.items![2].setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        toolBar!.isUserInteractionEnabled = true
        self.viewChooseDateTime.addSubview(toolBar!)
        toolBar!.isHidden = false
    }
    var somedateString:String = ""
    var somedateString2:Int = 0
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en-EN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        somedateString = dateFormatter.string(from: self.datePicker.date)
        self.textFieldBirthday.text = somedateString
        dateFormatter.dateFormat = "yyyyMMdd"
        somedateString2 = Int(dateFormatter.string(from: self.datePicker.date))!
        debugLog(object: somedateString2)
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
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
        verticalUser.layer.backgroundColor = textField == textFieldFullname.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalEmail.layer.backgroundColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalPhone.layer.backgroundColor = textField == textFieldPhone.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
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
        
        let string = "Đồng ý với điều khoản sử dụng của Getbee"
        let range = (string as NSString).range(of: "điều khoản")
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), range: range)
        attributedString.addAttribute(NSAttributedStringKey.link, value: "http://www.google.fr", range: range)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedStringKey.underlineColor, value: StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), range: range)
        self.lblPolicy.attributedText = attributedString
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
        } else if self.somedateString2 == 0 {
            self.showMessage(title: "Thông báo", message: "Hãy chọn ngày sinh nhật")
        } else if self.isAgree == false {
            self.showMessage(title: "Thông báo", message: "Bạn phải đồng ý với điều khoản")
        } else {
            viewModel.signup(email: self.textFieldEmail.text!, address: "", carrer: self.jobTextField.text!, fullName: self.textFieldFullname.text!, phone: self.textFieldPhone.text!,companyName: StringUtils.shared.checkEmpty(value: self.textFieldCompanyName.text),mType: 7,contact: "",birthday: self.somedateString2 , success: {
                self.animateIn()
            }, failure: {error in
                if error == "error.userexists" {
                    self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("email_esxit", comment: ""))
                }
            })
        }
    }
}
