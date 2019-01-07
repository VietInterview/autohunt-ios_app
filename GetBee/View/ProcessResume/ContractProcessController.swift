///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class ContractProcessController: BaseViewController {
    
    @IBOutlet weak var viewContract: UIView!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblReject: UILabel!
    
    var detailProcessResume:DetailProcessResume?
    var rejectDelegate:RejectDelegate?
    static let onReceiveRejectContract = Notification.Name("onReceiveRejectContract")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: ContractProcessController.onReceiveRejectContract, object: nil)
    }
    @objc func onNotification(notification:Notification)
    {
        self.showHideView(view: self.viewReject, isHidden: false)
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
        if status == 9 || (status == 4 && rejectStep == 5) {
            self.showHideView(view: self.viewContract, isHidden: false)
            self.showHideView(view: self.viewReject, isHidden: true)
            self.showHideView(view: self.viewButton, isHidden: false)
        }else {
            self.showHideView(view: self.viewContract, isHidden: true)
            self.showHideView(view: self.viewReject, isHidden: true)
            self.showHideView(view: self.viewButton, isHidden: true)
        }
        if status == 4 {
            if rejectStep == 5 {
                self.showHideView(view: self.viewContract, isHidden: true)
                self.showHideView(view: self.viewReject, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: true)
            } else {
                self.showHideView(view: self.viewContract, isHidden: false)
                self.showHideView(view: self.viewReject, isHidden: true)
                self.showHideView(view: self.viewButton, isHidden: false)
            }
        }
        if let rejectName = self.detailProcessResume!.cvProcessInfo!.reasonRejectName {
            self.lblReject.text = "Ứng viên này đã bị từ chối\nLý do: \(rejectName)"
            if let rejectNote = self.detailProcessResume!.cvProcessInfo!.rejectNote {
                self.lblReject.text = rejectNote == "" ? "Ứng viên này đã bị từ chối\nLý do: \(rejectName)" : "Ứng viên này đã bị từ chối\nLý do: \(rejectName)\nGhi chú: \(rejectNote)"
            }
        }
        self.viewContract.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewButton.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
    }
    @IBAction func rejectTouch() {
        self.rejectDelegate?.onReject(step: 5, cvId: self.detailProcessResume!.cvProcessInfo!.cvID!, jobId: self.detailProcessResume!.jobID!)
    }
}
