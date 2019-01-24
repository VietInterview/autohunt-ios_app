///**
/**
Created by: Hiep Nguyen Nghia on 1/23/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class ResetPasswordController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imgNoteEmail: UIImageView!
    @IBOutlet weak var lineEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var imgMail: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet var viewPopup: UIView!
    
    let viewModel = SignUpViewModelWithEmail()
    var effect:UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        self.textFieldEmail.delegate = self
        self.textFieldEmail.addTarget(self, action: #selector(textFieldEmailDidChange(_:)), for: .editingChanged)
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewEmail.shadowView(opacity: 15/100, radius: 5, color: "#191830")
    }
    @objc func textFieldEmailDidChange(_ textField: UITextField) {
        imgNoteEmail.isHidden = false
        imgNoteEmail.visible()
        imgNoteEmail.image = StringUtils.shared.isValidEmail(testStr: self.textFieldEmail.text!) ? UIImage(named: "tickok") : UIImage(named: "note")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.imgMail.image = textField == textFieldEmail.self ? UIImage(named: "mail_focus") : UIImage(named: "mail")
        lineEmail.layer.backgroundColor = textField == textFieldEmail.self ? StringUtils.shared.hexStringToUIColor(hex: "#FFD215").cgColor : StringUtils.shared.hexStringToUIColor(hex: "#D2D2E1").cgColor
    }
    func animateIn() {
        self.view.addSubview(viewPopup)
        viewPopup.center = self.view.center
        viewPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewPopup.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.visualEffectView.isHidden = false
            self.viewPopup.alpha = 1
            self.viewPopup.transform = CGAffineTransform.identity
        }
    }
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewPopup.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.viewPopup.removeFromSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func closePopupTouch() {
        animateOut()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)    }
    
    @IBAction func dismissControllerTouch(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPassTouch() {
        if self.textFieldEmail.text == "" {
            self.imgNoteEmail.isHidden = false
            textFieldEmail.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("input_email", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: StringUtils.shared.hexStringToUIColor(hex: "#DC4444")])
        } else {
            viewModel.resetPass(email: self.textFieldEmail.text!, success: {
                self.animateIn()
            }, failure: { error in
                if error == "" {
                    self.animateIn()
                } else {
                    self.showMessage(title: "Thông báo", message: error)
                }
            }
            )
        }
    }
}
