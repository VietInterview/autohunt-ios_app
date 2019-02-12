///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class MyCVAppliedController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var listCVSubmit = ListCVSubmit()
    var listCVServer = [CvListSubmit]()
    var cvListSubmit = [CvListSubmit]()
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var carrerId: Int = 0
    var cityId: Int = 0
    var status: Int = 11
    var page: Int = 0
    var homeViewModel = HomeViewModel()
    let refreshControl = UIRefreshControl()
    var vc = CarrerOrCityController()
    static let notificationName = Notification.Name("myNotificationName")
    @IBOutlet weak var mCVSubmitTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action:  #selector(refresh), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.mCVSubmitTableView.refreshControl = refreshControl
        } else {
        }
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MyCVAppliedController.notificationName, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.page = 0
        self.getCVSubmit()
    }
    func getCVSubmit(){
        self.homeViewModel.getListCVSubmit(carrerId: self.carrerId, cityId: self.cityId, statusId: self.status, page: self.page, success: {listCVSubmit in
            if self.page == 0 {
                self.listCVSubmit = listCVSubmit
                self.cvListSubmit = listCVSubmit.cvList!
                if #available(iOS 10.0, *) {
                    self.mCVSubmitTableView.refreshControl?.endRefreshing()
                }else {
                    self.mCVSubmitTableView.willRemoveSubview(self.refreshControl)
                }
            } else {
                self.cvListSubmit.append(contentsOf: listCVSubmit.cvList!)
                self.listCVSubmit.cvList!.append(contentsOf: listCVSubmit.cvList!)
            }
            self.listCVServer = listCVSubmit.cvList!
            self.mCVSubmitTableView.reloadData()
        }, failure: {error in
            if #available(iOS 10.0, *) {
                self.mCVSubmitTableView.refreshControl?.endRefreshing()
            }
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    @objc func refresh() {
        self.page = 0
        self.getCVSubmit()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.listCVSubmit.cvList!.count - 1
        if  indexPath.row == lastElement {
            if self.listCVServer.count >= 30 {
                page = page + 1
                self.getCVSubmit()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cvListSubmit.count > 0 {
            return self.cvListSubmit.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCVController") as! DetailCVController
        vc.title = ""
        vc.cvId = self.cvListSubmit[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCVTableViewCell", for: indexPath) as! MyCVTableViewCell
        cell.lblName.text = self.listCVSubmit.cvList![indexPath.row].fullName!
        cell.lblDateUpdate.text = "\(NSLocalizedString("update", comment: "")) \(DateUtils.convertToShowFormatDate2(dateString: self.listCVSubmit.cvList![indexPath.row].updatedDate!))"
        cell.lblCarrer.text = self.listCVSubmit.cvList![indexPath.row].careerName!
        cell.btnStatus.setTitle(StringUtils.genStringStatus(valueStatus: self.listCVSubmit.cvList![indexPath.row].status!) , for: .normal)
        cell.btnStatus.backgroundColor = StringUtils.genColor(valueStatus: self.listCVSubmit.cvList![indexPath.row].status!)
        cell.lblJobTitle.text = StringUtils.checkEmpty(value: self.listCVSubmit.cvList![indexPath.row].jobTitle)
        if indexPath.row == 0 {
            cell.mQuantityView.isHidden = false
            cell.mQuantityView.visible()
            cell.lblQuantityView.text = "\(self.listCVSubmit.total!) \(NSLocalizedString("SuffixesCv", comment: ""))"
        } else {
            cell.mQuantityView.isHidden = true
            cell.mQuantityView.gone()
        }
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = StringUtils.hexStringToUIColor(hex: "#F7FAFF")
        } else {
            cell.backgroundColor = StringUtils.hexStringToUIColor(hex: "#FFFFFF")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 190
        } else {
            return 130
        }
    }
    @objc func onNotification(notification:Notification)
    {
        var dict : Dictionary = notification.userInfo!
        let isCarrer : Bool = dict["isCarrer"] as? Bool ?? true
        let isCity : Bool = dict["isCity"] as? Bool ?? true
        let isStatus : Bool = dict["isStatus"] as? Bool ?? true
        let id: Int = dict["id"] as? Int ?? 0
        if isCarrer {
            self.carrerId = id
        } else if isStatus {
            self.status = id
        } else if isCity{
            self.cityId = id
        }
    }
}
