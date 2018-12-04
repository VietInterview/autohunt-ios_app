///**
/**
 Created by: Hiep Nguyen Nghia on 11/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import GoneVisible

class ChooseCVSubmitController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var lblNoCV: UILabel!
    
    var cvList = [CvList]()
    var cvListServer = [CvList]()
    var jobDetail = JobDetail()
    var jobId: Int = 0
    var page:Int = 0
    var homeViewModel = HomeViewModel()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                }else {
                    self.mTableView.willRemoveSubview(self.refreshControl)
                }
            } else {
                self.cvList.append(contentsOf: myCV.cvList!)
            }
            if myCV.total! == 0{
                self.lblNoCV.isHidden = false
                self.lblNoCV.visible()
                self.mTableView.isHidden = true
                self.mTableView.gone()
            } else {
                self.lblNoCV.isHidden = true
                self.lblNoCV.gone()
                self.mTableView.isHidden = false
                self.mTableView.visible()
            }
            self.cvListServer = myCV.cvList!
            self.mTableView.reloadData()
        }, failure: {error in
            if #available(iOS 10.0, *) {
                self.mTableView.refreshControl?.endRefreshing()
            }else {
                self.mTableView.willRemoveSubview(self.refreshControl)
            }
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error.description)
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
        if indexPath.row == 0 {
            cell.mViewQuantity.isHidden = false
            cell.mViewQuantity.visible()
            cell.lblQuantity.text = "\(self.cvList.count) \(NSLocalizedString("SuffixesCv", comment: ""))"
        } else {
            cell.mViewQuantity.isHidden = true
            cell.mViewQuantity.gone()
        }
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#F7FAFF")
        } else {
            cell.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#FFFFFF")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        } else {
            return 128
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCVController") as! DetailCVController
        vc.title = ""
        vc.jobId = self.jobId
        vc.jobDetail = self.jobDetail
        vc.cvId = self.cvList[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
}
