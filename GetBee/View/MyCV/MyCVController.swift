///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import GoneVisible

class MyCVController: UIViewController , CarbonTabSwipeNavigationDelegate, ChooseDelegate {
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
        self.title = "Hồ sơ của tôi"
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        mViewCondition.isHidden = true
        mViewCondition.gone()
        self.mViewStatus.isHidden = true
        self.mViewStatus.gone()
        self.tabSwipe = CarbonTabSwipeNavigation(items: ["Hồ sơ đã lưu", "Hồ sơ đã ứng tuyển"], delegate: self)
        self.tabSwipe!.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/8)
        self.tabSwipe!.insert(intoRootViewController: self, andTargetView: self.mTabView)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
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
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = "Ngành Nghề"
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
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = "Trạng thái"
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
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = "Thành phố"
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
