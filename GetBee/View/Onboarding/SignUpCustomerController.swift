///**
/**
Created by: Hiep Nguyen Nghia on 1/18/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class SignUpCustomerController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var textFieldCompanyName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhonenumber: UITextField!
    @IBOutlet weak var textFieldContact: UITextField!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var btnSignupCustomer: UIButton!
    @IBOutlet var mViewPopup: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var imgNoteEMail: UIImageView!
    @IBOutlet weak var imgNoteUser: UIImageView!
    @IBOutlet weak var imgNotePhone: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var verticalUser: UIView!
    @IBOutlet weak var verticalEmail: UIView!
    @IBOutlet weak var verticalPhone: UIView!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgBirthday: UIImageView!
    @IBOutlet weak var imgNoteContact: UIImageView!
    @IBOutlet weak var lineContact: UIView!
    @IBOutlet weak var imgPolicy: UIImageView!
    @IBOutlet weak var lblPolicy: UILabel!
    
    let viewModel = SignUpViewModelWithEmail()
    var effect:UIVisualEffect!
    var isAgree:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        self.textFieldEmail.delegate = self
        self.textFieldCompanyName.delegate = self
        self.textFieldPhonenumber.delegate = self
        self.textFieldContact.delegate = self
        self.textFieldEmail.addTarget(self, action: #selector(textFieldEmailDidChange(_:)), for: .editingChanged)
        self.textFieldCompanyName.addTarget(self, action: #selector(textFieldCompanyNameDidChange(_:)), for: .editingChanged)
        self.textFieldPhonenumber.addTarget(self, action: #selector(textFieldPhoneDidChange(_:)), for: .editingChanged)
         self.textFieldContact.addTarget(self, action: #selector(textFieldContactDidChange(_:)), for: .editingChanged)
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.viewPolicy.isUserInteractionEnabled = true
        self.viewPolicy.addGestureRecognizer(gestureSwift2AndHigher2)
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        if self.isAgree {
            self.isAgree = false
            self.imgPolicy.image = UIImage(named: "oval-1")
        } else {
            self.isAgree = true
            self.imgPolicy.image = UIImage(named: "tickok")
        }
    }
    @objc func textFieldEmailDidChange(_ textField: UITextField) {
        imgNoteEMail.isHidden = false
        imgNoteEMail.visible()
        imgNoteEMail.image = StringUtils.shared.isValidEmail(testStr: self.textFieldEmail.text!) ? UIImage(named: "tickok") : UIImage(named: "note")
    }
    @objc func textFieldCompanyNameDidChange(_ textField: UITextField) {
        imgNoteUser.isHidden = true
    }
    @objc func textFieldPhoneDidChange(_ textField: UITextField) {
        imgNotePhone.isHidden = true
    }
    @objc func textFieldContactDidChange(_ textField: UITextField) {
        imgNotePhone.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.imgUser.image = textField == textFieldCompanyName.self ? UIImage(named: "Shape_focus") : UIImage(named: "Shape")
        self.imgEmail.image = textField == textFieldEmail.self ? UIImage(named: "mail_focus") : UIImage(named: "mail")
        self.imgPhone.image = textField == textFieldPhonenumber.self ? UIImage(named: "phone_focus") : UIImage(named: "phone")
        self.imgBirthday.image = textField == textFieldContact.self ? UIImage(named: "contact_focus") : UIImage(named: "contact")
        verticalUser.layer.backgroundColor = textField == textFieldCompanyName.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalEmail.layer.backgroundColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        verticalPhone.layer.backgroundColor = textField == textFieldPhonenumber.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
        lineContact.layer.backgroundColor = textField == textFieldContact.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewInput.shadowView(opacity: 15/100, radius: 5, color: "#191830")
        
        let string = "Đồng ý với điều khoản sử dụng của Getbee"
        let range = (string as NSString).range(of: "điều khoản")
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), range: range)
        attributedString.addAttribute(NSAttributedStringKey.link, value: "http://www.google.fr", range: range)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedStringKey.underlineColor, value: StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), range: range)
        self.lblPolicy.attributedText = attributedString
    }
    func animateIn() {
        self.view.addSubview(mViewPopup)
        mViewPopup.center = self.view.center
        mViewPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mViewPopup.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.visualEffectView.isHidden = false
            self.mViewPopup.alpha = 1
            self.mViewPopup.transform = CGAffineTransform.identity
        }
    }
    @IBAction func dismissPopUpTuoch(_ sender: Any) {
        animateOut()
        performSegue(withIdentifier: "gotosignin", sender: self)
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.mViewPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mViewPopup.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.mViewPopup.removeFromSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func signupCustomerTouch() {
        if self.textFieldCompanyName.text == "" {
            self.imgNoteUser.isHidden = false
            textFieldCompanyName.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_name", comment: ""),
                                                                         attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if self.textFieldEmail.text == "" {
            self.imgNoteEMail.isHidden = false
            textFieldEmail.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_name", comment: ""),
                                                                            attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if self.textFieldPhonenumber.text == "" {
            self.imgNotePhone.isHidden = false
            textFieldPhonenumber.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_name", comment: ""),
                                                                            attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if self.textFieldContact.text == "" {
            self.imgNoteContact.isHidden = false
            textFieldContact.attributedPlaceholder = NSAttributedString(string: "Xin hãy nhập người liên hệ",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else if self.isAgree == false {
            self.showMessage(title: "Thông báo", message: "Bạn phải đồng ý với điều khoản sử dụng của GetBee")
        } else {
            viewModel.signup(email: self.textFieldEmail.text!, address: "", carrer: "", fullName: self.textFieldCompanyName.text!, phone: self.textFieldPhonenumber.text!,companyName: StringUtils.shared.checkEmpty(value: self.textFieldCompanyName.text),mType: 7,contact: StringUtils.shared.checkEmpty(value: self.textFieldContact.text) ,birthday: 0 , success: {
                self.animateIn()
            }, failure: {error in
                if error == "error.userexists" {
                    self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("email_esxit", comment: ""))
                }
            })
        }
    }
}
