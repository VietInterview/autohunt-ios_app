///**
/**
 Created by: Hiep Nguyen Nghia on 12/21/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class InterviewProcessController: BaseViewController, SendInterviewDelegate{
    
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var heightViewInfo: NSLayoutConstraint!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnOffer: UIButton!
    @IBOutlet weak var lblReject: UILabel!
    @IBOutlet weak var viewAddInterview: UIView!
    
    var count:Int?
    var detailProcessResume = DetailProcessResume()
    static let onReceiveRejectInterview = Notification.Name("onReceiveRejectInterview")
    var rejectDelegate:RejectDelegate?
    var nextDelegate:NextDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: InterviewProcessController.onReceiveRejectInterview, object: nil)
        if let LstInterview = self.detailProcessResume.lstInterviewHis {
            self.count = LstInterview.count
        } else {
            self.count = 0
        }
        if let count = self.count {
            if count == 0 {
                DispatchQueue.main.async {
                    self.pushViewController(controller: CreateEditInterviewController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
                }
            }
        }
    }
    @objc func onNotification(notification:Notification) {
        self.showHideView(view: self.viewReject, isHidden: false)
        self.showHideView(view: self.viewAddInterview, isHidden: true)
        self.showHideView(view: self.viewButton, isHidden: true)
        self.showHideView(view: self.btnReject, isHidden: true)
        self.showHideView(view: self.btnOffer, isHidden: true)
        let reasonNote = notification.userInfo!["reasonNote"] as? NSString
        let reasonName = notification.userInfo!["reasonName"] as? NSString
        self.lblReject.text = reasonNote! == "" ? "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)" : "Ứng viên này đã bị từ chối\nLý do: \(reasonName!)\nGhi chú: \(reasonNote!)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var status:Int
        var rejectStep:Int = -1
        status = self.detailProcessResume.cvProcessInfo!.status!
        if let rejectstep = self.detailProcessResume.cvProcessInfo!.rejectStep{
            rejectStep = rejectstep
        }
        if status == 5 || status == 6 || (status == 4 && rejectStep == 2) {
            if let lstInterview =  self.detailProcessResume.lstInterviewHis {
                if lstInterview.count > 0{
                    self.showHideView(view: self.viewAddInterview, isHidden: false)
                    if lstInterview[lstInterview.count-1].status == 1{
                        self.showHideView(view: self.btnReject, isHidden: true)
                        self.showHideView(view: self.btnOffer, isHidden: false)
                        self.showHideView(view: self.viewButton, isHidden: false)
                    } else if lstInterview[lstInterview.count-1].status == 2 {
                        self.showHideView(view: self.btnReject, isHidden: false)
                        self.showHideView(view: self.btnOffer, isHidden: true)
                        self.showHideView(view: self.viewButton, isHidden: false)
                    } else if lstInterview[lstInterview.count-1].status == 3{
                        self.showHideView(view: self.btnReject, isHidden: false)
                        self.showHideView(view: self.btnOffer, isHidden: false)
                        self.showHideView(view: self.viewButton, isHidden: false)
                    } else {
                        self.showHideView(view: self.btnReject, isHidden: true)
                        self.showHideView(view: self.btnOffer, isHidden: true)
                        self.showHideView(view: self.viewButton, isHidden: true)
                    }
                } else {
                    self.showHideView(view: self.viewAddInterview, isHidden: false)
                    self.showHideView(view: self.btnReject, isHidden: true)
                    self.showHideView(view: self.btnOffer, isHidden: true)
                    self.showHideView(view: self.viewButton, isHidden: true)
                }
            }else{
                self.showHideView(view: self.btnReject, isHidden: true)
                self.showHideView(view: self.btnOffer, isHidden: true)
                self.showHideView(view: self.viewButton, isHidden: true)
                self.showHideView(view: self.viewAddInterview, isHidden: true)
            }
        }else {
            self.showHideView(view: self.viewButton, isHidden: true)
            self.showHideView(view: self.btnReject, isHidden: true)
            self.showHideView(view: self.btnOffer, isHidden: true)
            self.showHideView(view: self.viewAddInterview, isHidden: true)
        }
        
        if self.detailProcessResume.cvProcessInfo!.status! == 4{
            if self.detailProcessResume.cvProcessInfo!.rejectStep! == 2 {
                self.showHideView(view: self.viewReject, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: true)
                self.showHideView(view: self.viewAddInterview, isHidden: true)
                self.showHideView(view: self.btnReject, isHidden: true)
                self.showHideView(view: self.btnOffer, isHidden: true)
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
        self.showList()
        self.viewInfo.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    @IBAction func addInterview(_ sender: Any) {
        if let lstInterview = self.detailProcessResume.lstInterviewHis {
            if lstInterview.count > 0 {
                if lstInterview[lstInterview.count-1].status! == 0 {
                    self.showMessage(title: "Thông báo", message: "Bạn phải cập nhật trạng thái vòng phỏng vấn trước, trước khi tạo vòng phỏng vấn mới", handler: { (action: UIAlertAction!) in
                        
                    })
                } else if lstInterview[lstInterview.count-1].status! == 1 {
                    self.pushViewController(controller: CreateEditInterviewController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
                }else if lstInterview[lstInterview.count-1].status! == 2 {
                    self.showMessage(title: "Thông báo", message: "Vòng phỏng vấn gần nhất ứng viên không đạt vì vậy bạn không thể thêm mới vòng phỏng vấn", handler: { (action: UIAlertAction!) in
                        
                    })
                }else {
                    self.pushViewController(controller: CreateEditInterviewController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
                }
            } else {
                self.pushViewController(controller: CreateEditInterviewController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
            }
        }
    }
    
    @IBAction func offerTouch(_ sender: Any) {
        if let lstInterview = self.detailProcessResume.lstInterviewHis {
            let lastStatus:Int = lstInterview[lstInterview.count - 1].status!
            if lastStatus == 1 {
                self.nextDelegate?.onNext(step: 2, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
            }else if lastStatus == 0 {
                self.showMessage(title: "Thông báo", message: "Bạn phải cập nhật trạng thái vòng phỏng vấn trước, trước khi tạo vòng phỏng vấn mới", handler: { (action: UIAlertAction!) in
                    
                })
            }else{
                self.showMessage(title: "Thông báo", message: "Vòng phỏng vấn gần nhất ứng viên không đạt vì vậy bạn không thể thêm mới vòng phỏng vấn", handler: { (action: UIAlertAction!) in
                    
                })
            }
        }
    }
    func onSendInterview(lstInterview: LstInterviewHi) {
        var isDuplicate:Bool = false
        if self.detailProcessResume.lstInterviewHis!.count > 0 {
            for i in 0...self.detailProcessResume.lstInterviewHis!.count-1 {
                if self.detailProcessResume.lstInterviewHis![i].id! == lstInterview.id! {
                    isDuplicate = true
                    self.detailProcessResume.lstInterviewHis![i] = lstInterview
                    break
                }
            }
            if isDuplicate == false {
                self.detailProcessResume.lstInterviewHis!.append(lstInterview)
                self.showList()
            }
            self.count = self.detailProcessResume.lstInterviewHis!.count
        }else{
            self.detailProcessResume.lstInterviewHis!.append(lstInterview)
            self.count = self.detailProcessResume.lstInterviewHis!.count
            self.showList()
        }
    }
    @IBAction func rejectTouch(_ sender: Any) {
        self.rejectDelegate?.onReject(step: 2, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
    }
    func showList(){
        self.tableView.maxHeight = CGFloat(self.count! * 70)
        self.viewButton.setNeedsLayout()
        self.viewButton.layoutIfNeeded()
        self.viewAddInterview.setNeedsLayout()
        self.viewAddInterview.layoutIfNeeded()
        if let lstInterview =  self.detailProcessResume.lstInterviewHis {
            if lstInterview.count > 0{
                if lstInterview[lstInterview.count-1].status == 0{
                    self.heightViewInfo.constant = CGFloat(self.count! * 70) + self.viewAddInterview.frame.size.height + 60
                } else {
                    self.heightViewInfo.constant = CGFloat(self.count! * 70) + self.viewAddInterview.frame.size.height + self.viewButton.frame.size.height + 60
                }
            }else {
                self.heightViewInfo.constant = self.viewAddInterview.frame.size.height + self.viewButton.frame.size.height + 60
            }
        }
        self.viewInfo.layoutIfNeeded()
        self.viewInfo.setNeedsLayout()
        self.viewInfo.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.tableView.reloadData()
        if self.count! > 0 {
            self.tableView.scrollToRow(at: IndexPath(row:count!-1, section:0), at: .bottom, animated: true)
        }
    }
}
extension InterviewProcessController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterviewOfferCell", for: indexPath) as! InterviewOfferCell
        cell.lblRound.text = "\(self.detailProcessResume.lstInterviewHis![indexPath.row].round!)"
        cell.lblDate.text = self.detailProcessResume.lstInterviewHis![indexPath.row].interviewDate! == "" ? "" : "\(self.detailProcessResume.lstInterviewHis![indexPath.row].interviewDate!.substring(with: 0..<10))"
        cell.lblStatus.text = "\(self.switchStatus(value: self.detailProcessResume.lstInterviewHis![indexPath.row].status!))"
        return cell
    }
    func switchStatus(value:Int) -> String {
        var stringStatus:String
        switch value {
        case 1:
            stringStatus = "Đạt"
        case 2:
            stringStatus = "Không đạt"
        case 3:
            stringStatus = "Ứng viên không đến"
        default:
            stringStatus = "Chưa có kết quả"
        }
        return stringStatus
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var status:Int
        var rejectStep:Int = -1
        status = self.detailProcessResume.cvProcessInfo!.status!
        if let rejectstep = self.detailProcessResume.cvProcessInfo!.rejectStep{
            rejectStep = rejectstep
        }
        if status == 5 || status == 6 || (status == 4 && rejectStep == 2) {
            if status == 4 {
                self.pushViewController(controller: DetailInterviewController.init().setArgument(lstInterviewHi: self.detailProcessResume.lstInterviewHis![indexPath.row]))
            } else {
                if indexPath.row == self.count!-1 {
                    self.pushViewController(controller: CreateEditInterviewController.init().setArgument(lstInterviewHi: self.detailProcessResume.lstInterviewHis![indexPath.row], detailProcessResume: self.detailProcessResume, delegate: self))
                } else{
                    self.pushViewController(controller: DetailInterviewController.init().setArgument(lstInterviewHi: self.detailProcessResume.lstInterviewHis![indexPath.row]))
                }
            }
        }else{
            self.pushViewController(controller: DetailInterviewController.init().setArgument(lstInterviewHi: self.detailProcessResume.lstInterviewHis![indexPath.row]))
        }
   }
}
