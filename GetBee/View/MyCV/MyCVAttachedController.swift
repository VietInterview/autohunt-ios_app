///**
/**
Created by: Hiep Nguyen Nghia on 2/12/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import SwipeCellKit
import Toaster

class MyCVAttachedController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NotifyConfirmAlertDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    var page:Int = 0
    var status:Int = -1
    let refreshControl = UIRefreshControl()
    var listCV2 = [CvList2]()
    var carrerId: Int = -1
    var cityId: Int = -1
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var vc = CarrerOrCityController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        }else {
            tableView.addSubview(refreshControl)
        }
    }
    @objc func sortArray() {
        self.page = 0
//        self.getJobCustomer(cusName: textFieldSearch.text!, page: page, status: status)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ResumesEmployerController") as! ResumesEmployerController
//        vc.mID = self.mJobList[indexPath.row-1].id!
//        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastElement = self.mJobList.count - 1
//        if  indexPath.row == lastElement {
//            if self.mJobListServer.count >= 30 {
//                page = page + 1
//                self.getJobCustomer(cusName: self.textFieldSearch.text!, page: page, status: status)
//            }
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 44
        } else {
            return 105
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quantitycell", for: indexPath) as! SimpleCell
//            if let jobCustomer = self.jobCustomer {
//                if let total = jobCustomer.total {
                    cell.lblQuantity.text = "13 công việc được tìm thấy"
                    
//                }
//            }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCVTableViewCell", for: indexPath) as! MyCVTableViewCell
            cell.btnStatus.setTitle("Chưa hỗ trợ", for: .normal)
            cell.btnStatus.setTitleColor(StringUtils.hexStringToUIColor(hex: "#FF5A5A"), for: .normal)
            cell.btnStatus.addBorder(color: StringUtils.hexStringToUIColor(hex: "#FF5A5A"), weight: 1)
            cell.btnStatus.addRadius(weight: 12, isBound: true)
//            let status = self.mJobList[indexPath.row-1].status!
//            let limit = self.mJobList[indexPath.row-1].limited!
//            if status == 1 && limit > 0 && limit < 8 {
//                cell.lblStatus.text = "Sắp hết hạn"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#FF5A5A")
//                cell.imgTime.image = UIImage(named: "time_deadline")
//            } else if status == 1 && limit > 7 {
//                cell.lblStatus.text = "Còn " + "\(limit)" + " ngày"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            } else if status == 1 && limit == 0 {
//                cell.lblStatus.text = "Đã hết hạn"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            } else if status == 0 {
//                cell.lblStatus.text = "Nháp"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            } else if status == 5 {
//                cell.lblStatus.text = "Đã khóa"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            } else if status == 2 {
//                cell.lblStatus.text = "Đã hết hạn"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            } else if status == 3 {
//                cell.lblStatus.text = "Ngưng tuyểnđidi"
//                cell.lblStatus.textColor = StringUtils.hexStringToUIColor(hex: "#677B8D")
//                cell.imgTime.image = UIImage(named: "time_gray")
//            }
//            cell.lblJobTitle.text = "\(mJobList[indexPath.row-1].jobTitle!)"
//            cell.lblCountCV.text = "/\(mJobList[indexPath.row-1].countCv!)"
//            cell.lblCountOffer.text = "\(self.mJobList[indexPath.row-1].countOffer!)"
            cell.delegate = self
            cell.contentView.shadowView(opacity: 8/100, radius: 10)
            return cell
        }
    }
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
//}
}
extension MyCVAttachedController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "NotifyConfirmAlert") as! NotifyConfirmAlert
//            customAlert.id = self.listCV2[indexPath.row].id!
            customAlert.position = indexPath.row
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
        }
        let descriptor: ActionDescriptor = .trash
        configure(action: deleteAction, with: descriptor)
        let copy = SwipeAction(style: .default, title: nil) { action, indexPath in
        }
        copy.hidesWhenSelected = true
        let descriptorCopy: ActionDescriptor = .read
        configureCopy(action: copy, with: descriptorCopy)
        return [deleteAction,copy]
    }
    
    
    func okButtonTapped(id: Int, position: Int) {
        self.viewModel.deleteCV(cvId: id, success: { deleteCV in
            if deleteCV.count! > 0 {
                self.listCV2.remove(at: position)
                let toast = Toast(text: NSLocalizedString("delete_cv_success", comment: ""))
                toast.show()
            } else {
                let toast = Toast(text: NSLocalizedString("delete_cv_fail", comment: ""))
                toast.show()
                self.page = 0
                if self.carrerId != -1 || self.cityId != -1{
//                    self.searchMyCV(carrerId: self.carrerId, cityId: self.cityId)
                } else {
//                    self.getMyCVSaved()
                }
            }
        }, failure: {error in
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    
    func cancelButtonTapped() {
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    func configureCopy(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "download_resume")
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
        case .circular:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "delete_resume")!
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
        case .circular:
            action.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F2F9FF")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}
