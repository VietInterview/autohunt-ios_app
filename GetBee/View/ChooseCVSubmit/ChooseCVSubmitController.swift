///**
/**
 Created by: Hiep Nguyen Nghia on 11/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import GoneVisible

class ChooseCVSubmitController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var cvList = [CvList]()
    var cvListServer = [CvList]()
    var jobDetail = JobDetail()
    var jobId: Int = 0
    var page:Int = 0
    var homeViewModel = HomeViewModel()
    @IBOutlet weak var lblChooseMyCV: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.mTableView.refreshControl = refreshControl
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        self.page = 0
        getMyCV()
    }
    @objc func refresh() {
        self.page = 0
        getMyCV()
    }
    func getMyCV(){
        self.homeViewModel.getMyCVSubmit(carrerId: 0, cityId: 0, page: self.page, success: {myCV in
            if self.page == 0{
                self.cvList = myCV.cvList!
                if #available(iOS 10.0, *) {
                    self.mTableView.refreshControl?.endRefreshing()
                    self.quantityView.isHidden = false
                    self.quantityView.visible()
                }
            } else {
                self.cvList.append(contentsOf: myCV.cvList!)
            }
            self.cvListServer = myCV.cvList!
            self.lblChooseMyCV.text = "\(self.cvList.count) hồ sơ được tìm thấy"
            self.mTableView.reloadData()
        }, failure: {error in
            self.showMessage(title: "Thông báo", message: error.description)
        })
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.cvList.count - 1
        if  indexPath.row == lastElement {
            if self.cvListServer.count >= 30 {
                page = page + 1
                self.getMyCV()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cvList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CVSubmitTableViewCell", for: indexPath) as! CVSubmitTableViewCell
        cell.lblName.text = self.cvList[indexPath.row].fullName!
        cell.lblCarrer.text = self.cvList[indexPath.row].careerName!
        cell.lblDateUpdate.text = DateUtils.shared.UTCToLocal(date: self.cvList[indexPath.row].updatedDate!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCVController") as! DetailCVController
        vc.title = "Chi tiết Hồ sơ"
        vc.jobId = self.jobId
        vc.jobDetail = self.jobDetail
        vc.cvId = self.cvList[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            quantityView.isHidden = false
            quantityView.visible()
            //            self.actionButton.visible()
        } else {
            quantityView.gone()
            //            self.actionButton.gone()
            quantityView.isHidden = true
        }
    }
}
