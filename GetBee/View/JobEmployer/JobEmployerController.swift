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
        _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                debugLog(object: error)
            } else if let update = update {
                debugLog(object: update)
            }
        }
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
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        debugLog(object: currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version != currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
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
        vc.mID = self.mJobList[indexPath.row-1].id!
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
            return 44
        } else {
            return 115
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mJobList.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quantitycell", for: indexPath) as! SimpleCell
            if let jobCustomer = self.jobCustomer {
                if let total = jobCustomer.total {
                    cell.lblQuantity.text = "\(total) công việc được tìm thấy"

                }
            }
            cell.isUserInteractionEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobEmployerCell", for: indexPath) as! JobEmployerCell
            let status = self.mJobList[indexPath.row-1].status!
            let limit = self.mJobList[indexPath.row-1].limited!
            if status == 1 && limit > 0 && limit < 8 {
                cell.lblStatus.text = "Sắp hết hạn"
            } else if status == 1 && limit > 7 {
                cell.lblStatus.text = "Còn " + "\(limit)" + " ngày"
            } else if status == 1 && limit == 0 {
                cell.lblStatus.text = "Đã hết hạn"
            } else if status == 0 {
                cell.lblStatus.text = "Nháp"
            } else if status == 5 {
                cell.lblStatus.text = "Đã khóa"
            } else if status == 2 {
                cell.lblStatus.text = "Đã hết hạn"
            } else if status == 3 {
                cell.lblStatus.text = "Đã đóng"
            }
            cell.lblJobTitle.text = "\(mJobList[indexPath.row-1].jobTitle!)"
            cell.lblCountCV.text = "/\(mJobList[indexPath.row-1].countCv!)"
            cell.lblCountOffer.text = "\(self.mJobList[indexPath.row-1].countOffer!)"
            cell.delegate = self
            cell.contentView.shadowView(opacity: 8/100, radius: 10)
            return cell
        }
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
            vc.jobId = self.mJobList[indexPath.row-1].id!
            vc.limit = self.mJobList[indexPath.row-1].limited!
            vc.status = self.mJobList[indexPath.row-1].status!
            vc.title = NSLocalizedString("detail_job", comment: "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        read.hidesWhenSelected = true
        let descriptor: ActionDescriptor = .read
        configure(action: read, with: descriptor)
        return [read]
    }
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.image = UIImage(named: "job_info")
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#F2F9FF")
        case .circular:
            action.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#F2F9FF")
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}
