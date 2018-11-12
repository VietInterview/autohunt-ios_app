///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit

class DetailJobController: UIViewController , CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var mViewTab: UIView!
    @IBOutlet weak var btnSendCV: UIButton!
    var homeViewModel = HomeViewModel()
    var jobId: Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabSwipe = CarbonTabSwipeNavigation(items: ["Thông tin", "Thống kê", "CV đã nộp"], delegate: self)
        tabSwipe.setTabExtraWidth(16)
        tabSwipe.insert(intoRootViewController: self, andTargetView: mViewTab)
    }
    override func viewDidAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        homeViewModel.getDetailJob(jobId: self.jobId, success: {jobDetail in
            LoadingOverlay.shared.hideOverlayView()
            print(jobDetail.careerName!)
        }, failure: {error in
            LoadingOverlay.shared.hideOverlayView()
            print(error.description)
        })
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard let storyboard = storyboard else { return UIViewController() }
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "InfoController")
        } else if index == 1{
            return storyboard.instantiateViewController(withIdentifier: "StatisticalController")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "CVSendController")
        }
    }
}
