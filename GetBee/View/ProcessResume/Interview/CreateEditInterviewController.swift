///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class CreateEditInterviewController: BaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var imgChooseDateTime: UIImageView!
    @IBOutlet weak var viewChooseDateTime: UIView!
    @IBOutlet weak var textFieldDateTime: UITextField!
    @IBOutlet weak var textFieldRound: UITextField!
    @IBOutlet weak var textFieldAdd: UITextField!
    @IBOutlet weak var textFieldNote: UITextField!
    @IBOutlet weak var btnAchive: UIButton!
    @IBOutlet weak var btnNotAchive: UIButton!
    @IBOutlet weak var btnCandidateNotCome: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet weak var textViewEmail: UITextView!
    @IBOutlet weak var lblResultInterview: UILabel!
    @IBOutlet weak var btnInviteInterview: UIButton!
    
    var viewModel = HomeViewModel()
    var effect:UIVisualEffect!
    var lstInterviewHi:LstInterviewHi?
    var detailProcessResume:DetailProcessResume?
    var sendInterviewDelegate:SendInterviewDelegate?
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    
    convenience init() {
        self.init(nibName: "CreateEditInterviewController", bundle: nil)
    }
    
    func setArgument(lstInterviewHi:LstInterviewHi? = nil, detailProcessResume:DetailProcessResume, delegate:SendInterviewDelegate) -> CreateEditInterviewController{
        let vc = self.assignValueToController(nameController: "CreateEditInterviewController") as! CreateEditInterviewController
        vc.lstInterviewHi = lstInterviewHi
        vc.detailProcessResume = detailProcessResume
        vc.sendInterviewDelegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imgChooseDateTime.isUserInteractionEnabled = true
        self.imgChooseDateTime.addGestureRecognizer(gestureSwift2AndHigher2)
        if let lstInterview = self.lstInterviewHi {
            self.textFieldRound.text = lstInterview.round!
            self.textFieldDateTime.text = lstInterview.interviewDate!
            self.textFieldAdd.text = lstInterview.interviewAddress!
            self.textFieldNote.text = StringUtils.checkEmpty(value: lstInterview.note) 
        } else {
            self.textFieldRound.text = "Vòng \(self.detailProcessResume!.lstInterviewHis!.count + 1)"
        }
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Thông tin phỏng vấn"
        self.viewResult.addBorder(color: StringUtils.hexStringToUIColor(hex: "#D6E1EA"),weight: 1)
        if let lstInterview = self.lstInterviewHi {
            if lstInterview.status! == 0 {
                self.showHideView(view: self.btnInviteInterview, isHidden: false)
                self.btnAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                self.btnNotAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                self.btnCandidateNotCome.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
            } else if lstInterview.status! == 1 {
                self.showHideView(view: self.btnInviteInterview, isHidden: true)
                let origImage = UIImage(named: "like")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.btnAchive.setImage(tintedImage, for: .normal)
                self.btnAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#3C84F7")
                self.btnAchive.setTitleColor( StringUtils.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
                self.btnNotAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                self.btnCandidateNotCome.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
            } else if lstInterview.status! == 2 {
                self.showHideView(view: self.btnInviteInterview, isHidden: true)
                self.btnAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                let origImage = UIImage(named: "dislike")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.btnNotAchive.setImage(tintedImage, for: .normal)
                self.btnNotAchive.setTitleColor( StringUtils.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
                self.btnNotAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#3C84F7")
                self.btnCandidateNotCome.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
            } else if lstInterview.status! == 3 {
                self.showHideView(view: self.btnInviteInterview, isHidden: true)
                self.btnAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                self.btnNotAchive.tintColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
                let origImage = UIImage(named: "reject_gray")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.btnCandidateNotCome.setImage(tintedImage, for: .normal)
                self.btnCandidateNotCome.setTitleColor( StringUtils.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
                self.btnCandidateNotCome.tintColor = StringUtils.hexStringToUIColor(hex: "#3C84F7")
            }
            self.btnCandidateNotCome.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            self.showHideView(view: self.viewResult, isHidden: true)
            self.showHideView(view: self.lblResultInterview, isHidden: true)
            self.showHideView(view: self.btnCandidateNotCome, isHidden: true)
            self.showHideView(view: self.btnAchive, isHidden: true)
            self.showHideView(view: self.btnNotAchive, isHidden: true)
        }
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        view.endEditing(true)
        viewChooseDateTime.isHidden = false
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 200))
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.locale! = Locale(identifier: "vi-VI")
        self.datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
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
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en-EN")
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        somedateString = dateFormatter.string(from: self.datePicker.date)
        self.textFieldDateTime.text = somedateString
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    
    @IBAction func updateStatusAchieve() {
        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn cập nhật kết quả cho vòng phỏng vấn này?", handler: { (action: UIAlertAction!) in
            self.viewModel.updateInterviewStatus(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: 1, success: {
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 1)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }, failure: {error in
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 1)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            })
        },handlerCancel: {(action: UIAlertAction!) in
            
        })
    }
    @IBAction func updateStatusNotAchieve() {
        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn cập nhật kết quả cho vòng phỏng vấn này?", handler: { (action: UIAlertAction!) in
            self.viewModel.updateInterviewStatus(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: 2, success: {
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 2)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }, failure: {error in
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 2)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            })
        },handlerCancel: {(action: UIAlertAction!) in
            
        })
    }
    @IBAction func updateStatusCandidateNotCome() {
        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn cập nhật kết quả cho vòng phỏng vấn này?", handler: { (action: UIAlertAction!) in
            self.viewModel.updateInterviewStatus(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: 3, success: {
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 3)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }, failure: {error in
                if let delegate = self.sendInterviewDelegate {
                    let lstInterviewHi = LstInterviewHi.init(cvID: self.lstInterviewHi!.cvID!, emailTemplate: "", id: self.lstInterviewHi!.id!, interviewAddress: self.lstInterviewHi!.interviewAddress!, interviewDate: self.lstInterviewHi!.interviewDate!, jobID: self.lstInterviewHi!.jobID!, note: self.lstInterviewHi!.note!, round: self.lstInterviewHi!.round!, status: 3)
                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ProcessResumeController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            })
        },handlerCancel: {(action: UIAlertAction!) in
            
        })
    }
    
    @IBAction func sendEmailInterview() {
        let myColor = UIColor.red
        if self.textFieldDateTime.text == "" {
            self.showMessage(title: "Thông báo", message: "Xin hãy điền đủ thông tin")
            self.textFieldDateTime.layer.borderColor = myColor.cgColor
            self.textFieldDateTime.layer.borderWidth = 1.0
        } else if self.textFieldAdd.text == "" {
            self.showMessage(title: "Thông báo", message: "Xin hãy điền đủ thông tin")
            self.textFieldAdd.layer.borderColor = myColor.cgColor
            self.textFieldAdd.layer.borderWidth = 1.0
        } else {
            if let lstInterviewHis = self.detailProcessResume!.lstInterviewHis {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if lstInterviewHis.count > 0 {
                    if self.lstInterviewHi != nil {
                        if lstInterviewHis.count > 1{
                            self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn mời phỏng vấn ứng viên này?", handler: { (action: UIAlertAction!) in
                                self.viewModel.sendInviteInterview(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi == nil ? -1 : self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: self.lstInterviewHi!.status!, success: {sendInterview in
                                    if let delegate = self.sendInterviewDelegate {
                                        let lstInterviewHi = LstInterviewHi.init(cvID: sendInterview.cvID!, emailTemplate: "", id: sendInterview.id!, interviewAddress: sendInterview.interviewAddress!, interviewDate: sendInterview.interviewDate!, jobID: sendInterview.jobID!, note: sendInterview.note!, round: sendInterview.round!, status: sendInterview.status!)
                                        delegate.onSendInterview(lstInterview: lstInterviewHi)
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller.isKind(of: ProcessResumeController.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                }, failure: {error in
                                    self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
                                })
                            },handlerCancel: {(action: UIAlertAction!) in
                                
                            })
                        }else {
                            self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn mời phỏng vấn ứng viên này?", handler: { (action: UIAlertAction!) in
                                self.viewModel.sendInviteInterview(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi == nil ? -1 : self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: self.lstInterviewHi!.status!, success: {sendInterview in
                                    if let delegate = self.sendInterviewDelegate {
                                        let lstInterviewHi = LstInterviewHi.init(cvID: sendInterview.cvID!, emailTemplate: "", id: sendInterview.id!, interviewAddress: sendInterview.interviewAddress!, interviewDate: sendInterview.interviewDate!, jobID: sendInterview.jobID!, note: sendInterview.note!, round: sendInterview.round!, status: sendInterview.status!)
                                        delegate.onSendInterview(lstInterview: lstInterviewHi)
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller.isKind(of: ProcessResumeController.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                }, failure: {error in
                                    self.showMessageErrorApi()
                                })
                            },handlerCancel: {(action: UIAlertAction!) in
                                
                            })
                        }
                        
                    } else {
                        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn mời phỏng vấn ứng viên này?", handler: { (action: UIAlertAction!) in
                            self.viewModel.sendInviteInterview(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi == nil ? -1 : self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: 0, success: {sendInterview in
                                if let delegate = self.sendInterviewDelegate {
                                    let lstInterviewHi = LstInterviewHi.init(cvID: sendInterview.cvID!, emailTemplate: "", id: sendInterview.id!, interviewAddress: sendInterview.interviewAddress!, interviewDate: sendInterview.interviewDate!, jobID: sendInterview.jobID!, note: sendInterview.note!, round: sendInterview.round!, status: sendInterview.status!)
                                    delegate.onSendInterview(lstInterview: lstInterviewHi)
                                    for controller in self.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: ProcessResumeController.self) {
                                            self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
                                }
                            }, failure: {error in
                                self.showMessageErrorApi()
                            })
                        },handlerCancel: {(action: UIAlertAction!) in
                            
                        })
                    }
                } else {
                    self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn mời phỏng vấn ứng viên này?", handler: { (action: UIAlertAction!) in
                        self.viewModel.sendInviteInterview(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi == nil ? -1 : self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound.text!, status: 0, success: {sendInterview in
                            if let delegate = self.sendInterviewDelegate {
                                let lstInterviewHi = LstInterviewHi.init(cvID: sendInterview.cvID!, emailTemplate: "", id: sendInterview.id!, interviewAddress: sendInterview.interviewAddress!, interviewDate: sendInterview.interviewDate!, jobID: sendInterview.jobID!, note: sendInterview.note!, round: sendInterview.round!, status: sendInterview.status!)
                                delegate.onSendInterview(lstInterview: lstInterviewHi)
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: ProcessResumeController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }
                        }, failure: {error in
                            self.showMessageErrorApi()
                        })
                    },handlerCancel: {(action: UIAlertAction!) in
                        
                    })
                }
            }
            
        }
    }
    
    @IBAction func closeViewEmailTouch() {
        self.animateOut()
    }
    func animateIn() {
        self.view.addSubview(self.viewEmail)
        viewEmail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: viewEmail, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10), viewEmail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            viewEmail.heightAnchor.constraint(equalToConstant: 436),
            viewEmail.widthAnchor.constraint(equalToConstant: 300)
            ])
        viewEmail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewEmail.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.visualEffectView.isHidden = false
            self.viewEmail.alpha = 1
            self.viewEmail.transform = CGAffineTransform.identity
        }
    }
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewEmail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewEmail.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.viewEmail.removeFromSuperview()
        }
    }
    @IBAction func seeEmailTemplateTouch() {
        if self.textFieldDateTime.text == "" {
            self.showMessage(title: "Thông báo", message: "Xin hãy điền đủ thông tin")
        } else if self.textFieldAdd.text == "" {
            self.showMessage(title: "Thông báo", message: "Xin hãy điền đủ thông tin")
        } else {
            self.viewModel.viewEmailInterview(cvId: self.detailProcessResume!.cvID!, id: self.lstInterviewHi == nil ? -1 : self.lstInterviewHi!.id!, interviewAddress: self.textFieldAdd.text!, interviewDate: self.textFieldDateTime.text!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, round: self.textFieldRound!.text!, status: self.lstInterviewHi == nil ? 0 : self.lstInterviewHi!.status!, success: {viewEmail in
//                self.textViewEmail.text = viewEmail.emailTemplate!.htmlToString
                self.webView.loadHTMLString(viewEmail.emailTemplate!, baseURL: nil)
                self.animateIn()
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
            })
        }
    }
}
