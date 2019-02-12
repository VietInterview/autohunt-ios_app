///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import AlamofireImage
import Alamofire

class MyJobSavedController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIScrollViewDelegate {
    var jobList = [JobListSaved]()
    var jobListServer = [JobListSaved]()
    var myJobSaved = MyJobSaved()
    var homeViewModel = HomeViewModel()
    var carrerId: Int = 0
    var cityId: Int = 0
    var page = 0
    let refreshControl = UIRefreshControl()
    static let notificationName = Notification.Name("myNotificationName")
//    @IBOutlet weak var lblQuantityJOb: UILabel!
//    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action:  #selector(sortArray), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.mTableView.refreshControl = refreshControl
        } else {
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MyJobSavedController.notificationName, object: nil)
    }
    @objc func sortArray() {
        self.page = 0
        self.searchSavedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.page = 0
        self.searchSavedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
    }
    func searchSavedJobs(carrerId:Int, cityId: Int, jobTitle: String, page: Int){
        homeViewModel.searchMySavedJob(carrerId: carrerId, cityId: cityId, jobTitle: jobTitle, page: page, success: {mySavedJob in
            self.myJobSaved = mySavedJob
            if self.page == 0 {
                self.jobList = mySavedJob.jobList!
            } else {
                self.jobList.append(contentsOf: mySavedJob.jobList!)
            }
            self.jobListServer = mySavedJob.jobList!
            if self.page == 0 {
                if #available(iOS 10.0, *) {
                    self.mTableView.refreshControl?.endRefreshing()
                }else {
                    self.mTableView.willRemoveSubview(self.refreshControl)
                }
            }
            
            self.mTableView.reloadData()
        }, failure: {error in
            if #available(iOS 10.0, *) {
                self.mTableView.refreshControl?.endRefreshing()
            }else {
                self.mTableView.willRemoveSubview(self.refreshControl)
            }
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
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
                self.searchSavedJobs(carrerId: self.carrerId,cityId: self.cityId,jobTitle: "",page: self.page)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailJobController") as! DetailJobController
        vc.jobId = self.jobList[indexPath.row].id!
        vc.title = NSLocalizedString("detail_job", comment: "")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobitemcell", for: indexPath) as! JobTableViewCell
        cell.labelJob.text = self.jobList[indexPath.row].jobTitle!
        cell.labelCompany.text = self.jobList[indexPath.row].companyName!
        cell.labelCarrer.text = self.jobList[indexPath.row].careerName!
        cell.labelCityList.text = self.jobList[indexPath.row].listcityName!
        cell.labelFee.text = "\(StringUtils.shared.currencyFormat(value:  self.jobList[indexPath.row].fee!)) VND"
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe(sender: )))
        cell.imgSaveUnSaveJob.addGestureRecognizer(tap)
        cell.imgSaveUnSaveJob.tag = indexPath.row
        if indexPath.row == 0 {
            cell.quantityView.isHidden = false
            cell.quantityView.visible()
            cell.lblQuantity.text = "\(self.myJobSaved.total!) \(NSLocalizedString("SuffixesJob", comment: ""))"
        } else {
            cell.quantityView.isHidden = true
            cell.quantityView.gone()
        }
        Alamofire.request("\(App.imgUrl)\(StringUtils.shared.checkEmpty(value: self.jobList[indexPath.row].companyImg))").responseImage { response in
            if let image = response.result.value {
                cell.imgCompany.image = image
            }else {
                  cell.imgCompany.layer.masksToBounds = true
                  cell.imgCompany.image = UIImage(named: "job_null")
            }
        }
        cell.viewContentCell.layer.shadowColor = UIColor.gray.cgColor
        cell.viewContentCell.layer.shadowOpacity = 0.3
        cell.viewContentCell.layer.shadowOffset = CGSize.zero
        cell.viewContentCell.layer.shadowRadius = 6
        cell.imgCompany.layer.masksToBounds = true
        cell.imgCompany.layer.borderWidth = 1
        cell.imgCompany.layer.cornerRadius = 5
        cell.imgCompany.layer.borderColor = StringUtils.shared.hexStringToUIColor(hex: "#979797").cgColor
        cell.imgCompany.layer.shadowColor = UIColor.gray.cgColor
        cell.imgCompany.layer.shadowOpacity = 0.3
        cell.imgCompany.layer.shadowOffset = CGSize.zero
        cell.imgCompany.layer.shadowRadius = 6
        return cell
    }
    @objc  func tappedMe(sender: UITapGestureRecognizer)
    {
        var status: Int
        if self.jobList[sender.view!.tag].collStatus == nil || self.jobList[sender.view!.tag].collStatus == 0 {
            status = 1
        } else {
            status = 0
        }
        
        self.homeViewModel.saveUnsaveJob(jobId: self.jobList[sender.view!.tag].id!,status: status, success: {[unowned self] addRemoveJob in
            print(addRemoveJob.status!)
            self.jobList[sender.view!.tag].collStatus = addRemoveJob.status!
            self.mTableView.reloadData()
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return 258.0;
        } else {
            return 208.0;
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
