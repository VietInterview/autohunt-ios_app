///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class GoToWorkProcessController: BaseViewController, SendGoToWorkDelegate {
    
    @IBOutlet weak var viewGotowork: UIView!
    @IBOutlet weak var viewStartWorkDate: UIView!
    @IBOutlet weak var lblStartWorkDate: UILabel!
    @IBOutlet weak var lblWarranty: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnContract: UIButton!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var lblReject: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    
    var detailProcessResume:DetailProcessResume?
    var rejectDelegate:RejectDelegate?
    var nextDelegate:NextDelegate?
    static let onReceiveRejectGoToWork = Notification.Name("onReceiveRejectGoToWork")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: GoToWorkProcessController.onReceiveRejectGoToWork, object: nil)
        if let gotoworkDTO = self.detailProcessResume!.jobCvGotoWorkDto {
            if gotoworkDTO.id != nil {
                self.lblStartWorkDate.text = StringUtils.shared.checkEmpty(value: gotoworkDTO.startWorkDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let startWorkDate = gotoworkDTO.startWorkDate {
                    if let date = dateFormatter.date(from: startWorkDate.substring(with: 0..<10)) {
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 60, to: date)
                        let components = Calendar.current.dateComponents([.day], from: Date(), to: tomorrow!)
                        self.lblWarranty.text = "\(components.day!) ngày còn lại"
                    }
                }
            }else {
                self.pushViewController(controller: CreateEditGoToWorkController.init().setArgument(gotoworkDTO:self.detailProcessResume!.jobCvGotoWorkDto,detailProcessResume: self.detailProcessResume!, delegate: self))
            }
        } else {
            self.pushViewController(controller: CreateEditGoToWorkController.init().setArgument(gotoworkDTO:self.detailProcessResume!.jobCvGotoWorkDto,detailProcessResume: self.detailProcessResume!, delegate: self))
            self.lblStartWorkDate.text = ""
            self.lblWarranty.text = "0 ngày còn lại"
        }
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.viewStartWorkDate.isUserInteractionEnabled = true
        self.viewStartWorkDate.addGestureRecognizer(gestureSwift2AndHigher2)
    }
    @objc func onNotification(notification:Notification) {
        self.showHideView(view: self.viewReject, isHidden: false)
        self.showHideView(view: self.viewButton, isHidden: true)
        self.showHideView(view: self.btnContract, isHidden: true)
        self.showHideView(view: self.btnReject, isHidden: true)
        let reasonNote = notification.userInfo!["reasonNote"] as? NSString
        let reasonName = notification.userInfo!["reasonName"] as? NSString
        self.lblReject.text = reasonNote! == "" ? "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)" : "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)\nGhi chú: \(reasonNote!)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var status:Int
        var rejectStep:Int = -1
        status = self.detailProcessResume!.cvProcessInfo!.status!
        if let rejectstep = self.detailProcessResume!.cvProcessInfo!.rejectStep{
            rejectStep = rejectstep
        }
        if status == 8 || (status == 4 && rejectStep == 4) {
            if let gotoWorkDTO = self.detailProcessResume!.jobCvGotoWorkDto {
                self.showHideView(view: self.btnReject, isHidden: false)
                self.showHideView(view: self.btnContract, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: false)
                if let countUpdate = gotoWorkDTO.countUpdate {
                    if countUpdate < 3 {
                        self.showHideView(view: self.imgArrow, isHidden: false)
                    } else {
                        self.showHideView(view: self.imgArrow, isHidden: true)
                    }
                }
            } else {
                self.pushViewController(controller: CreateEditGoToWorkController.init().setArgument(detailProcessResume: self.detailProcessResume!, delegate: self))
            }
            
            if status == 4 {
                if rejectStep == 4 {
                    self.showHideView(view: self.viewReject, isHidden: false)
                    self.showHideView(view: self.viewButton, isHidden: true)
                    self.showHideView(view: self.btnContract, isHidden: true)
                    self.showHideView(view: self.btnReject, isHidden: true)
                    self.viewStartWorkDate.isUserInteractionEnabled = false
                }else {
                    self.showHideView(view: self.viewReject, isHidden: true)
                    self.showHideView(view: self.viewButton, isHidden: false)
                }
            } else {
                self.showHideView(view: self.viewReject, isHidden: true)
                
            }
        } else {
            self.showHideView(view: self.btnReject, isHidden: true)
            self.showHideView(view: self.btnContract, isHidden: true)
            self.showHideView(view: self.viewButton, isHidden: true)
            self.viewStartWorkDate.isUserInteractionEnabled = false
        }
        if status == 4 {
            if rejectStep == 4 {
                self.showHideView(view: self.viewReject, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: true)
                self.showHideView(view: self.btnContract, isHidden: true)
                self.showHideView(view: self.btnReject, isHidden: true)
                self.viewStartWorkDate.isUserInteractionEnabled = false
            }else {
                self.showHideView(view: self.viewReject, isHidden: true)
                self.showHideView(view: self.viewButton, isHidden: false)
            }
        } else {
            self.showHideView(view: self.viewReject, isHidden: true)
            
        }
        if let rejectName = self.detailProcessResume!.cvProcessInfo!.reasonRejectName {
            self.lblReject.text = "Ứng viên này đã bị từ chối\nLý do: \(rejectName)"
            if let rejectNote = self.detailProcessResume!.cvProcessInfo!.rejectNote {
                self.lblReject.text = rejectNote == "" ? "Ứng viên này đã bị từ chối\nLý do: \(rejectName)" : "Ứng viên này đã bị từ chối\nLý do: \(rejectName)\nGhi chú: \(rejectNote)"
            }
            
        }
        self.viewGotowork.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        if let countUpdate = self.detailProcessResume!.jobCvGotoWorkDto!.countUpdate {
            if countUpdate < 3 {
                self.pushViewController(controller: CreateEditGoToWorkController.init().setArgument(gotoworkDTO:self.detailProcessResume!.jobCvGotoWorkDto,detailProcessResume: self.detailProcessResume!, delegate: self))
            }
        }
    }
    func onSendGotowork(gotoworkDTO: JobCvGotoWorkDto) {
        self.detailProcessResume!.jobCvGotoWorkDto = gotoworkDTO
        self.lblStartWorkDate.text = StringUtils.shared.checkEmpty(value: gotoworkDTO.startWorkDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: gotoworkDTO.startWorkDate!.substring(with: 0..<10)) {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 60, to: date)
            let components = Calendar.current.dateComponents([.day], from: Date(), to: tomorrow!)
            self.lblWarranty.text = "\(components.day!) ngày còn lại"
        }
    }
    @IBAction func contractTouch() {
        self.nextDelegate?.onNext(step: 4, cvId: self.detailProcessResume!.cvID!, jobId: self.detailProcessResume!.jobID!)
    }
    @IBAction func rejectTouch() {
        self.rejectDelegate?.onReject(step: 4, cvId: self.detailProcessResume!.cvID!, jobId: self.detailProcessResume!.jobID!)
    }
    
    
    
}
