///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class CreateEditOfferController: BaseViewController {
    
    @IBOutlet weak var btnCurrency: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var textFieldRound: UITextField!
    @IBOutlet weak var textFieldSalary: UITextField!
    @IBOutlet weak var textFieldWorkTime: UITextField!
    @IBOutlet weak var textFieldAdd: UITextField!
    @IBOutlet weak var textFieldPositionWork: UITextField!
    @IBOutlet weak var textFieldNote: UITextField!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnNotAgree: UIButton!
    @IBOutlet weak var btnInviteOffer: UIButton!
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var viewChooseDateTime: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet weak var textViewEmail: UITextView!
    
    var viewModel = HomeViewModel()
    var effect:UIVisualEffect!
    var lstOffer:LstOfferHi?
    var detailProcessResume:DetailProcessResume?
    var sendOfferDelegate:SendOfferDelegate?
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    var currencyID:Int = 1
    
    convenience init() {
        self.init(nibName: "CreateEditOfferController", bundle: nil)
    }
    
    func setArgument(lstOffer:LstOfferHi? = nil, detailProcessResume:DetailProcessResume, delegate:SendOfferDelegate) -> CreateEditOfferController{
        let vc = self.assignValueToController(nameController: "CreateEditOfferController") as! CreateEditOfferController
        vc.lstOffer = lstOffer
        vc.detailProcessResume = detailProcessResume
        vc.sendOfferDelegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin Offer"
        if let lstOffer = self.lstOffer {
            self.textFieldRound.text = StringUtils.shared.checkEmpty(value: lstOffer.round)
            self.textFieldSalary.text = StringUtils.shared.currencyFormat(value: StringUtils.shared.checkEmptyInt(value: lstOffer.salary))
            self.textFieldWorkTime.text = StringUtils.shared.checkEmpty(value: lstOffer.workTime)
            self.textFieldAdd.text = StringUtils.shared.checkEmpty(value: lstOffer.workAddress)
            self.textFieldPositionWork.text = StringUtils.shared.checkEmpty(value: lstOffer.position)
            self.textFieldNote.text = StringUtils.shared.checkEmpty(value: lstOffer.note)
        } else {
            self.textFieldRound.text = "Offer \(self.detailProcessResume!.lstOfferHis!.count + 1)"
        }
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imgCalendar.isUserInteractionEnabled = true
        self.imgCalendar.addGestureRecognizer(gestureSwift2AndHigher2)
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        textFieldSalary.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

    }
    var salary:Int = 0
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let number = textField.text {
            let number2 = number.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            debugLog(object: number2.replacingOccurrences(of: ",", with: "", options: .literal, range: nil))
            if let mNumber = Int(number2.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)) {
                self.salary = mNumber
                let amountString:String = StringUtils.shared.currencyFormat(value: self.salary)
                textField.text = amountString
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewResult.addBorder(color: StringUtils.shared.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        if let lstOffer = self.lstOffer {
            self.currencyID = lstOffer.curency!
            self.btnCurrency.setTitle(self.switchCurrency(value: lstOffer.curency!), for: .normal)
            if lstOffer.status! == 0 {
                self.showHideView(view: self.btnInviteOffer, isHidden: false)
                self.btnAgree.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#677B8D")
                self.btnNotAgree.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#677B8D")
            } else if lstOffer.status! == 1 {
                self.showHideView(view: self.btnInviteOffer, isHidden: true)
                let origImage = UIImage(named: "like")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.btnAgree.setImage(tintedImage, for: .normal)
                self.btnAgree.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
                self.btnAgree.setTitleColor( StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
            } else if lstOffer.status! == 2 {
                self.showHideView(view: self.btnInviteOffer, isHidden: true)
                let origImage = UIImage(named: "reject_gray")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.btnNotAgree.setImage(tintedImage, for: .normal)
                self.btnNotAgree.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
                self.btnNotAgree.setTitleColor( StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), for: .normal)
            }
        } else {
            self.btnCurrency.setTitle(self.switchCurrency(value: self.currencyID), for: .normal)
            self.showHideView(view: self.viewResult, isHidden: true)
            self.showHideView(view: self.btnAgree, isHidden: true)
            self.showHideView(view: self.btnNotAgree, isHidden: true)
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
        self.textFieldWorkTime.text = somedateString
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    func switchCurrency(value:Int) -> String {
        var currencyString:String = ""
        switch value {
        case 1:
            currencyString = "VND"
        case 2:
            currencyString = "USD"
        case 3:
            currencyString = "JPY"
        default:
            currencyString = "VND"
        }
        return currencyString
    }
    @IBAction func chooseCurrencyTouch() {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Chọn đơn vị tiền tệ", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(UIAlertAction(title: "VND", style: .default)
        { _ in
            self.btnCurrency.setTitle("VND", for: .normal)
            self.currencyID = 1
        })
        actionSheetControllerIOS8.addAction(UIAlertAction(title: "USD", style: .default)
        { _ in
            self.btnCurrency.setTitle("USD", for: .normal)
            self.currencyID = 2
        })
        actionSheetControllerIOS8.addAction(UIAlertAction(title: "JPY", style: .default)
        { _ in
            self.btnCurrency.setTitle("JPY", for: .normal)
            self.currencyID = 3
        })
        actionSheetControllerIOS8.addAction(cancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
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
    @IBAction func closeViewEmailTOuch(_ sender: Any) {
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(viewEmail)
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
    @IBAction func seeEmailOfferTouch() {
        if self.textFieldSalary.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
        } else if self.textFieldWorkTime.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
        } else if self.textFieldAdd.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
        } else if self.textFieldPositionWork.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
        } else {
            self.viewModel.viewEmailOffer(curency: currencyID, cvId: self.detailProcessResume!.cvID!, id: lstOffer == nil ? -1 : lstOffer!.id!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, position: self.textFieldPositionWork.text!, round: self.textFieldRound.text!, salary: self.lstOffer == nil ? Int(self.textFieldSalary.text!)! : self.lstOffer!.salary!, status: lstOffer == nil ? 0 : lstOffer!.status!, workAddress: self.textFieldAdd.text!, workTime: self.textFieldWorkTime.text!, success: {emailOffer in
                self.textViewEmail.text = StringUtils.shared.stringFromHtml(string: emailOffer.emailTemplate!)
                self.animateIn()
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
            })
        }
    }
    @IBAction func sendEmailOfferTouch() {
        let myColor = UIColor.red
        if self.textFieldSalary.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
            self.textFieldSalary.layer.borderColor = myColor.cgColor
            
            self.textFieldSalary.layer.borderWidth = 1.0
        } else if self.textFieldWorkTime.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
            self.textFieldWorkTime.layer.borderColor = myColor.cgColor
            
            self.textFieldWorkTime.layer.borderWidth = 1.0
        } else if self.textFieldAdd.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
            self.textFieldAdd.layer.borderColor = myColor.cgColor
            
            self.textFieldAdd.layer.borderWidth = 1.0
        } else if self.textFieldPositionWork.text!.isEmpty {
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Xin hãy nhập dữ liệu")
            self.textFieldPositionWork.layer.borderColor = myColor.cgColor
            self.textFieldPositionWork.layer.borderWidth = 1.0
        } else {
            if let lstOffer = self.detailProcessResume!.lstOfferHis {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if lstOffer.count > 0 {
                    if let lastDate = dateFormatter.date(from: lstOffer[lstOffer.count-1].workTime!.substring(with: 0..<10)) {
                        let dateNow = dateFormatter.date(from: self.textFieldWorkTime.text!.substring(with: 0..<10))
                        let components = Calendar.current.dateComponents([.day], from: dateNow!, to: lastDate)
                        if components.day! < 0 {
                            self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn gửi offer tới ứng viên này không?", handler: { (action: UIAlertAction!) in
                                self.viewModel.sendOffer(curency: self.currencyID, cvId: self.detailProcessResume!.cvID!, id: self.lstOffer == nil ? -1 : self.lstOffer!.id!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, position: self.textFieldPositionWork.text!, round: self.textFieldRound.text!, salary: self.salary, status: 0, workAddress: self.textFieldAdd.text!, workTime: self.textFieldWorkTime.text!, success: {sendOffer in
                                    if let delegate = self.sendOfferDelegate {
                                        let lstOffer = LstOfferHi.init(curency: sendOffer.curency!, cvID: sendOffer.cvID!, emailTemplate: "", id: sendOffer.id!, jobID: sendOffer.jobID!, note: sendOffer.note!, position: sendOffer.position!, round: sendOffer.round!, salary: sendOffer.salary!, status: sendOffer.status!, workAddress: sendOffer.workAddress, workTime: sendOffer.workTime!)
                                        delegate.onSendOffer(lstOffer: lstOffer)
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
                        }else{
                            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn không thể chọn ngày phòng vấn trước hoặc bằng ngày phỏng vấn trước")
                        }
                    }
                } else {
                    self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn gửi offer tới ứng viên này không?", handler: { (action: UIAlertAction!) in
                        self.viewModel.sendOffer(curency: self.currencyID, cvId: self.detailProcessResume!.cvID!, id: self.lstOffer == nil ? -1 : self.lstOffer!.id!, jobId: self.detailProcessResume!.jobID!, note: self.textFieldNote.text!, position: self.textFieldPositionWork.text!, round: self.textFieldRound.text!, salary: self.salary, status: 0, workAddress: self.textFieldAdd.text!, workTime: self.textFieldWorkTime.text!, success: {sendOffer in
                            if let delegate = self.sendOfferDelegate {
                                let lstOffer = LstOfferHi.init(curency: sendOffer.curency!, cvID: sendOffer.cvID!, emailTemplate: "", id: sendOffer.id!, jobID: sendOffer.jobID!, note: sendOffer.note!, position: sendOffer.position!, round: sendOffer.round!, salary: sendOffer.salary!, status: sendOffer.status!, workAddress: sendOffer.workAddress, workTime: sendOffer.workTime!)
                                delegate.onSendOffer(lstOffer: lstOffer)
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
    @IBAction func updateStatusAgreeTouch() {
        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn cập nhật kết quả cho lần offer này?", handler: { (action: UIAlertAction!) in
            self.viewModel.updateOfferStatus(curency: self.lstOffer!.curency!, cvId: self.detailProcessResume!.cvID!, id: self.lstOffer!.id!, jobId: self.detailProcessResume!.jobID!, note: self.lstOffer!.note!, position: self.lstOffer!.position!, round: self.lstOffer!.round!, salary: self.lstOffer!.salary!, status: 1, workAddress: self.lstOffer!.workAddress!, workTime: self.lstOffer!.workTime!, success: {
                
            }, failure: {error in
                if let delegate = self.sendOfferDelegate {
                    let lstOffer = LstOfferHi.init(curency: self.lstOffer!.curency!, cvID: self.lstOffer!.cvID!, emailTemplate: "", id: self.lstOffer!.id!, jobID: self.lstOffer!.jobID!, note: self.lstOffer!.note!, position: self.lstOffer!.position!, round: self.lstOffer!.round!, salary: self.lstOffer!.salary!, status: 1, workAddress: self.lstOffer!.workAddress, workTime: self.lstOffer!.workTime!)
                    delegate.onSendOffer(lstOffer: lstOffer)
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
    @IBAction func updateStatusNotAgreeTouch() {
        self.showMessageFull(title: NSLocalizedString("noti_title", comment: ""), message: "Bạn có chắc chắn muốn cập nhật kết quả cho lần offer này?", handler: { (action: UIAlertAction!) in
            self.viewModel.updateOfferStatus(curency: self.lstOffer!.curency!, cvId: self.detailProcessResume!.cvID!, id: self.lstOffer!.id!, jobId: self.detailProcessResume!.jobID!, note: self.lstOffer!.note!, position: self.lstOffer!.position!, round: self.lstOffer!.round!, salary: self.lstOffer!.salary!, status: 2, workAddress: self.lstOffer!.workAddress!, workTime: self.lstOffer!.workTime!, success: {
                
            }, failure: {error in
                if let delegate = self.sendOfferDelegate {
                    let lstOffer = LstOfferHi.init(curency: self.lstOffer!.curency!, cvID: self.lstOffer!.cvID!, emailTemplate: "", id: self.lstOffer!.id!, jobID: self.lstOffer!.jobID!, note: self.lstOffer!.note!, position: self.lstOffer!.position!, round: self.lstOffer!.round!, salary: self.lstOffer!.salary!, status: 2, workAddress: self.lstOffer!.workAddress, workTime: self.lstOffer!.workTime!)
                    delegate.onSendOffer(lstOffer: lstOffer)
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
    
}
