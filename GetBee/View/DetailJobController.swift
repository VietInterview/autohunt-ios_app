///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import AlamofireImage
import Alamofire

class DetailJobController: UIViewController , CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var btnSaveUnsaveJob: UIButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var mViewTab: UIView!
    @IBOutlet weak var btnSendCV: UIButton!
    var homeViewModel = HomeViewModel()
    var jobId: Int = 0;
    var jobDetail = JobDetail()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        homeViewModel.getDetailJob(jobId: self.jobId, success: {jobDetail in
            LoadingOverlay.shared.hideOverlayView()
            self.jobDetail = jobDetail
            Alamofire.request("https://dev.getbee.vn/\(self.jobDetail.companyImg!)").responseImage { response in
                if let image = response.result.value {
                    self.imgCompany.image = image
                }
            }
            self.lblCompany.text = jobDetail.companyName!
            self.lblJobTitle.text = jobDetail.jobTitle!
            if self.jobDetail.status! == 1 {
                self.btnStatus.setTitle("Đang tuyển", for: .normal)
                self.btnStatus.backgroundColor = UIColor.green;
            } else {
                self.btnStatus.setTitle("Đã đóng", for: .normal)
                 self.btnStatus.backgroundColor = UIColor.gray;
            }
            self.btnStatus.layer.cornerRadius = 5
            self.btnStatus.layer.borderWidth = 1
            self.btnStatus.layer.borderColor = UIColor.clear.cgColor
            if self.jobDetail.collStatus! == 0 {
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.gray.cgColor
                self.btnSaveUnsaveJob.setTitle("Lưu công việc", for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "save.png"), for: .normal)
                self.btnSaveUnsaveJob.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.5, 0.0, 0.0)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .left
                self.btnSaveUnsaveJob.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            } else if self.jobDetail.collStatus! == 1 {
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.red.cgColor
                self.btnSaveUnsaveJob.setTitle("Đã lưu việc", for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.red, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "saved.png"), for: .normal)
                self.btnSaveUnsaveJob.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.5, 0.0, 0.0)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .left
                self.btnSaveUnsaveJob.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            } else {
                self.btnSaveUnsaveJob.backgroundColor = .green
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.clear.cgColor
                self.btnSaveUnsaveJob.setTitle("Đã ứng tuyển", for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.white, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "tickok_white.png"), for: .normal)
                self.btnSaveUnsaveJob.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.5, 0.0, 0.0)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .left
                self.btnSaveUnsaveJob.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            }
            let tabSwipe = CarbonTabSwipeNavigation(items: ["Thông tin", "Thống kê", "CV đã nộp"], delegate: self)
            
            if ScreenUtils.shared.getScreenWidth()! == 414 { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/7)
            } else { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/20)
            }
            tabSwipe.setNormalColor(UIColor.gray)
            tabSwipe.setSelectedColor(UIColor.black)
            tabSwipe.setIndicatorColor(UIColor.clear)
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
            vc.requireJobContent = StringUtils.shared.stringFromHtml(string: StringUtils.shared.checkEmpty(value: self.jobDetail.jobRequirements))!
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
    
    @IBAction func submitCVTouch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseCVSubmitController") as! ChooseCVSubmitController
        vc.jobId = self.jobDetail.id!
        vc.title = "Chọn CV của tôi"
        self.navigationController?.pushViewController(vc, animated: true)
//        homeViewModel.getMyCVSubmit(carrerId: 0, cityId: 0, page: 0, success: {myCV in
//
//
//        }, failure: {error in
//
//        })
    }
    
    
}
