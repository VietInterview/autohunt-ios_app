///**
/**
Created by: Hiep Nguyen Nghia on 12/19/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import CarbonKit

class DetailResumeCustomerController: BaseViewController, CarbonTabSwipeNavigationDelegate, UpDownState {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTab: UIView!
    @IBOutlet weak var imgResume: UIImageView!
    @IBOutlet weak var btnProcessResume: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    var cvId:Int = 0
    var viewModel = HomeViewModel()
    var resumeDetailCustomer = ResumeDetailCustomer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        imgResume.layer.borderWidth = 1
        imgResume.layer.masksToBounds = false
        imgResume.layer.borderColor = UIColor.black.cgColor
        imgResume.layer.cornerRadius = imgResume.frame.height/2
        imgResume.clipsToBounds = true
        self.btnProcessResume.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        self.btnProcessResume.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        self.btnProcessResume.tintColor = UIColor.white
        self.btnProcessResume.layer.cornerRadius = 5
        self.btnProcessResume.layer.borderWidth = 0
        self.btnProcessResume.layer.borderColor = UIColor.gray.cgColor
        self.btnProcessResume.setTitle("Xử lý hồ sơ", for: .normal)
        self.btnProcessResume.setImage(UIImage(named: "process_resume.png"), for: .normal)
        self.btnProcessResume.contentHorizontalAlignment = .center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDetailResume(cvId: self.cvId)
    }
    func getDetailResume(cvId:Int){
        viewModel.getDetailResumeCustomer(cvId: cvId, success: {resumeDetailCustomer in
            self.resumeDetailCustomer = resumeDetailCustomer
            let tabSwipe = CarbonTabSwipeNavigation(items: ["THÔNG TIN", "KINH NGHIỆM", "BẰNG CẤP","NGOẠI NGỮ", "TIN HỌC", "KỸ NĂNG"], delegate: self)
            if ScreenUtils.shared.getScreenWidth()! == 414 { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/7)
            } else { tabSwipe.setTabExtraWidth(ScreenUtils.shared.getScreenWidth()!/20)
            }
            tabSwipe.carbonSegmentedControl?.backgroundColor = UIColor.white
            tabSwipe.setNormalColor(StringUtils.shared.hexStringToUIColor(hex: "#677B8D"), font: UIFont(name: "Roboto-Medium", size: 14)!)
            tabSwipe.setSelectedColor(StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"), font: UIFont(name: "Roboto-Medium", size: 14)!)
            tabSwipe.setIndicatorColor(StringUtils.shared.hexStringToUIColor(hex: "#3C84F7"))
            tabSwipe.insert(intoRootViewController: self, andTargetView: self.viewTab)
        }, failure: {error in
            
        })
    }
    func upDownState(isUp: Bool) {
        if isUp {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.showHideView(view: viewHeader, isHidden: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.showHideView(view: viewHeader, isHidden: false)
        }
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        } else if index == 2{
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }else if index == 3{
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }else if index == 4{
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }else {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailResumeCustomerController") as! InfoDetailResumeCustomerController
            vc.delegate = self
            vc.positionTab = Int(index)
            vc.resumeDetailCustomer = self.resumeDetailCustomer
            return vc
        }
    }
}
