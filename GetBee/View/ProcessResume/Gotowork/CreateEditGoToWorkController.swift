///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class CreateEditGoToWorkController: BaseViewController {
    
    @IBOutlet weak var textFieldWarranty: UITextField!
    @IBOutlet weak var textFieldStartWorkDate: UITextField!
    @IBOutlet weak var imageChooseDateTime: UIImageView!
    @IBOutlet weak var textFieldDateTime: UITextField!
    @IBOutlet weak var viewChooseDateTime: UIView!
    
    var sendGoToWorkDelegate:SendGoToWorkDelegate?
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    var detailProcessResume:DetailProcessResume?
    var gotoworkDTO:JobCvGotoWorkDto?
    var viewModel = HomeViewModel()
    
    convenience init() {
        self.init(nibName: "CreateEditGoToWorkController", bundle: nil)
    }
    
    func setArgument(gotoworkDTO:JobCvGotoWorkDto? = nil, detailProcessResume:DetailProcessResume, delegate:SendGoToWorkDelegate) -> CreateEditGoToWorkController{
        let vc = self.assignValueToController(nameController: "CreateEditGoToWorkController") as! CreateEditGoToWorkController
        vc.gotoworkDTO = gotoworkDTO
        vc.detailProcessResume = detailProcessResume
        vc.sendGoToWorkDelegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin đi làm"
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imageChooseDateTime.isUserInteractionEnabled = true
        self.imageChooseDateTime.addGestureRecognizer(gestureSwift2AndHigher2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gotowork = self.gotoworkDTO {
            self.textFieldDateTime.text = StringUtils.shared.checkEmpty(value: gotowork.startWorkDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let startWorkDate = gotowork.startWorkDate {
                if let date = dateFormatter.date(from: startWorkDate.substring(with: 0..<10)) {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 60, to: date)
                    let components = Calendar.current.dateComponents([.day], from: Date(), to: tomorrow!)
                    self.textFieldWarranty.text = "\(components.day!) ngày còn lại"
                }
            }
        }
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
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
    
    @IBAction func updateGoToWorkTouch() {
        self.viewModel.gotoWorkUpdate(cvId: self.detailProcessResume!.cvID!, id: self.gotoworkDTO == nil ? -1 : self.gotoworkDTO!.id == nil ? -1 : self.gotoworkDTO!.id!, countUpdate: self.gotoworkDTO == nil ? 0 : self.gotoworkDTO!.countUpdate == nil ? 0 : self.gotoworkDTO!.countUpdate!, jobId: self.detailProcessResume!.jobID!, startWorkDate: self.textFieldDateTime.text!, success: {gotoworkDTO in
            if let delegate = self.sendGoToWorkDelegate {
                delegate.onSendGotowork(gotoworkDTO: JobCvGotoWorkDto.init(countUpdate: gotoworkDTO.countUpdate!, cvID: gotoworkDTO.cvID!, id: gotoworkDTO.id!, jobID: gotoworkDTO.jobID!, note: StringUtils.shared.checkEmpty(value: gotoworkDTO.note) , numDayWarranty: gotoworkDTO.numDayWarranty!, startWorkDate: gotoworkDTO.startWorkDate!, updateBy: StringUtils.shared.checkEmptyInt(value: gotoworkDTO.updateBy), updateDate: StringUtils.shared.checkEmpty(value: gotoworkDTO.updateDate), warrantyExpireDate: StringUtils.shared.checkEmpty(value: gotoworkDTO.warrantyExpireDate)))
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
    }
    
}
