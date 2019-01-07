///**
/**
 Created by: Hiep Nguyen Nghia on 12/10/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import SwipeCellKit

class JobEmployerController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ChooseDelegate {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var tableViewJob: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnactionSearch: UIBarButtonItem!
    let viewModel = HomeViewModel()
    var isShowViewSearch:Bool = true
    var mJobList = [JobListCustomer]()
    var mJobListServer = [JobListCustomer]()
    var page:Int = 0
    var status:Int = -1
    let refreshControl = UIRefreshControl()
    var jobCustomer:JobCustomer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("job_list", comment: "")
        self.showHideView(view: self.viewSearch, isHidden: self.isShowViewSearch)
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.tableViewJob.refreshControl = refreshControl
        }
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.lblStatus.isUserInteractionEnabled = true
        self.lblStatus.addGestureRecognizer(gestureSwift2AndHigher2)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 0
        self.getJobCustomer(cusName: textFieldSearch.text!, page: page, status: status)
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = NSLocalizedString("status", comment: "")
        vc.isCarrer = false
        vc.isStatus = true
        vc.isCity = false
        vc.delegate = self
        vc.isCustomer = true
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.page = 0
        self.getJobCustomer(cusName: textFieldSearch.text!, page: page, status: status)
    }
    func didChoose(mychoose: MyChoose) {
        self.status = mychoose.id
        self.lblStatus.text = mychoose.name
    }
    @objc func sortArray() {
        self.page = 0
        self.getJobCustomer(cusName: textFieldSearch.text!, page: page, status: status)
    }
    
    func getJobCustomer(cusName:String, page:Int, status:Int){
        viewModel.getJobCustomer(cusName: textFieldSearch.text!, page: page, status: status, success: {jobCustomer in
            self.jobCustomer = jobCustomer
            if page == 0{
                self.mJobList = jobCustomer.jobList!
                if #available(iOS 10.0, *) {
                    self.tableViewJob.refreshControl?.endRefreshing()
                }else {
                    self.tableViewJob.willRemoveSubview(self.refreshControl)
                }
            } else {
                self.mJobList.append(contentsOf: jobCustomer.jobList!)
            }
            self.mJobListServer = jobCustomer.jobList!
            self.tableViewJob.reloadData()
        }, failure: {error in
            if #available(iOS 10.0, *) {
                self.tableViewJob.refreshControl?.endRefreshing()
            }else {
                self.tableViewJob.willRemoveSubview(self.refreshControl)
            }
             self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResumesEmployerController") as! ResumesEmployerController
        vc.mID = self.mJobList[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.mJobList.count - 1
        if  indexPath.row == lastElement {
            if self.mJobListServer.count >= 30 {
                page = page + 1
                self.getJobCustomer(cusName: self.textFieldSearch.text!, page: page, status: status)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 155;
        } else {
            return 115
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mJobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobEmployerCell", for: indexPath) as! JobEmployerCell
        if indexPath.row == 0 {
            self.showHideView(view: cell.viewQuantity, isHidden: false)
        } else {
            self.showHideView(view: cell.viewQuantity, isHidden: true)
        }
        let status = self.mJobList[indexPath.row].status!
        let limit = self.mJobList[indexPath.row].limited!
        if status == 1 && limit > 0 && limit < 8 {
            cell.lblStatus.text = "Sắp hết hạn"
        } else if status == 1 && limit > 7 {
            cell.lblStatus.text = "Còn " + "\(limit)" + " ngày"
        } else if status == 1 && limit == 0 {
            cell.lblStatus.text = "Đã hết hạn"
        } else if status == 0 {
            cell.lblStatus.text = "Nháp"
        }
        cell.lblQuantity.text = "\(self.jobCustomer!.total!) công việc được tìm thấy"
        cell.lblJobTitle.text = "\(mJobList[indexPath.row].jobTitle!)"
        cell.lblCountCV.text = "/\(mJobList[indexPath.row].countCv!)"
        cell.lblCountOffer.text = "\(self.mJobList[indexPath.row].countOffer!)"
        cell.delegate = self
        cell.contentView.shadowView(opacity: 8/100, radius: 10)
        return cell
    }
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
}
extension JobEmployerController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let read = SwipeAction(style: .default, title: nil) { action, indexPath in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailJobCustomerController") as! DetailJobCustomerController
            vc.jobId = self.mJobList[indexPath.row].id!
            vc.limit = self.mJobList[indexPath.row].limited!
            vc.status = self.mJobList[indexPath.row].status!
            vc.title = NSLocalizedString("detail_job", comment: "")
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
