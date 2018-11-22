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
    var vc = CarrerOrCityController()
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var mQuantityView: UIView!
    static let notificationName = Notification.Name("myNotificationName")
    @IBOutlet weak var mCVSubmitTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
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
                    self.mQuantityView.isHidden = false
                    self.mQuantityView.visible()
                    self.mCVSubmitTableView.refreshControl?.endRefreshing()
                }
            } else {
                self.cvListSubmit.append(contentsOf: listCVSubmit.cvList!)
                self.listCVSubmit.cvList!.append(contentsOf: listCVSubmit.cvList!)
            }
            self.lblQuantity.text = "\(listCVSubmit.total!) hồ sơ được tìm thấy"
            self.listCVServer = listCVSubmit.cvList!
            self.mCVSubmitTableView.reloadData()
        }, failure: {error in
            
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCVTableViewCell", for: indexPath) as! MyCVTableViewCell
        cell.lblName.text = self.listCVSubmit.cvList![indexPath.row].fullName!
        cell.lblDateUpdate.text = "Ngày nộp: \(DateUtils.shared.convertToShowFormatDate2(dateString: self.listCVSubmit.cvList![indexPath.row].updatedDate!))"
       cell.lblCarrer.text = self.listCVSubmit.cvList![indexPath.row].careerName!
        cell.btnStatus.setTitle(StringUtils.shared.genStringStatus(valueStatus: self.listCVSubmit.cvList![indexPath.row].status!) , for: .normal)
        cell.btnStatus.backgroundColor = StringUtils.shared.genColor(valueStatus: self.listCVSubmit.cvList![indexPath.row].status!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            mQuantityView.isHidden = false
            mQuantityView.visible()
        } else {
            mQuantityView.gone()
            mQuantityView.isHidden = true
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
