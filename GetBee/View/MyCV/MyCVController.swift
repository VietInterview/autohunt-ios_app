///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import CarbonKit
import GoneVisible

class MyCVController: BaseViewController , CarbonTabSwipeNavigationDelegate, ChooseDelegate {
    @IBOutlet weak var mViewCondition: UIView!
    @IBOutlet weak var mViewStatus: UIView!
    @IBOutlet weak var mTabView: UIView!
    @IBOutlet weak var btnCarrer: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgAttachFile: UIImageView!
    @IBOutlet weak var viewChooseDateTime: UIView!
    @IBOutlet weak var textFieldSearch: DesignableUITextField!
    @IBOutlet weak var chooseCalendar: UIImageView!
    
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
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    var statusName:String?
    var statusNameAttached:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hồ sơ đã ứng tuyển"
        self.showHideView(view: self.imgAttachFile, isHidden: true)
        mViewCondition.isHidden = true
        mViewCondition.gone()
        self.mViewStatus.isHidden = true
        self.mViewStatus.gone()
        self.tabSwipe = CarbonTabSwipeNavigation(items: ["Danh sách hồ sơ gốc","Hồ sơ đã lưu","Danh sách file attached"], delegate: self)
        
        if ScreenUtils.getScreenWidth()! == 414 {
            self.tabSwipe!.setTabExtraWidth(ScreenUtils.getScreenWidth()!/10)
        } else {
            self.tabSwipe!.setTabExtraWidth(ScreenUtils.getScreenWidth()!/30)
        }
        self.tabSwipe!.setNormalColor(UIColor.gray)
        self.tabSwipe!.setSelectedColor(UIColor.black)
        self.tabSwipe!.setIndicatorColor(UIColor.black)
        self.tabSwipe!.insert(intoRootViewController: self, andTargetView: self.mTabView)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.imgAttachFile.isUserInteractionEnabled = true
        self.imgAttachFile.addGestureRecognizer(gestureSwift2AndHigher2)
        
        self.textFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gestureSwift2AndHigher3 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction3))
        self.chooseCalendar.isUserInteractionEnabled = true
        self.chooseCalendar.addGestureRecognizer(gestureSwift2AndHigher3)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.page = 0
        NotificationCenter.default.post(name: MyCVAttachedController.notificationName, object: nil,userInfo: ["id": self.isCarrer ? self.carrerId : self.isStatus ? self.statusId : self.cityId, "name": self.textFieldSearch.text!, "fromDate": somedateString, "toDate": somedateString2, "isCarrer": self.isCarrer, "isStatus": self.isStatus, "isCity": self.isCity])
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        self.pushViewController(controller: AttachFileController.init().setArgument())
    }
    @objc func someAction3(sender:UITapGestureRecognizer){
        self.showChooseDateTime()
        self.somedateString = ""
        self.somedateString2 = ""
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
            self.btnStatus.setTitle(self.statusName != nil ? self.statusName : "Mặc định", for: .normal)
            self.showHideView(view: self.imgAttachFile, isHidden: true)
            self.isShowStatus = false
            self.mViewStatus.isHidden = true
            self.mViewStatus.gone()
        } else if index == 1{
            self.btnStatus.setTitle(self.statusName != nil ? self.statusName : "Mặc định", for: .normal)
            self.showHideView(view: self.imgAttachFile, isHidden: true)
            if self.isShowCondition == true {
                self.isShowStatus = true
                self.mViewStatus.isHidden = false
                self.mViewStatus.visible()
            } else {
                self.isShowStatus = false
                self.mViewStatus.isHidden = true
                self.mViewStatus.gone()
            }
        } else {
            self.btnStatus.setTitle(self.statusNameAttached != nil ? self.statusNameAttached : "Tất cả hồ sơ", for: .normal)
            if self.isShowCondition == true {
                self.isShowStatus = true
                self.mViewStatus.isHidden = false
                self.mViewStatus.visible()
                self.showHideView(view: self.imgAttachFile, isHidden: true)
            } else {
                self.isShowStatus = false
                self.mViewStatus.isHidden = true
                self.mViewStatus.gone()
                self.showHideView(view: self.imgAttachFile, isHidden: false)
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
        } else if index == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCVAppliedController") as! MyCVAppliedController
            vc.isCarrer = self.isCarrer
            vc.isStatus = self.isStatus
            vc.vc = self.vc
            return vc
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "MyCVAttachedController") as! MyCVAttachedController
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
            self.showHideView(view: self.imgAttachFile, isHidden: true)
        } else {
            self.isShowCondition = false
            self.isShowStatus = false
            self.mViewCondition.isHidden = true
            self.mViewCondition.gone()
            self.mViewStatus.isHidden = true
            self.mViewStatus.gone()
            self.showHideView(view: self.imgAttachFile, isHidden: self.mPosition == 2 ? false : true)
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
        vc.isListAttach = self.positionTab == 2 ? true : false
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func chooseCityTouch(_ sender: Any) {
        view.endEditing(true)
        self.showChooseDateTime()
        self.somedateString = ""
        self.somedateString2 = ""
    }
    var somedateString:String = ""
    var somedateString2:String = ""
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en-EN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if self.somedateString == "" {
            somedateString = dateFormatter.string(from: self.datePicker.date)
            self.btnCity.setTitle("\(somedateString) - dd/MM/yyyy", for: .normal)
            datePicker.isHidden = true
            viewChooseDateTime.isHidden = true
            self.toolBar!.isHidden = true
            self.showChooseDateTime()
        } else {
            somedateString2 = dateFormatter.string(from: self.datePicker.date)
            self.btnCity.setTitle("\(somedateString) - \(somedateString2)", for: .normal)
            datePicker.isHidden = true
            viewChooseDateTime.isHidden = true
            self.toolBar!.isHidden = true
            
            NotificationCenter.default.post(name: MyCVAttachedController.notificationName, object: nil,userInfo: ["id":  self.isCarrer ? self.carrerId : self.isStatus ? self.statusId : self.cityId, "name": self.textFieldSearch.text!, "fromDate": somedateString, "toDate": somedateString2, "isCarrer": false, "isStatus": false, "isCity":true])
        }
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    func showChooseDateTime(){
        view.endEditing(true)
        viewChooseDateTime.isHidden = false
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 200))
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.locale! = Locale(identifier: "vi-VI")
        self.datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
        viewChooseDateTime.addSubview(self.datePicker)
        toolBar = UIToolbar()
        toolBar!.barStyle = .default
        toolBar!.isTranslucent = true
        toolBar!.tintColor = UIColor.black
        toolBar!.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateEditInterviewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateEditInterviewController.cancelClick))
        toolBar!.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar!.items![0].setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        toolBar!.items![2].setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        toolBar!.isUserInteractionEnabled = true
        self.viewChooseDateTime.addSubview(toolBar!)
        toolBar!.isHidden = false
    }
    func didChoose(mychoose: MyChoose) {
        if self.positionTab == 1 {
            NotificationCenter.default.post(name: MyCVAppliedController.notificationName, object: nil,userInfo: ["id": mychoose.id, "name":mychoose.name, "isCarrer": mychoose.isCarrer, "isStatus":mychoose.isStatus, "isCity":mychoose.isCity])
        } else if self.positionTab == 2 {
            NotificationCenter.default.post(name: MyCVAttachedController.notificationName, object: nil,userInfo: ["id": mychoose.id, "name": self.textFieldSearch.text!, "fromDate": somedateString, "toDate": somedateString2, "isCarrer": mychoose.isCarrer, "isStatus": mychoose.isStatus, "isCity":mychoose.isCity])
        }
        if self.isCarrer {
            self.carrerId = mychoose.id
            self.btnCarrer.setTitle(mychoose.name, for: .normal)
        } else if self.isCity {
            self.cityId = mychoose.id
            self.btnCity.setTitle(mychoose.name, for: .normal)
        } else if self.isStatus {
            self.statusId = mychoose.id
            if self.positionTab == 1 {
                self.statusName = mychoose.name
            } else if self.positionTab == 2 {
                self.statusNameAttached = mychoose.name
            }
            self.btnStatus.setTitle(mychoose.name, for: .normal)
        }
    }
    
}
