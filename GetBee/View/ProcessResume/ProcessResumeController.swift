///**
/**
 Created by: Hiep Nguyen Nghia on 12/20/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import FlexibleSteppedProgressBar

class ProcessResumeController: BaseViewController, CarbonTabSwipeNavigationDelegate, FlexibleSteppedProgressBarDelegate, RejectDelegate, NextDelegate,UIActionSheetDelegate {
    
    @IBOutlet weak var lblReasonReject: UILabel!
    @IBOutlet weak var viewListReasonReject: UIView!
    @IBOutlet var viewReject: UIView!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var viewTemp: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewTab: UIView!
    @IBOutlet weak var lblStepName: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet var viewNext: UIView!
    @IBOutlet weak var textfieldReasonNote: UITextField!
    @IBOutlet weak var lblInvite: UILabel!
    
    var isNext:Int = 0
    var reasonRejectId:Int = -1
    var detailProcessResume:DetailProcessResume?
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 53.0 / 255.0, green: 226.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var position:UInt = 0
    var maxIndex = -1
    var tabSwipe = CarbonTabSwipeNavigation()
    var myScrollView : UIScrollView!
    var cvId:Int = 0
    var jobId:Int = 0
    var Step:Int = 0
    var StepClick:Int = 0
    let viewModel = HomeViewModel()
    var effect:UIVisualEffect!
    var listReasonReject = ListRejectReason()
    var rejectStepSend:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.title = "Xử lý hồ sơ"
        setupProgressBarWithoutLastState()
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction))
        self.viewListReasonReject.isUserInteractionEnabled = true
        self.viewListReasonReject.addGestureRecognizer(gestureSwift2AndHigher)
    }
    @objc func someAction(sender:UITapGestureRecognizer){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Lý do từ chối", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        for i in 0...self.listReasonReject.count-1{
            if self.listReasonReject[i].step! == self.rejectStepSend{
                actionSheetControllerIOS8.addAction(UIAlertAction(title: self.listReasonReject[i].name!, style: .default)
                { _ in
                    if self.listReasonReject[i].name! == "Khác" {
                        self.textfieldReasonNote.isUserInteractionEnabled = true
                    } else {
                        self.textfieldReasonNote.text = ""
                        self.textfieldReasonNote.isUserInteractionEnabled = false
                    }
                   self.lblReasonReject.text = self.listReasonReject[i].name!
                })
            }
        }
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    func setupProgressBarWithoutLastState() {
        progressBarWithoutLastState = FlexibleSteppedProgressBar()
        progressBarWithoutLastState.translatesAutoresizingMaskIntoConstraints = false
        self.stepView.addSubview(progressBarWithoutLastState)
        let horizontalConstraint = progressBarWithoutLastState.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = progressBarWithoutLastState.centerYAnchor.constraint(equalTo: self.stepView.centerYAnchor)
        let widthConstraint = progressBarWithoutLastState.widthAnchor.constraint(equalToConstant:ScreenUtils.shared.getScreenWidth() == 414 ? 320 : 250)
        let heightConstraint = progressBarWithoutLastState.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([horizontalConstraint,verticalConstraint, widthConstraint, heightConstraint])
        
        progressBarWithoutLastState.numberOfPoints = 5
        progressBarWithoutLastState.lineHeight = 2
        progressBarWithoutLastState.radius = 10
        progressBarWithoutLastState.progressRadius = 10
        progressBarWithoutLastState.progressLineHeight = 2
        progressBarWithoutLastState.delegate = self
        progressBarWithoutLastState.selectedBackgoundColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        progressBarWithoutLastState.selectedOuterCircleStrokeColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        progressBarWithoutLastState.currentSelectedCenterColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        progressBarWithoutLastState.stepTextColor = textColorHere
        progressBarWithoutLastState.currentSelectedTextColor = progressColor
        progressBarWithoutLastState.currentIndex = 0
        
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, didSelectItemAtIndex index: Int) {
        
        if let rejectstep = self.detailProcessResume!.cvProcessInfo!.rejectStep {
            if index <= rejectstep-1 {
                self.position = UInt(index)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.Step = index
                self.lblStep.text = "Bước \(self.Step+1)/5"
                self.lblStepName.text = self.switchStepName(step: self.Step)
                progressBar.currentIndex = index
                maxIndex = index
                progressBar.completedTillIndex = maxIndex
                progressBarWithoutLastState.currentIndex = self.Step
            }
        } else {
            if index <= self.StepClick {
                self.position = UInt(index)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.Step = index
                self.lblStep.text = "Bước \(self.Step+1)/5"
                self.lblStepName.text = self.switchStepName(step: self.Step)
                progressBar.currentIndex = index
                maxIndex = index
                progressBar.completedTillIndex = maxIndex
                progressBarWithoutLastState.currentIndex = self.Step
            }
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        if let rejectstep = self.detailProcessResume!.cvProcessInfo!.rejectStep {
            if index <= rejectstep-1 {
                self.position = UInt(index)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.Step = index
                self.lblStep.text = "Bước \(self.Step+1)/5"
                self.lblStepName.text = self.switchStepName(step: self.Step)
                progressBar.currentIndex = index
                maxIndex = index
                progressBar.completedTillIndex = maxIndex
                progressBarWithoutLastState.currentIndex = self.Step
                
                return true
            }
        } else {
            if index <= self.StepClick {
                self.position = UInt(index)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.Step = index
                self.lblStep.text = "Bước \(self.Step+1)/5"
                self.lblStepName.text = self.switchStepName(step: self.Step)
                progressBar.currentIndex = index
                maxIndex = index
                progressBar.completedTillIndex = maxIndex
                progressBarWithoutLastState.currentIndex = self.Step
                
                return true
            }
        }
        return false
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBarWithoutLastState {
            if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                case 4: return "5"
                default: return "0"
                    
                }
            }
        }
        return ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewListReasonReject.addBorder()
        self.viewListReasonReject.addRadius()
        if self.detailProcessResume != nil {
        } else {
            self.viewModel.getDetailProcessResume(cvId: self.cvId, jobId: self.jobId, success: {detailProcessResume in
                self.detailProcessResume = detailProcessResume
                var status:Int
                var rejectStep:Int = -1
                status = self.detailProcessResume!.cvProcessInfo!.status!
                if let rejectstep = self.detailProcessResume!.cvProcessInfo!.rejectStep{
                    rejectStep = rejectstep
                }
                if status == 3 || (status == 4 && rejectStep == 1) {
                    self.Step = 0
                    self.StepClick = 0
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step
                } else if status == 5 || status == 6 || (status == 4 && rejectStep == 2) {
                    self.Step = 1
                    self.StepClick = 1
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step
                } else if status == 7 || (status == 4 && rejectStep == 3) {
                    self.Step = 2
                    self.StepClick = 2
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step
                } else if status == 8 || (status == 4 && rejectStep == 4) {
                    self.Step = 3
                    self.StepClick = 3
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step
                } else if status == 9 || (status == 4 && rejectStep == 5) {
                    self.Step = 4
                    self.StepClick = 4
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step
                } else if let rejectStep = self.detailProcessResume!.cvProcessInfo!.rejectStep {
                    self.Step = rejectStep
                    self.StepClick = rejectStep
                    self.lblStep.text = "Bước \(self.Step+1)/5"
                    self.lblStepName.text = self.switchStepName(step: self.Step)
                    self.position = UInt(self.Step-1)
                    self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                    self.progressBarWithoutLastState.currentIndex = self.Step-1
                }
                self.setupTabSwipe(pos: self.position)
            }, failure: {error in
                self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
            })
        }
    }
    func switchStepName(step:Int) -> String{
        var stepName:String
        switch step {
        case 0:
            stepName = "Thông tin"
        case 1:
            stepName = "Phỏng vấn"
        case 2:
            stepName = "Offer"
        case 3:
            stepName = "Đi làm"
        case 4:
            stepName = "Ký hợp đồng"
        default:
            stepName = "Thông tin"
        }
        return stepName
    }
    func setupTabSwipe(pos:UInt){
        tabSwipe = CarbonTabSwipeNavigation(items: ["THÔNG TIN", "PHỎNG VẤN", "OFFER","ĐI LÀM", "KÝ HỢP ĐỒNG"], delegate: self)
        if ScreenUtils.shared.getScreenWidth()! == 414 { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/7)
        } else {
            tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/20)
        }
        self.showHideView(view: tabSwipe.carbonSegmentedControl!, isHidden: true)
        tabSwipe.carbonSegmentedControl?.backgroundColor = UIColor.clear
        tabSwipe.setNormalColor(StringUtils.shared.hexStringToUIColor(hex: "#677B8D"), font: UIFont(name: "Roboto-Medium", size: 14)!)
        tabSwipe.setSelectedColor(StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), font: UIFont(name: "Roboto-Medium", size: 14)!)
        tabSwipe.setIndicatorColor(StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"))
        tabSwipe.insert(intoRootViewController: self, andTargetView: self.viewTab)
        tabSwipe.toolbar.clipsToBounds = true
        tabSwipe.pagesScrollView?.isScrollEnabled = false
        tabSwipe.setCurrentTabIndex(pos, withAnimation: true)
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoProcessResumeController") as! InfoProcessResumeController
            vc.nextDelegate = self
            vc.rejectDelegate = self
            vc.detailProcessResume = self.detailProcessResume!
            return vc
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "InterviewProcessController") as! InterviewProcessController
            vc.nextDelegate = self
            vc.rejectDelegate = self
            vc.detailProcessResume = self.detailProcessResume!
            return vc
        } else if index == 2{
            let vc = storyboard.instantiateViewController(withIdentifier: "OfferProcessController") as! OfferProcessController
            vc.nextDelegate = self
            vc.rejectDelegate = self
            vc.detailProcessResume = self.detailProcessResume!
            return vc
        }else if index == 3{
            let vc = storyboard.instantiateViewController(withIdentifier: "GoToWorkProcessController") as! GoToWorkProcessController
            vc.nextDelegate = self
            vc.rejectDelegate = self
            vc.detailProcessResume = self.detailProcessResume
            return vc
        }else{
            let vc = storyboard.instantiateViewController(withIdentifier: "ContractProcessController") as! ContractProcessController
            vc.rejectDelegate = self
            vc.detailProcessResume = self.detailProcessResume
            return vc
        }
    }
    
    @IBAction func btnNoTouch(_ sender: Any) {
        self.btnCloseTouch()
    }
    
    
    @IBAction func btnCloseTouch() {
        if self.isNext == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewNext.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.viewNext.alpha = 0
                self.visualEffectView.effect = nil
                self.visualEffectView.isHidden = true
            }) { (success:Bool) in
                self.viewNext.removeFromSuperview()
            }
        } else if self.isNext == 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewReject.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.viewReject.alpha = 0
                self.visualEffectView.effect = nil
                self.visualEffectView.isHidden = true
            }) { (success:Bool) in
                self.viewReject.removeFromSuperview()
            }
        }
    }
    
    @IBAction func sendInvite(_ sender: Any) {
        if self.Step == 1 {
            self.viewModel.inviteInterview(cvId: self.cvId, jobId: self.jobId, success: {
                self.position = UInt(self.Step+1)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.btnCloseTouch()
            }, failure: {error in
                self.position = UInt(self.Step)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.progressBarWithoutLastState.currentIndex = self.Step
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: true)
                self.detailProcessResume!.cvProcessInfo!.status! = 5
                self.btnCloseTouch()
            })
        } else if self.Step == 2 {
            self.viewModel.offerStatus(cvId: self.cvId, jobId: self.jobId, success: {
                
            }, failure: {error in
                self.position = UInt(self.Step)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.progressBarWithoutLastState.currentIndex = self.Step
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: true)
                self.detailProcessResume!.cvProcessInfo!.status! = 7
                self.btnCloseTouch()
            })
        } else if self.Step == 3 {
            self.viewModel.gotoworkStatus(cvId: self.cvId, jobId: self.jobId, success: {
                
            }, failure: {error in
                self.position = UInt(self.Step)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.progressBarWithoutLastState.currentIndex = self.Step
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: true)
                self.detailProcessResume!.cvProcessInfo!.status! = 8
                self.btnCloseTouch()
            })
        } else if self.Step == 4 {
            self.viewModel.contractStatus(cvId: self.cvId, jobId: self.jobId, success: {}, failure: {error in
                self.position = UInt(self.Step)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                self.progressBarWithoutLastState.currentIndex = self.Step
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: true)
                self.detailProcessResume!.cvProcessInfo!.status! = 9
                self.btnCloseTouch()
            })
        }
    }
    @IBAction func sendReject(_ sender: Any) {
        self.viewModel.sendReject(cvId: self.cvId, jobId: self.jobId, reasonNote: self.textfieldReasonNote.text!, reasonRejectId: self.reasonRejectId, rejectStep: self.rejectStepSend, success: {sendReject in
            if sendReject.rejectStep! == self.rejectStepSend {
                self.position = UInt(self.rejectStepSend-1)
                self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
                if self.rejectStepSend == 1 {
                    NotificationCenter.default.post(name: InfoProcessResumeController.onReceiveRejectInfo, object: nil, userInfo:["reasonRejectId": StringUtils.shared.checkEmptyInt(value: sendReject.reasonRejectID), "reasonNote": StringUtils.shared.checkEmpty(value: sendReject.reasonNote),"reasonName": StringUtils.shared.checkEmpty(value: self.lblReasonReject.text)])
                } else if self.rejectStepSend == 2{
                    NotificationCenter.default.post(name: InterviewProcessController.onReceiveRejectInterview, object: nil, userInfo:["reasonRejectId": StringUtils.shared.checkEmptyInt(value: sendReject.reasonRejectID), "reasonNote": StringUtils.shared.checkEmpty(value: sendReject.reasonNote),"reasonName": StringUtils.shared.checkEmpty(value: self.lblReasonReject.text)])
                }else if self.rejectStepSend == 3{
                    NotificationCenter.default.post(name: OfferProcessController.onReceiveRejectOffer, object: nil, userInfo:["reasonRejectId": StringUtils.shared.checkEmptyInt(value: sendReject.reasonRejectID), "reasonNote": StringUtils.shared.checkEmpty(value: sendReject.reasonNote),"reasonName": StringUtils.shared.checkEmpty(value: self.lblReasonReject.text)])
                }else if self.rejectStepSend == 4{
                    NotificationCenter.default.post(name: GoToWorkProcessController.onReceiveRejectGoToWork, object: nil, userInfo:["reasonRejectId": StringUtils.shared.checkEmptyInt(value: sendReject.reasonRejectID), "reasonNote": StringUtils.shared.checkEmpty(value: sendReject.reasonNote),"reasonName": StringUtils.shared.checkEmpty(value: self.lblReasonReject.text)])
                }else if self.rejectStepSend == 5{
                    NotificationCenter.default.post(name: ContractProcessController.onReceiveRejectContract, object: nil, userInfo:["reasonRejectId": StringUtils.shared.checkEmptyInt(value: sendReject.reasonRejectID), "reasonNote": StringUtils.shared.checkEmpty(value: sendReject.reasonNote),"reasonName": StringUtils.shared.checkEmpty(value: self.lblReasonReject.text)])
                }
                self.btnCloseTouch()
            }
        }, failure: {error in
        })
    }
    func onReject(step: Int, cvId: Int, jobId: Int) {
        self.isNext = 2
        self.rejectStepSend = step
        viewModel.getListReasonReject(success: {listReasonReject in
            self.listReasonReject = listReasonReject
            self.view.addSubview(self.viewReject)
            self.lblReasonReject.text = self.listReasonReject[0].name!
            self.textfieldReasonNote.isUserInteractionEnabled = false
            self.reasonRejectId = self.listReasonReject[0].id!
            self.viewReject.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([NSLayoutConstraint(item: self.viewReject, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 25), self.viewReject.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), self.viewReject.heightAnchor.constraint(equalToConstant: 293), self.viewReject.widthAnchor.constraint(equalToConstant: 300)])
            self.viewReject.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewReject.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.visualEffectView.effect = self.effect
                self.visualEffectView.isHidden = false
                self.viewReject.alpha = 1
                self.viewReject.transform = CGAffineTransform.identity
            }
        }, failure: {error in
            
        })
    }
    
    func onNext(step: Int, cvId: Int, jobId: Int) {
        self.isNext = 1
        self.Step = step
        if step == 1 {
            self.lblInvite.text = "Bạn có chắc chắn muốn mời ứng viên này đi phỏng vấn?"
        } else if step == 2{
            self.lblInvite.text = "Bạn có chắc chắn gửi offer tới ứng viên này không?"
        } else if step == 3 {
            self.lblInvite.text = "Bạn có chắc chắn muốn cập nhật trạng thái đi làm cho ứng viên này không?"
        } else if step == 4 {
            self.lblInvite.text = "Bạn có chắc chắn muốn cập nhật trạng thái ký hợp đồng cho ứng viên này không?"
        }
        self.view.addSubview(viewNext)
        viewNext.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: viewNext, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 25),            viewNext.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            viewNext.heightAnchor.constraint(equalToConstant: 218),
            viewNext.widthAnchor.constraint(equalToConstant: 300)
            ])
        viewNext.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewNext.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.visualEffectView.isHidden = false
            self.viewNext.alpha = 1
            self.viewNext.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func noSendInviteTouch() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewReject.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewReject.alpha = 0
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.viewReject.removeFromSuperview()
        }
    }
    
    
}
