///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class OfferProcessController: BaseViewController, SendOfferDelegate {
    
    @IBOutlet weak var heightOffer: NSLayoutConstraint!
    @IBOutlet weak var viewOffer: UIView!
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var viewAddOffer: UIView!
    @IBOutlet weak var btnAddOffer: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnGotowork: UIButton!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var lblReject: UILabel!
    
    var count:Int?
    static let onReceiveRejectOffer = Notification.Name("onReceiveRejectOffer")
    var detailProcessResume = DetailProcessResume()
    var rejectDelegate:RejectDelegate?
    var nextDelegate:NextDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: OfferProcessController.onReceiveRejectOffer, object: nil)
        if let LstOffer = self.detailProcessResume.lstOfferHis {
            self.count = LstOffer.count
        }else {
            self.count = 0
        }
        if self.count == 0 {
            self.pushViewController(controller: CreateEditOfferController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
        }
    }
    @objc func onNotification(notification:Notification)
    {
        self.showHideView(view: self.viewReject, isHidden: false)
        self.showHideView(view: self.viewButton, isHidden: true)
        self.showHideView(view: self.btnReject, isHidden: true)
        self.showHideView(view: self.btnGotowork, isHidden: true)
        self.showHideView(view: self.viewAddOffer, isHidden: true)
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
        if status == 7 || (status == 4 && rejectStep == 3) {
            if let lstOffer = self.detailProcessResume.lstOfferHis {
                if lstOffer.count > 0{
                    if lstOffer[lstOffer.count-1].status == 1{
                        self.showHideView(view: self.btnReject, isHidden: false)
                        self.showHideView(view: self.btnGotowork, isHidden: false)
                        self.showHideView(view: self.viewButton, isHidden: false)
                    } else if lstOffer[lstOffer.count-1].status == 2 {
                        self.showHideView(view: self.btnReject, isHidden: false)
                        self.showHideView(view: self.btnGotowork, isHidden: true)
                        self.showHideView(view: self.viewButton, isHidden: false)
                    }else {
                        self.showHideView(view: self.btnReject, isHidden: true)
                        self.showHideView(view: self.btnGotowork, isHidden: true)
                        self.showHideView(view: self.viewButton, isHidden: true)
                    }
                } else {
                    self.showHideView(view: self.btnReject, isHidden: true)
                    self.showHideView(view: self.btnGotowork, isHidden: true)
                    self.showHideView(view: self.viewButton, isHidden: true)
                }
            }else{
                self.showHideView(view: self.btnReject, isHidden: true)
                self.showHideView(view: self.btnGotowork, isHidden: true)
                self.showHideView(view: self.viewButton, isHidden: true)
            }
        }else {
            self.showHideView(view: self.viewButton, isHidden: true)
            self.showHideView(view: self.btnReject, isHidden: true)
            self.showHideView(view: self.btnGotowork, isHidden: true)
            self.showHideView(view: self.viewAddOffer, isHidden: true)
        }
        
        if self.detailProcessResume.cvProcessInfo!.status! == 4{
            if self.detailProcessResume.cvProcessInfo!.rejectStep! == 3 {
                self.showHideView(view: self.viewReject, isHidden: false)
                self.showHideView(view: self.viewButton, isHidden: true)
                self.showHideView(view: self.btnReject, isHidden: true)
                self.showHideView(view: self.btnGotowork, isHidden: true)
                self.showHideView(view: self.viewAddOffer, isHidden: true)
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
        self.viewOffer.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    @IBAction func addOfferTouch(_ sender: Any) {
        if let lstOffer = self.detailProcessResume.lstOfferHis {
            if lstOffer.count > 0 {
                if lstOffer[lstOffer.count-1].status! == 0 {
                    self.showMessage(title: "Thông báo", message: "Bạn phải cập nhật trạng thái offer trước, trước khi tạo offer mới", handler: { (action: UIAlertAction!) in
                        
                    })
                } else if lstOffer[lstOffer.count-1].status! == 2 {
                    self.pushViewController(controller: CreateEditOfferController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
                }else if lstOffer[lstOffer.count-1].status! == 1 {
                    self.showMessage(title: "Thông báo", message: "Lần offer gần nhất ứng viên đã đồng ý vì vậy bạn không thể thêm mới offer", handler: { (action: UIAlertAction!) in
                        
                    })
                }else {
                    self.pushViewController(controller: CreateEditOfferController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
                }
            } else {
                self.pushViewController(controller: CreateEditOfferController.init().setArgument(detailProcessResume: self.detailProcessResume, delegate: self))
            }
        }
    }
    
    func onSendOffer(lstOffer: LstOfferHi) {
        var isDuplicate:Bool = false
        if self.detailProcessResume.lstOfferHis!.count > 0 {
            for i in 0...self.detailProcessResume.lstOfferHis!.count-1 {
                if self.detailProcessResume.lstOfferHis![i].id! == lstOffer.id! {
                    isDuplicate = true
                    self.detailProcessResume.lstOfferHis![i] = lstOffer
                    break
                }
            }
            if isDuplicate == false {
                self.detailProcessResume.lstOfferHis!.append(lstOffer)
            }
            self.count = self.detailProcessResume.lstOfferHis!.count
            self.showList()
        } else {
            self.detailProcessResume.lstOfferHis!.append(lstOffer)
            self.count = self.detailProcessResume.lstOfferHis!.count
           self.showList()
        }
    }
    func showList(){
        tableView.maxHeight = CGFloat(self.count! * 70)
        self.heightOffer.constant = 190 + CGFloat(self.count! * 70)
        self.viewOffer.layoutIfNeeded()
        self.viewOffer.setNeedsLayout()
        self.viewOffer.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        self.viewReject.shadowView(opacity: 8/100, radius: 10, color: "#042E51")
        tableView.reloadData()
        if count! > 0 {
            tableView.scrollToRow(at: IndexPath(row:count!-1, section:0), at: .bottom, animated: true)
        }
    }
    @IBAction func goToWorkTouch(_ sender: Any) {
        self.nextDelegate?.onNext(step: 3, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
    }
    @IBAction func rejectTouch(_ sender: Any) {
        self.rejectDelegate?.onReject(step: 3, cvId: self.detailProcessResume.cvProcessInfo!.cvID!, jobId: self.detailProcessResume.jobID!)
    }
}
extension OfferProcessController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterviewOfferCell", for: indexPath) as! InterviewOfferCell
        cell.lblRound.text = "\(self.detailProcessResume.lstOfferHis![indexPath.row].round!)"
        cell.lblDate.text = self.detailProcessResume.lstOfferHis![indexPath.row].workTime! == "" ? "" : "\(self.detailProcessResume.lstOfferHis![indexPath.row].workTime!.substring(with: 0..<10))"
        cell.lblStatus.text = "\(self.switchStatus(value: self.detailProcessResume.lstOfferHis![indexPath.row].status!))"
        return cell
    }
    func switchStatus(value:Int) -> String {
        var stringStatus:String
        switch value {
        case 1:
            stringStatus = "Đồng ý"
        case 2:
            stringStatus = "Không đồng ý"
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
        if status == 7 || (status == 4 && rejectStep == 3) {
            if status == 4 {
                self.pushViewController(controller: DetailOfferController.init().setArgument(lstOffer: self.detailProcessResume.lstOfferHis![indexPath.row]))
            } else {
                if indexPath.row == self.count!-1 {
                    self.pushViewController(controller: CreateEditOfferController.init().setArgument(lstOffer: self.detailProcessResume.lstOfferHis![indexPath.row], detailProcessResume: self.detailProcessResume, delegate: self))
                } else{
                    self.pushViewController(controller: DetailOfferController.init().setArgument(lstOffer: self.detailProcessResume.lstOfferHis![indexPath.row]))
                }
            }
        }else{
            self.pushViewController(controller: DetailOfferController.init().setArgument(lstOffer: self.detailProcessResume.lstOfferHis![indexPath.row]))
        }
    }
}
