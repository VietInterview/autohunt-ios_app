///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import GoneVisible

class MyCVController: BaseViewController , CarbonTabSwipeNavigationDelegate, ChooseDelegate {
    var isShowCondition: Bool = false
    var isShowStatus: Bool = false
    var mPosition: Int = 0
    var homeViewModel = HomeViewModel()
    var carrerId: Int = 0
    var cityId: Int = 0
    var statusId: Int = 0
    var page: Int = 0
    var listCV = ListCV()
    var listCVSubmit = ListCVSubmit()
    var isCarrer: Bool = false
    var isCity: Bool = false
    var isStatus: Bool = false
    var positionTab = UInt()
    var tabSwipe: CarbonTabSwipeNavigation? = nil
    var vc = CarrerOrCityController()
    @IBOutlet weak var mViewCondition: UIView!
    @IBOutlet weak var mViewStatus: UIView!
    @IBOutlet weak var mTabView: UIView!
    @IBOutlet weak var btnCarrer: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("mycv", comment: "")
        mViewCondition.isHidden = true
        mViewCondition.gone()
        self.mViewStatus.isHidden = true
        self.mViewStatus.gone()
        self.tabSwipe = CarbonTabSwipeNavigation(items: [NSLocalizedString("cv_saved", comment: ""),NSLocalizedString("cv_submited", comment: "")], delegate: self)
        
        if ScreenUtils.shared.getScreenWidth()! == 414 { self.tabSwipe!.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/5)
        } else { self.tabSwipe!.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/8)
        }
        self.tabSwipe!.setNormalColor(UIColor.gray)
        self.tabSwipe!.setSelectedColor(UIColor.black)
        self.tabSwipe!.setIndicatorColor(UIColor.black)
        self.tabSwipe!.insert(intoRootViewController: self, andTargetView: self.mTabView)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.mPosition = Int(index)
        self.positionTab = index
        print("positionTab1 \(self.positionTab)")
        if index == 0 {
            self.isShowStatus = false
            self.mViewStatus.isHidden = true
            self.mViewStatus.gone()
        } else {
            if self.isShowCondition == true {
                self.isShowStatus = true
                self.mViewStatus.isHidden = false
                self.mViewStatus.visible()
            } else {
                self.isShowStatus = false
                self.mViewStatus.isHidden = true
                self.mViewStatus.gone()
            }
        }
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mPosition = Int(index)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCVSavedController") as! MyCVSavedController
            vc.isCarrer = self.isCarrer
            vc.isStatus = self.isStatus
            vc.vc = self.vc
            return vc
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCVAppliedController") as! MyCVAppliedController
            vc.isCarrer = self.isCarrer
            vc.isStatus = self.isStatus
            vc.vc = self.vc
            return vc
        }
    }
    
    @IBAction func showHideCondition(_ sender: Any) {
        if self.isShowCondition == false {
            self.isShowCondition = true
            if self.mPosition == 0 {
                self.isShowStatus = false
                self.mViewStatus.isHidden = true
                self.mViewStatus.gone()
            } else {
                self.isShowStatus = true
                self.mViewStatus.isHidden = false
                self.mViewStatus.visible()
            }
            self.mViewCondition.isHidden = false
            self.mViewCondition.visible()
        } else {
            self.isShowCondition = false
            self.isShowStatus = false
            self.mViewCondition.isHidden = true
            self.mViewCondition.gone()
            self.mViewStatus.isHidden = true
            self.mViewStatus.gone()
        }
    }
    @IBAction func chooseCarrerTouch() {
        self.isCarrer = true
        self.isStatus = false
        self.isCity = false
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.isCity = self.isCity
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseStatusTouch(_ sender: Any) {
        self.isCarrer = false
        self.isStatus = true
        self.isCity = false
        vc.title = NSLocalizedString("status", comment: "")
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.isCity = self.isCity
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func chooseCityTouch(_ sender: Any) {
        self.isCarrer = false
        self.isStatus = false
        self.isCity = true
        vc.title = NSLocalizedString("city", comment: "")
        vc.isCarrer = self.isCarrer
        vc.isStatus = self.isStatus
        vc.isCity = self.isCity
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func didChoose(mychoose: MyChoose) {
        NotificationCenter.default.post(name: MyCVAppliedController.notificationName, object: nil,userInfo: ["id": mychoose.id, "name":mychoose.name, "isCarrer": mychoose.isCarrer, "isStatus":mychoose.isStatus, "isCity":mychoose.isCity])
        if self.isCarrer {
            self.carrerId = mychoose.id
            self.btnCarrer.setTitle(mychoose.name, for: .normal)
        } else if self.isCity {
            self.cityId = mychoose.id
            self.btnCity.setTitle(mychoose.name, for: .normal)
        } else if self.isStatus {
            self.statusId = mychoose.id
            self.btnStatus.setTitle(mychoose.name, for: .normal)
        }
    }
    
}
