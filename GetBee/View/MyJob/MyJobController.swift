///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import GoneVisible

class MyJobController: BaseViewController, CarbonTabSwipeNavigationDelegate, ChooseDelegate {
    var isShowCondition: Bool = false
    var isCarrer: Bool = false
    var isStatus: Bool = false
    var carrerId: Int = 0
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnCarrer: UIButton!
    var cityId: Int = 0
     var vc = CarrerOrCityController()
    @IBOutlet weak var mViewCondition: UIView!
    @IBOutlet weak var mViewTab: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("my_job", comment: "")
        mViewCondition.isHidden = true
        mViewCondition.gone()
        let tabSwipe = CarbonTabSwipeNavigation(items: [NSLocalizedString("job_saved_tit", comment: ""), NSLocalizedString("job_applyed_tit", comment: "")], delegate: self)
        if ScreenUtils.shared.getScreenWidth()! == 414 {
            tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/7)
        } else {
            tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/30)
        }
        debugLog(object: ScreenUtils.shared.getScreenWidth()!)
        tabSwipe.insert(intoRootViewController: self, andTargetView: self.mViewTab)
        tabSwipe.setNormalColor(UIColor.gray)
        tabSwipe.setSelectedColor(UIColor.black)
        tabSwipe.setIndicatorColor(UIColor.black)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyJobSavedController") as! MyJobSavedController
            
            return vc
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyJobAppliedController") as! MyJobAppliedController
            
            return vc
        }
    }
    @IBAction func showHideCondition(_ sender: Any) {
        if self.isShowCondition == false {
        self.isShowCondition = true
        self.mViewCondition.isHidden = false
        self.mViewCondition.visible()
    } else {
        self.isShowCondition = false
        self.mViewCondition.isHidden = true
        self.mViewCondition.gone()
        }
    }
    
    @IBAction func gotoCity(_ sender: Any) {
        self.isCarrer = false
        self.isStatus = false
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.isCity = true
        vc.title = NSLocalizedString("city", comment: "")
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoCarrer(_ sender: Any) {
        self.isCarrer = true
        self.isStatus = false
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.isCity = false
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func didChoose(mychoose: MyChoose) {
        NotificationCenter.default.post(name: MyCVAppliedController.notificationName, object: nil,userInfo: ["id": mychoose.id, "name":mychoose.name, "isCarrer": mychoose.isCarrer, "isStatus":mychoose.isStatus, "isCity":mychoose.isCity])
        if self.isCarrer {
            self.carrerId = mychoose.id
            self.btnCarrer.setTitle(mychoose.name, for: .normal)
        } else {
            self.cityId = mychoose.id
            self.btnCity.setTitle(mychoose.name, for: .normal)
        }
    }
    
}
