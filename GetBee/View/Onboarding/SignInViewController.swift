//
//  SignInViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var mViewUser: UIView!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet var mViewSuccess: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var mViewContact: UIView!
    var viewModel = SignInViewModelWithCredentials()
    var effect:UIVisualEffect!
    // MARK: - Lifecycle Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.setRoundBorders(22)
        viewModel.onCredentialsChange = { [unowned self] in
            self.btnLogin.isEnabled = self.viewModel.hasValidCredentials
        }
        mViewSuccess.layer.cornerRadius = 5
        mViewContact.layer.cornerRadius = 5
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        self.mView.layer.masksToBounds = false
        self.mView.layer.shadowColor = UIColor.black.cgColor
        self.mView.layer.shadowOpacity = 0.5
        self.mView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.mView.layer.shadowRadius = 5
        self.mView.layer.shadowPath = UIBezierPath(rect: self.mView.bounds).cgPath
        self.mView.layer.shouldRasterize = true
        self.mView.layer.rasterizationScale = UIScreen.main.scale
        
        mViewUser.layer.borderWidth = 0.5
        mViewUser.layer.borderColor = UIColor.black.cgColor
        mViewPassword.layer.borderWidth = 0.5
        mViewPassword.layer.borderColor = UIColor.black.cgColor
        
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true;
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func dismissPopUpTouch(_ sender: Any) {
        animateOutForgotPass()
    }
    // MARK: - Actions
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
        animateIn()
        //        UIApplication.showNetworkActivity()
        //
        //        viewModel.login(success: { [unowned self] in
        //            UIApplication.hideNetworkActivity()
        //            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        //            UIApplication.shared.keyWindow?.rootViewController = homeVC
        //            }, failure: { [unowned self] error in
        //                UIApplication.hideNetworkActivity()
        //                self.showMessage(title: "Error", message: error)
        //        })

        let parameters = [
            "password": "admin",
            "rememberMe": true,
            "username": "admin"
            ] as [String : Any]
//        let headers = [
//            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
        Alamofire.request("http://54.176.149.102:8081/api/authenticate", method: .post, parameters: parameters, encoding:JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
        }
    }
}
