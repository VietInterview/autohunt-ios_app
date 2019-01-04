//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
class SignInViewController: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate  {
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var verticalPass: UIView!
    @IBOutlet weak var verticalUser: UIView!
    @IBOutlet weak var imgNoteUser: UIImageView!
    @IBOutlet weak var imgNotePass: UIImageView!
    @IBOutlet weak var passwordField: DesignableUITextField!
    @IBOutlet weak var emailField: DesignableUITextField!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var mViewUser: UIView!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet var mViewSuccess: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgPass: UIImageView!
    @IBOutlet var mViewContact: UIView!
    var viewModel = SignInViewModelWithCredentials()
    var effect:UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.setRoundBorders(5)
        imgNoteUser.isHidden = true
        imgNotePass.isHidden = true
        mViewSuccess.layer.cornerRadius = 5
        mViewContact.layer.cornerRadius = 5
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        if !MFMailComposeViewController.canSendMail() {
        }
        
        mViewUser.layer.borderWidth = 0.5
        mViewUser.layer.borderColor = UIColor.black.cgColor
        mViewPassword.layer.borderWidth = 0.5
        mViewPassword.layer.borderColor = UIColor.black.cgColor
        
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        if self.isAppAlreadyLaunchedOnce() {
            if let session = SessionManager.currentSession {
                UserDefaults.standard.set(3, forKey: "position")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "IntroController")], animated: false)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: UInt(2))
            mainViewController.leftViewWidth = 0
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
        }
        self.emailField.addTarget(self, action: #selector(textFieldEmailDidChange(_:)), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(textFieldPasDidChange(_:)), for: .editingChanged)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        lblLogin.isUserInteractionEnabled=true
        lblLogin.addGestureRecognizer(gestureSwift2AndHigher2)
        
        if Env.isProduction() == true {
            lblLogin.text = "\(NSLocalizedString("login", comment: ""))"
            lblLogin.textColor = StringUtils.shared.hexStringToUIColor(hex: "#191830")
        } else {
            lblLogin.text = "\(NSLocalizedString("login", comment: "")) Dev Mode"
            lblLogin.textColor = StringUtils.shared.hexStringToUIColor(hex: "#f97292")
        }
    }
    var dem: Int = 0
    @objc func someAction2(sender:UITapGestureRecognizer){
        if dem < 7 {
            dem = dem + 1
            App.setBaseUrl()
            Env.setProductionTrue()
            debugLog(object: Env.isProduction())
            debugLog(object: App.baseUrl)
            lblLogin.text = "\(NSLocalizedString("login", comment: ""))"
            lblLogin.textColor = StringUtils.shared.hexStringToUIColor(hex: "#000000")
        }else{
            dem = dem - 1
            Env.setProductionFalse()
            App.setBaseUrlDev()
            debugLog(object: Env.isProduction())
            debugLog(object: App.baseUrl)
            lblLogin.text = "\(NSLocalizedString("login", comment: "")) Dev Mode"
            lblLogin.textColor = StringUtils.shared.hexStringToUIColor(hex: "#f97292")
        }
    }
    @objc func textFieldEmailDidChange(_ textField: UITextField) {
        imgNoteUser.isHidden = true
    }
    @objc func textFieldPasDidChange(_ textField: UITextField) {
        imgNotePass.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField.self{
            imgUser.image = UIImage(named: "Shape_focus")
            imgPass.image = UIImage(named: "pass")
            
            mViewUser.layer.borderWidth = 0.5
            mViewUser.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor
            verticalUser.layer.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor
            mViewPassword.layer.borderWidth = 0.5
            mViewPassword.layer.borderColor = UIColor.black.cgColor
            verticalPass.layer.backgroundColor = UIColor.black.cgColor
        } else {
            imgUser.image = UIImage(named: "Shape")
            imgPass.image = UIImage(named: "pass_focus")
            mViewUser.layer.borderWidth = 0.5
            mViewUser.layer.borderColor = UIColor.black.cgColor
            mViewPassword.layer.borderWidth = 0.5
            mViewPassword.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor
            verticalPass.layer.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor
            verticalUser.layer.backgroundColor = UIColor.black.cgColor
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func dismissPopUpTouch(_ sender: Any) {
        animateOutForgotPass()
    }
    func animateIn() {
        self.view.addSubview(mViewSuccess)
        mViewSuccess.center = self.view.center
        mViewSuccess.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mViewSuccess.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.visualEffectView.isHidden = false
            self.mViewSuccess.alpha = 1
            self.mViewSuccess.transform = CGAffineTransform.identity
        }
    }
    func animateInForgotPass() {
        self.view.addSubview(mViewContact)
        mViewContact.center = self.view.center
        
        mViewContact.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mViewContact.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            
            self.visualEffectView.isHidden = false
            self.mViewContact.alpha = 1
            self.mViewContact.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.mViewSuccess.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mViewSuccess.alpha = 0
            
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.mViewSuccess.removeFromSuperview()
        }
    }
    func animateOutForgotPass () {
        UIView.animate(withDuration: 0.3, animations: {
            self.mViewContact.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mViewContact.alpha = 0
            
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.mViewContact.removeFromSuperview()
        }
    }
    // MARK: - Actions
    @IBAction func makePhoneCallTouch(_ sender: Any) {
        "02466629448".makeAColl()
    }
    
    @IBAction func sendEmailTouch(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["getbee@vietinterview.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    @IBAction func dismissSuccessPopup(_ sender: Any) {
        animateOut()
    }
    @IBAction func credentialsChanged(_ sender: UITextField) {
        let newValue = sender.text ?? ""
        switch sender {
        case emailField:
            viewModel.email = newValue
        case passwordField:
            viewModel.password = newValue
        default: break
        }
    }
    
    @IBAction func forgetPassTouch(_ sender: Any) {
        animateInForgotPass()
    }
    @IBAction func tapOnSignInButton(_ sender: Any) {
        if self.emailField.text! == ""{
            self.imgNoteUser.isHidden = false
            var placeHolder = NSMutableAttributedString()
            let Name  = NSLocalizedString("input_email", comment: "")
            placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedStringKey.font:UIFont(name: "Roboto-Regular", size: 18.0)!])
            placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))
            
            emailField.attributedPlaceholder = placeHolder
        }else if self.passwordField.text! == "" {
            self.imgNotePass.isHidden = false
            var placeHolder = NSMutableAttributedString()
            let Name  = NSLocalizedString("input_pass", comment: "")
            placeHolder = NSMutableAttributedString(string:Name, attributes: [NSAttributedStringKey.font:UIFont(name: "Roboto-Regular", size: 18.0)!])
            placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))
            passwordField.attributedPlaceholder = placeHolder
        }else{
            LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
            viewModel.login(success: { [unowned self] in
                LoadingOverlay.shared.hideOverlayView()
                UserDefaults.standard.set(3, forKey: "position")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                
                navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
                
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(2))
                
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
                
                }, failure: { [unowned self] error in
                    UIApplication.hideNetworkActivity()
                    self.animateIn()
                    //                self.showMessage(title: "Thông báo", message: "Thông tin đăng nhập không đúng")
            })
        }
    }
}
extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
