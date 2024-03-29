///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import AlamofireImage
import Alamofire

class DetailJobController: BaseViewController , CarbonTabSwipeNavigationDelegate, SendHeightView {
    @IBOutlet weak var spaceBottom: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var btnSaveUnsaveJob: UIButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var mViewTab: UIView!
    @IBOutlet weak var btnSendCV: UIButton!
    @IBOutlet weak var mViewContent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var viewParent: UIView!
    
    @IBOutlet weak var heightContent: NSLayoutConstraint!
    
    var homeViewModel = HomeViewModel()
    var jobId: Int = 0;
    var jobDetail = JobDetail()
    convenience init() {
        self.init(nibName: "DetailJobController", bundle: nil)
    }
    func setArgument(jobId:Int, title:String) -> DetailJobController{
        let vc = self.assignValueToController(nameController: "DetailJobController") as! DetailJobController
        vc.jobId = jobId
        vc.title = title
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        UIApplication.showNetworkActivity()
        homeViewModel.getDetailJob(jobId: self.jobId, success: {jobDetail in
           UIApplication.hideNetworkActivity()
            self.jobDetail = jobDetail
            self.imgCompany.showImage(imgUrl: self.jobDetail.companyImg, imageNullName: "job_null")
            self.lblCompany.text = jobDetail.companyName!
            self.lblJobTitle.text = jobDetail.jobTitle!
            if self.jobDetail.status! == 1 {
                self.btnStatus.setTitle(NSLocalizedString("hiring", comment: ""), for: .normal)
                self.btnStatus.backgroundColor = UIColor.green;
                self.footerView.isHidden = false
                self.footerView.visible()
            } else {
                self.btnStatus.setTitle(NSLocalizedString("closed", comment: ""), for: .normal)
                self.btnStatus.backgroundColor = UIColor.gray;
                self.footerView.isHidden = true
                self.footerView.gone()
            }
            self.btnStatus.layer.cornerRadius = 5
            self.btnStatus.layer.borderWidth = 1
            self.btnStatus.layer.borderColor = UIColor.clear.cgColor
            if self.jobDetail.collStatus! == 0 {
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.gray.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("save_job", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "save.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
            } else if self.jobDetail.collStatus! == 1 {
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.red.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("saved_job", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.red, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "saved.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
            } else {
                self.btnSaveUnsaveJob.backgroundColor = .green
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.clear.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("cv_applyed_tit", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.white, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "tickok_white.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
                self.btnSaveUnsaveJob.isUserInteractionEnabled = false
            }
            let tabSwipe = CarbonTabSwipeNavigation(items: [NSLocalizedString("info", comment: ""), NSLocalizedString("statistic", comment: ""), NSLocalizedString("cv_submited", comment: "")], delegate: self)
            
            if ScreenUtils.shared.getScreenWidth()! == 414 { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/7)
            } else { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/20)
            }
            tabSwipe.setNormalColor(UIColor.gray)
            tabSwipe.setSelectedColor(UIColor.black)
            tabSwipe.setIndicatorColor(UIColor.clear)
            tabSwipe.insert(intoRootViewController: self, andTargetView: self.mViewTab)
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    var isUpdate:Bool = false
    func sendHeight(height: Int) {
        if isUpdate == false{
            isUpdate = true
            self.heightContent.constant = 265 + CGFloat(height)
            self.mViewContent.layoutIfNeeded()
        }
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoController") as! InfoController
            vc.carrerName = self.jobDetail.careerName!
            vc.level = self.jobDetail.jobLevelName!
            vc.location = self.jobDetail.listcityName!
            vc.delegate = self
            vc.datePublic = DateUtils.shared.UTCToLocal(date: self.jobDetail.submitDate!)
            vc.dateExpiration = DateUtils.shared.UTCToLocal(date: self.jobDetail.expireDate!)
            if self.jobDetail.status! == 1 {
                vc.status = NSLocalizedString("hiring", comment: "")
            } else {
                vc.status = NSLocalizedString("closed", comment: "")
            }
            vc.salaryCandidate = "\(StringUtils.shared.currencyFormat(value: self.jobDetail.fromSalary!)) \(StringUtils.shared.genStringCurrency(value: self.jobDetail.currency!)) -  \(StringUtils.shared.currencyFormat(value: self.jobDetail.toSalary!)) \(StringUtils.shared.genStringCurrency(value: self.jobDetail.currency!))"
            vc.collaboratorsReward = "\(StringUtils.shared.currencyFormat(value:self.jobDetail.fee!)) VND"
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
        vc.jobDetail = self.jobDetail
        vc.title = NSLocalizedString("choice_cv", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveUnSaveJobTouch() {
        var status: Int
        if self.jobDetail.collStatus == nil || self.jobDetail.collStatus == 0 {
            status = 1
        } else {
            status = 0
        }
        
        homeViewModel.saveUnsaveJob(jobId: self.jobDetail.id!,status: status, success: {[unowned self] addRemoveJob in
            print(addRemoveJob.status!)
            if addRemoveJob.status! == 0{
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.gray.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("save_job", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.gray, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "save.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
            } else if addRemoveJob.status! == 1 {
                self.btnSaveUnsaveJob.backgroundColor = .clear
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.red.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("saved_job", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.red, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "saved.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
            } else {
                self.btnSaveUnsaveJob.backgroundColor = .green
                self.btnSaveUnsaveJob.layer.cornerRadius = 5
                self.btnSaveUnsaveJob.layer.borderWidth = 1
                self.btnSaveUnsaveJob.layer.borderColor = UIColor.clear.cgColor
                self.btnSaveUnsaveJob.setTitle(NSLocalizedString("cv_applyed_tit", comment: ""), for: .normal)
                self.btnSaveUnsaveJob.setTitleColor(.white, for: .normal)
                self.btnSaveUnsaveJob.setImage(UIImage(named: "tickok_white.png"), for: .normal)
                self.btnSaveUnsaveJob.contentHorizontalAlignment = .center
                self.btnSaveUnsaveJob.isUserInteractionEnabled = false
            }
            self.jobDetail.collStatus = addRemoveJob.status!
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    
}
