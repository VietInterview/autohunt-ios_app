//
//  SignUpViewController.swift
//  ios-base
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet weak var mViewConfirmPass: UIView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var mView: UIView!
    @IBOutlet var mViewPopUp: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var viewModel = SignUpViewModelWithEmail()
    var effect:UIVisualEffect!
    // MARK: - Lifecycle Events
    
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
        self.mView.layer.masksToBounds = false
        self.mView.layer.shadowColor = UIColor.black.cgColor
        self.mView.layer.shadowOpacity = 0.5
        self.mView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.mView.layer.shadowRadius = 5
        self.mView.layer.shadowPath = UIBezierPath(rect: self.mView.bounds).cgPath
        self.mView.layer.shouldRasterize = true
        self.mView.layer.rasterizationScale = UIScreen.main.scale
        
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
    
    @IBAction func dismissPopUpTuoch(_ sender: Any) {
        animateOut()
    }
    @IBAction func formEditingChange(_ sender: UITextField) {
        let newValue = sender.text ?? ""
        switch sender {
        case emailField:
            viewModel.email = newValue
        case passwordField:
            viewModel.password = newValue
        case passwordConfirmationField:
            viewModel.passwordConfirmation = newValue
        default: break
        }
    }
    
    @IBAction func tapOnSignUpButton(_ sender: Any) {
        animateIn()
        //        UIApplication.showNetworkActivity()
        //        viewModel.signup(success: { [unowned self] in
        //            UIApplication.hideNetworkActivity()
        //            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        //            UIApplication.shared.keyWindow?.rootViewController = homeVC
        //            }, failure: { [unowned self] failureReason in
        //                UIApplication.hideNetworkActivity()
        //                self.showMessage(title: "Error", message: failureReason)
        //        })
    }
}
