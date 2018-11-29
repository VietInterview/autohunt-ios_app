///**
/**
 Created by: Hiep Nguyen Nghia on 11/16/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import AlamofireImage
import Alamofire
import GoneVisible

class DetailCVController: UIViewController, UIScrollViewDelegate, CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var mViewBtnSubmitCV: UIView!
    @IBOutlet weak var lblNotiSendCV: UILabel!
    @IBOutlet weak var lblNotiHunt: UILabel!
    @IBOutlet weak var mViewSendCVAll: UIView!
    @IBOutlet weak var mViewHuntAll: UIView!
    @IBOutlet weak var imgSendCV: UIImageView!
    @IBOutlet weak var imgHunt: UIImageView!
    @IBOutlet weak var mViewSendCV: UIView!
    @IBOutlet weak var mViewHunt: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var mPopUpSendCV: UIView!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mViewHeader: UIView!
    @IBOutlet weak var mTabView: UIView!
    var cvId: Int = 0
    var jobId: Int = 0
    var detailCV = DetailCV()
    var jobDetail = JobDetail()
    var effect:UIVisualEffect!
    @IBOutlet weak var imgAva: UIImageView!
    var homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        self.navigationController?.view.backgroundColor = .clear
       
        if let jobdetail = self.jobDetail.fee {
            lblNotiHunt.text = "Mức thưởng dự kiến mà bạn sẽ nhận được \(StringUtils.shared.currencyFormat(value: self.jobDetail.fee!)) VND"
            lblNotiSendCV.text = "Mức thưởng dự kiến mà bạn sẽ nhận được \(StringUtils.shared.currencyFormat(value: (self.jobDetail.fee!*47)/68)) VND"
            self.mViewBtnSubmitCV.isHidden = false
            self.mViewBtnSubmitCV.visible()
        } else {
            self.mViewBtnSubmitCV.isHidden = true
            self.mViewBtnSubmitCV.gone()
        }
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        homeViewModel.getDetailCV(cvId: cvId, success: {detailCV in
            self.detailCV = detailCV
            if let imgUrl = self.detailCV.pictureURL {
                Alamofire.request("https://dev.getbee.vn/\(imgUrl)").responseImage { response in
                    if let image = response.result.value {
                        self.imgAva.image = image
                    }
                }
            }
            self.lblName.text = detailCV.fullName!
            self.lblBirthday.text = DateUtils.shared.convertFormatDateFull(dateString: "\(self.detailCV.birthday!)")
            let tabSwipe = CarbonTabSwipeNavigation(items: ["Thông tin", "Kinh nghiệm", "Trình độ","Ngoại ngữ", "Tin học", "Kỹ năng"], delegate: self)
            tabSwipe.setTabExtraWidth(16)
            tabSwipe.carbonSegmentedControl?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Nunito", size: 16)!], for: .normal)
            tabSwipe.setNormalColor(UIColor.gray)
            tabSwipe.setSelectedColor(UIColor.black)
            tabSwipe.setIndicatorColor(UIColor.yellow)
            tabSwipe.insert(intoRootViewController: self, andTargetView: self.mTabView)
        }, failure: {error in
            self.showMessage(title: "Thông báo", message: error)
        })
        self.mViewHunt.isHidden = true
        self.mViewHunt.gone()
        self.mViewSendCV.isHidden = true
        self.mViewSendCV.gone()
        
        let tapGestureHuntRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageHuntTapped(tapGestureHuntRecognizer:)))
        self.imgHunt.isUserInteractionEnabled = true
        self.imgHunt.addGestureRecognizer(tapGestureHuntRecognizer)
        
        let tapGestureSendCVRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSendCVTapped(tapGestureSendCVRecognizer:)))
        self.imgSendCV.isUserInteractionEnabled = true
        self.imgSendCV.addGestureRecognizer(tapGestureSendCVRecognizer)
    }
    @objc func imageHuntTapped(tapGestureHuntRecognizer: UITapGestureRecognizer)
    {
        self.mViewHunt.isHidden = false
        self.mViewHunt.visible()
        self.mViewSendCV.isHidden = true
        self.mViewSendCV.gone()
    }
    @objc func imageSendCVTapped(tapGestureSendCVRecognizer: UITapGestureRecognizer)
    {
        self.mViewHunt.isHidden = true
        self.mViewHunt.gone()
        self.mViewSendCV.isHidden = false
        self.mViewSendCV.visible()
    }
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.mPopUpSendCV.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mPopUpSendCV.alpha = 0
            
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.mPopUpSendCV.removeFromSuperview()
        }
    }
    func animateIn() {
        self.view.addSubview(mPopUpSendCV)
        mPopUpSendCV.center = self.view.center
        
        mPopUpSendCV.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mPopUpSendCV.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            
            self.visualEffectView.isHidden = false
            self.mPopUpSendCV.alpha = 1
            self.mPopUpSendCV.transform = CGAffineTransform.identity
        }
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        guard var storyboard = storyboard else { return UIViewController() }
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "InfoDetailCVController") as! InfoDetailCVController
            vc.detailCV = self.detailCV
            return vc
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "ExpDetailCVController") as! ExpDetailCVController
            vc.detailCV = self.detailCV
            return vc
        } else if index == 2{
            let vc = storyboard.instantiateViewController(withIdentifier: "LevelDetailCVController") as! LevelDetailCVController
            vc.detailCV = self.detailCV
            return vc
        }else if index == 3{
            let vc = storyboard.instantiateViewController(withIdentifier: "LanDetailCVController") as! LanDetailCVController
            vc.detailCV = self.detailCV
            return vc
        }else if index == 4{
            let vc = storyboard.instantiateViewController(withIdentifier: "ComDetailCVController") as! ComDetailCVController
            vc.detailCV = self.detailCV
            return vc
        }else {
            let vc = storyboard.instantiateViewController(withIdentifier: "SkillDetailCVController") as! SkillDetailCVController
            vc.detailCV = self.detailCV
            return vc
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        let rectShape = CAShapeLayer()
        rectShape.bounds = mViewHeader.frame
        rectShape.position = mViewHeader.center
        rectShape.path = UIBezierPath(roundedRect: mViewHeader.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        mViewHeader.layer.backgroundColor = UIColor.white.cgColor
        mViewHeader.layer.mask = rectShape
    }
    @IBAction func applyCVTouch(_ sender: Any) {
        self.animateIn()
    }
    
    @IBAction func huntTouch(_ sender: Any) {
        self.homeViewModel.submitCV(cvId: self.detailCV.id!, jobId: self.jobDetail.id!, type: 1, success: {submitCV in
            if submitCV.type! == 1 {
                self.animateOut()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: DetailJobController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }, failure: {error in
            debugLog(object: error)
            self.showMessage(title: "Thông báo", message: error == "Email or phone is already in submit job!" ? "Ứng viên này đã được chính bạn hoặc CTV viên khác sử dụng và gửi đi. Bạn vui lòng chọn CV khác":"", handler: { (action: UIAlertAction!) in
                self.animateOut()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ChooseCVSubmitController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            })
        })
    }
    
    @IBAction func sendCVTouch(_ sender: Any) {
        self.homeViewModel.submitCV(cvId: self.detailCV.id!, jobId: self.jobDetail.id!, type: 0, success: {submitCV in
            if submitCV.type! == 0 {
                self.showMessage(title: "Thông báo", message: "Hồ sơ của bạn đã được gửi tới NTD. Vui lòng kiểm tra trạng thái hồ sơ đã gửi trong mục Hồ sơ đã ứng tuyển", handler: { (action: UIAlertAction!) in
                    self.animateOut()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: DetailJobController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                })
            }
        }, failure: {error in
            debugLog(object: error)
            self.showMessage(title: "Thông báo", message: "Hồ sơ của bạn đã được gửi tới NTD. Vui lòng kiểm tra trạng thái hồ sơ đã gửi trong mục Hồ sơ đã ứng tuyển", handler: { (action: UIAlertAction!) in
                self.animateOut()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ChooseCVSubmitController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            })
        })
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if targetContentOffset.pointee.y < self.mScrollView.contentOffset.y {
            // it's going up
            print("up")
        } else {
            // it's going down
            print("down")
        }
        
    }
}
