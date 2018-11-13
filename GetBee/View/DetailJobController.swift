///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit

class DetailJobController: UIViewController , CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var mViewTab: UIView!
    @IBOutlet weak var btnSendCV: UIButton!
    var homeViewModel = HomeViewModel()
    var jobId: Int = 0;
    var jobDetail = JobDetail()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        homeViewModel.getDetailJob(jobId: self.jobId, success: {jobDetail in
            LoadingOverlay.shared.hideOverlayView()
            self.jobDetail = jobDetail
            self.lblCompany.text = jobDetail.companyName!
            self.lblJobTitle.text = jobDetail.jobTitle!
            if self.jobDetail.status! == 1 {
                self.lblStatus.text = "Đang tuyển"
                self.lblStatus.backgroundColor = UIColor.green;
            } else {
                self.lblStatus.text = "Đã đóng"
                 self.lblStatus.backgroundColor = UIColor.gray;
            }
            let tabSwipe = CarbonTabSwipeNavigation(items: ["Thông tin", "Thống kê", "CV đã nộp"], delegate: self)
            tabSwipe.setTabExtraWidth(16)
            tabSwipe.insert(intoRootViewController: self, andTargetView: self.mViewTab)
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            print(error.description)
        })
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoController") as! InfoController
            vc.carrerName = self.jobDetail.careerName!
            vc.level = self.jobDetail.jobLevelName!
            vc.location = self.jobDetail.listcityName!
            vc.datePublic = DateUtils.shared.convertToShowFormatDate(dateString: self.jobDetail.submitDate!)
            vc.dateExpiration = DateUtils.shared.convertToShowFormatDate(dateString: self.jobDetail.expireDate!)
            if self.jobDetail.status! == 1 {
                vc.status = "Đang tuyển"
            } else {
                vc.status = "Đã đóng"
            }
            vc.salaryCandidate = "\(StringUtils.shared.currencyFormat(value: self.jobDetail.fromSalary!)) \(StringUtils.shared.genString(value: self.jobDetail.currency!)) -  \(StringUtils.shared.currencyFormat(value: self.jobDetail.toSalary!)) \(StringUtils.shared.genString(value: self.jobDetail.currency!))"
            vc.collaboratorsReward = "\(StringUtils.shared.currencyFormat(value:self.jobDetail.fee!)) \(StringUtils.shared.genString(value: self.jobDetail.currency!))"
            vc.quantityCVSend = "\(self.jobDetail.countCv!)"
            vc.quantityHiring = "\(self.jobDetail.quantity!)"
            vc.jobDescription = StringUtils.shared.stringFromHtml(string: self.jobDetail.jobDescription!)!
            return vc
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "StatisticalController") as! StatisticalController
            vc.CountCV = "\(self.jobDetail.countCv!)"
            vc.CountCared = "\(self.jobDetail.countColl!)"
            vc.CountInterviewd = "\(self.jobDetail.countInterview!)"
            vc.CountOffer = "\(self.jobDetail.countOffer!)"
            vc.CountGoToWork = "\(self.jobDetail.countGotoWork!)"
            vc.MyCountCV = "\(self.jobDetail.myCountCv!)"
            vc.MyCountInviteInterview = "\(self.jobDetail.myCountInviteInterview!)"
            vc.MyCountInterviewed = "\(self.jobDetail.myCountInterview!)"
            vc.MyCountOffered = "\(self.jobDetail.myCountOffer!)"
            vc.MyCountGoToWork = "\(self.jobDetail.myCountGotoWork!)"
            return vc
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "CVSendController") as! CVSendController
            if self.jobDetail.lstJobApply != nil{
                vc.lstJobApply = self.jobDetail.lstJobApply!
            }
            return vc
        }
    }
}
