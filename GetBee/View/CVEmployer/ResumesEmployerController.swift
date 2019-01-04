///**
/**
 Created by: Hiep Nguyen Nghia on 12/11/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import SwipeCellKit

class ResumesEmployerController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewResume: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var btnactionSearch: UIBarButtonItem!
    
    var cvListByJobCustomer = [CvListByJobCustomer]()
    var cvListByJobCustomerServer = [CvListByJobCustomer]()
    var isShowViewSearch:Bool = true
    let viewModel = HomeViewModel()
    var page:Int = 0
    var status:Int = -1
    var mID:Int = 0
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Danh sách ứng viên"
        self.showHideView(view: self.viewSearch, isHidden: self.isShowViewSearch)
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewResume.refreshControl = refreshControl
        }else {
            self.tableViewResume.willRemoveSubview(self.refreshControl)
        }
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.page = 0
        self.getResumesByJobCus(cvName: self.textFieldSearch.text!, id: self.mID, page: page, status: self.status)
    }
    @objc func sortArray() {
        self.page = 0
         self.getResumesByJobCus(cvName: self.textFieldSearch.text!, id: self.mID, page: page, status: self.status)
    }
    func getResumesByJobCus(cvName:String, id:Int, page:Int, status:Int){
        self.viewModel.getResumesByJobCus(CvName: cvName, id: id, page: page, status: status, success: {resumesByJobCustomer in
            if page == 0 {
                self.cvListByJobCustomer = resumesByJobCustomer.cvList!
                if #available(iOS 10.0, *) {
                    self.tableViewResume.refreshControl?.endRefreshing()
                }else {
                    self.tableViewResume.willRemoveSubview(self.refreshControl)
                }
            } else {
                   self.cvListByJobCustomer.append(contentsOf: resumesByJobCustomer.cvList!)
            }
            self.cvListByJobCustomerServer = resumesByJobCustomer.cvList!
            self.tableViewResume.reloadData()
        }, failure: {error in
            if #available(iOS 10.0, *) {
                self.tableViewResume.refreshControl?.endRefreshing()
            }else {
                self.tableViewResume.willRemoveSubview(self.refreshControl)
            }
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: "error_please_try")
        })
    }
    @IBAction func searchTouch(_ sender: Any) {
        if self.isShowViewSearch {
            self.isShowViewSearch = false
            self.showHideView(view: self.viewSearch, isHidden: false)
            btnactionSearch.image = UIImage(named: "tick_black.png")
        } else {
            self.isShowViewSearch = true
            self.showHideView(view: self.viewSearch, isHidden: true)
            btnactionSearch.image = UIImage(named: "search.png")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvListByJobCustomer.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 120;
        } else {
            return 80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResumesEmployerCell", for: indexPath) as! ResumesEmployerCell
        if indexPath.row == 0 {
            self.showHideView(view: cell.viewQuantity, isHidden: false)
             self.showHideView(view: cell.lblQuantity, isHidden: false)
        } else {
            self.showHideView(view: cell.viewQuantity, isHidden: true)
            self.showHideView(view: cell.lblQuantity, isHidden: true)
        }
        cell.lblName.text = self.cvListByJobCustomer[indexPath.row].fullName!
        cell.lblDateSubmit.text = "\(self.cvListByJobCustomer[indexPath.row].countDay!) ngày trước"
        cell.delegate = self
        cell.btnStatus.addBorder(color: StringUtils.shared.hexStringToUIColor(hex: "#FF5A5A"), weight: 1)
        cell.btnStatus.addRadius(weight: 10)
        cell.contentView.shadowView(opacity: 8/100, radius: 10)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProcessResumeController") as! ProcessResumeController
        vc.jobId = self.mID
        vc.cvId = self.cvListByJobCustomer[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.cvListByJobCustomer.count - 1
        if  indexPath.row == lastElement {
            if self.cvListByJobCustomerServer.count >= 30 {
                page = page + 1
                self.getResumesByJobCus(cvName: self.textFieldSearch.text!, id: self.mID, page: page, status: self.status)
            }
        }
    }
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
}
extension ResumesEmployerController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let read = SwipeAction(style: .default, title: nil) { action, indexPath in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailResumeCustomerController") as! DetailResumeCustomerController
            vc.title = "Xem hồ sơ"
            vc.cvId = self.cvListByJobCustomer[indexPath.row].id!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        read.hidesWhenSelected = true
        let descriptor: ActionDescriptor = .read
        configure(action: read, with: descriptor)
        return [read]
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "info_detail_job")
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}
