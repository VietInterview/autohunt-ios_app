///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import AlamofireImage
import Alamofire

class MyJobAppliedController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate {
    var jobList = [JobListSaved]()
    var jobListServer = [JobListSaved]()
    var carrerId: Int = 0
    var cityId: Int = 0
    @IBOutlet weak var lblQuantityJOb: UILabel!
    var page = 0
    static let notificationName = Notification.Name("myNotificationName")
    var homeViewModel = HomeViewModel()
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.mTableView.refreshControl = refreshControl
        } else {
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MyJobAppliedController.notificationName, object: nil)
    }
    @objc func sortArray() {
        self.page = 0
        self.searchAppliedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchAppliedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
    }
    func searchAppliedJobs(carrerId:Int, cityId: Int, jobTitle: String, page: Int){
        homeViewModel.searchMyAppliedJob(carrerId: carrerId, cityId: cityId, jobTitle: "", page: page, success: {myJobApplied in
            self.lblQuantityJOb.text = "\(myJobApplied.total!) công việc được tìm thấy"
            if self.page == 0 {
                self.jobList = myJobApplied.jobList!
            } else {
                self.jobList.append(contentsOf: myJobApplied.jobList!)
            }
            self.jobListServer = myJobApplied.jobList!
            if self.page == 0 {
                self.quantityView.isHidden = false
                self.quantityView.visible()
                if #available(iOS 10.0, *) {
                    self.mTableView.refreshControl?.endRefreshing()
                }
            }
            
            self.mTableView.reloadData()
        }, failure: {error in
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobList.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.jobList.count - 1
        if  indexPath.row == lastElement {
            if self.jobListServer.count >= 30 {
                page = page + 1
                self.searchAppliedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJobController") as! DetailJobController
        vc.jobId = self.jobList[indexPath.row].id!
        vc.title = "Chi tiết công việc"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath) as! JobTableViewCell
        cell.labelJob.text = self.jobList[indexPath.row].jobTitle!
        cell.labelCompany.text = self.jobList[indexPath.row].companyName!
        cell.labelCarrer.text = self.jobList[indexPath.row].careerName!
        cell.labelCityList.text = self.jobList[indexPath.row].listcityName!
        cell.labelFee.text = "\(StringUtils.shared.currencyFormat(value:  self.jobList[indexPath.row].fee!)) \(StringUtils.shared.genString(value: self.jobList[indexPath.row].currency!))"
        cell.labelDeadlineDate.text = DateUtils.shared.convertToShowFormatDate(dateString: self.jobList[indexPath.row].expireDate!)
        if self.jobList[indexPath.row].collStatus == 0 {
            let image: UIImage = UIImage(named: "save")!;   cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = true
        } else if self.jobList[indexPath.row].collStatus == 1 {
            let image: UIImage = UIImage(named: "saved")!
            cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = true
        } else {
            let image: UIImage = UIImage(named: "tickok")!;  cell.imgSaveUnSaveJob.image = image
            cell.imgSaveUnSaveJob.isUserInteractionEnabled = false
        }
        Alamofire.request("https://dev.getbee.vn/\(self.jobList[indexPath.row].companyImg!)").responseImage { response in
            if let image = response.result.value {
                cell.imgCompany.image = image
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 240.0;
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            quantityView.isHidden = false
            quantityView.visible()
        } else {
            quantityView.gone()
            quantityView.isHidden = true
        }
    }
    @objc func onNotification(notification:Notification)
    {
        var dict : Dictionary = notification.userInfo!
        let isCarrer : Bool = dict["isCarrer"] as? Bool ?? true
        let isCity : Bool = dict["isCity"] as? Bool ?? true
        let id: Int = dict["id"] as? Int ?? 0
        if isCarrer {
            self.carrerId = id
        } else if isCity{
            self.cityId = id
        }
    }
}
