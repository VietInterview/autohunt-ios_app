///**
/**
 Created by: Hiep Nguyen Nghia on 12/20/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import FlexibleSteppedProgressBar

class ProcessResumeController: BaseViewController, CarbonTabSwipeNavigationDelegate, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var viewTemp: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewTab: UIView!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 53.0 / 255.0, green: 226.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var position:UInt = 0
    var maxIndex = -1
    var tabSwipe = CarbonTabSwipeNavigation()
    var myScrollView : UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        setupProgressBarWithoutLastState()
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
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        self.position = UInt(index)
        self.tabSwipe.setCurrentTabIndex(self.position, withAnimation: true)
        return true
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
        self.setupTabSwipe(pos: self.position)
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
            //            vc.positionTab = 0
            //            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "InterviewProcessController") as! InterviewProcessController
            //            vc.delegate = self
            //            vc.positionTab = 0
            //            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        } else if index == 2{
            let vc = storyboard.instantiateViewController(withIdentifier: "OfferProcessController") as! OfferProcessController
            //            vc.delegate = self
            //            vc.positionTab = 0
            //            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }else if index == 3{
            let vc = storyboard.instantiateViewController(withIdentifier: "GoToWorkProcessController") as! GoToWorkProcessController
            //            vc.delegate = self
            //            vc.positionTab = 0
            //            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }else{
            let vc = storyboard.instantiateViewController(withIdentifier: "ContractProcessController") as! ContractProcessController
            //            vc.delegate = self
            //            vc.positionTab = 0
            //            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }
    }
}
