///**
/**
Created by: Hiep Nguyen Nghia on 12/20/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
class InfoProcessResumeController: BaseViewController {
    
    @IBOutlet weak var imgSeeInfoResume: UIImageView!
    @IBOutlet weak var imgResume: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblAcademicLevel: UILabel!
    @IBOutlet weak var lblPositionWish: UILabel!
    @IBOutlet weak var lblWorkPLace: UILabel!
    @IBOutlet weak var lblExpYear: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblFullnameColl: UILabel!
    @IBOutlet weak var lblPhonenumberColl: UILabel!
    @IBOutlet weak var lblEmailColl: UILabel!
    @IBOutlet weak var viewInfoCandidate: UIView!
    @IBOutlet weak var viewColl: UIView!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var lblReject: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnInterview: UIButton!
    
    var detailProcessResume = DetailProcessResume()
    static let onReceiveRejectInfo = Notification.Name("onReceiveRejectInfo")
    var rejectDelegate:RejectDelegate?
    var nextDelegate:NextDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: InfoProcessResumeController.onReceiveRejectInfo, object: nil)
        self.lblFullname.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.fullName)
        self.imgResume.showImage(imgUrl: self.detailProcessResume.cvProcessInfo!.pictureURL, imageNullName: "ava_null")
        self.lblDateOfBirth.text = DateUtils.shared.convertFormatDateFull(dateString: "\(self.detailProcessResume.cvProcessInfo!.birthday!)")
        self.lblAcademicLevel.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.educationLevelName)
        self.lblPositionWish.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.positionName)
        self.lblWorkPLace.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.workAddress)
        self.lblExpYear.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.yearsExperienceName)
        self.lblSalary.text = "\(StringUtils.shared.checkEmpty(value: StringUtils.shared.currencyFormat(value: self.detailProcessResume.cvProcessInfo!.salary!))) \(StringUtils.shared.genStringCurrency(value: self.detailProcessResume.cvProcessInfo!.currencyID!))"
        self.lblFullnameColl.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.collName)
        self.lblEmailColl.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.collEmail)
        self.lblPhonenumberColl.text = StringUtils.shared.checkEmpty(value: self.detailProcessResume.cvProcessInfo!.collPhone)
        
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imgSeeInfoResume.isUserInteractionEnabled = true
        self.imgSeeInfoResume.addGestureRecognizer(gestureSwift2AndHigher2)
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailResumeCustomerController") as! DetailResumeCustomerController
        vc.title = "Xem hồ sơ"
        vc.cvId = self.detailProcessResume.cvID!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewInfoCandidate.shadowView(opacity: 8/100, radius: 10)
        self.viewColl.shadowView(opacity: 8/100, radius: 10)
        self.viewReject.shadowView(opacity: 8/100, radius: 10)
        
        var status:Int
        var rejectStep:Int = -1
        status = self.detailProcessResume.cvProcessInfo!.status!
        if let rejectstep = self.detailProcessResume.cvProcessInfo!.rejectStep{
            rejectStep = rejectstep
        }
        if status == 3 || (status == 4 && rejectStep == 1) {
            self.showHideView(view: self.viewButton, isHidden: false)
        }else {
            self.showHideView(view: self.viewButton, isHidden: true)
            self.showHideView(view: self.btnReject, isHidden: true)
            self.showHideView(view: self.btnInterview, isHidden: true)
        }
        
        if self.detailProcessResume.cvProcessInfo!.status! == 4{
            if self.detailProcessResume.cvProcessInfo!.rejectStep! == 1 {
                self.showHideView(view: self.viewReject, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: true)
            }else{
                self.showHideView(view: self.viewReject, isHidden: true)
            }
        }else {
            self.showHideView(view: self.viewReject, isHidden: true)
        }
        
        if let rejectName = self.detailProcessResume.cvProcessInfo!.reasonRejectName {
            self.lblReject.text = "Ứng viên này đã bị từ chối\nLý do: \(rejectName)"
            if let rejectNote = self.detailProcessResume.cvProcessInfo!.rejectNote {
                self.lblReject.text = rejectNote == "" ? "Ứng viên này đã bị từ chối\nLý do: \(rejectName)" : "Ứng viên này đã bị từ chối\nLý do: \(rejectName)\nGhi chú: \(rejectNote)"
            }
        }
        self.imgResume.layer.borderWidth = 0
        self.imgResume.layer.masksToBounds = false
        self.imgResume.layer.borderColor = UIColor.black.cgColor
        self.imgResume.layer.cornerRadius = imgResume.frame.height/2
        self.imgResume.clipsToBounds = true
    }
    @IBAction func rejectTouch() {
        self.rejectDelegate?.onReject(step: 1, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
    }
    
    @IBAction func inviteInterviewTouch() {
        self.nextDelegate?.onNext(step: 1, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
    }
    @objc func onNotification(notification:Notification)
    {
        self.showHideView(view: self.viewReject, isHidden: false)
         let reasonNote = notification.userInfo!["reasonNote"] as? NSString
         let reasonName = notification.userInfo!["reasonName"] as? NSString
        self.lblReject.text = reasonNote! == "" ? "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)" : "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)\nGhi chú: \(reasonNote!)"
    }
}
