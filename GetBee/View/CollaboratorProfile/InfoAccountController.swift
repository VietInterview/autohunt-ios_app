///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ACFloatingTextfield_Swift
import Toaster
import Alamofire

class InfoAccountController: BaseViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource, ChooseMultiDelegate,ChooseDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var viewChooseDateTime: UIView!
    @IBOutlet weak var tableView: UITableView!
    var desideratedCareer = [CountryMyProfile]()
    var mArrCountry = [CountryMyProfile]()
    var mArrCity = [CityMyProfile]()
    var vc = CarrerOrCityController()
    var userProfile:GetMyProfile?
    var imagePicker = UIImagePickerController()
    var viewModel = HomeViewModel()
    var arrTitle = ["","Mã nhân viên","Số điện thoại","Ngày sinh","Địa chỉ","Quốc gia","Tỉnh/Thành","Tên công ty hiện tại","Ngành nghề muốn hợp tác","Ngày ký hợp đồng","Đổi mật khẩu"]
    let numberOfCells : NSInteger = 11
    var arrContent = [String]()
    var isEditName:Bool = false
    var isEditPhone:Bool = false
    var isEditBirthday:Bool = false
    var isEditAddress:Bool = false
    var isEditCompany:Bool = false
    var isEditContractDate:Bool = false
    var isEditCountry:Bool = false
    var isEditCity:Bool = false
    var datePicker : UIDatePicker!
    var toolBar:UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("profile", comment: "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        viewModel.loadUserProfile(success: { userProfile in
            self.userProfile = userProfile
            self.arrContent.append(userProfile.fullNameColl != nil ? userProfile.fullNameColl! : "")
            self.arrContent.append(userProfile.emailColl != nil ? userProfile.emailColl! : "")
            self.arrContent.append(userProfile.code != nil ? "\(userProfile.code!)" : "")
            self.arrContent.append(userProfile.phoneColl != nil ? "\(userProfile.phoneColl!)" : "")
            self.arrContent.append(userProfile.birthday != nil ? DateUtils.shared.convertFormatDateFull(dateString: "\(userProfile.birthday!)") : "")
            self.arrContent.append(userProfile.addressColl != nil ? "\(userProfile.addressColl!)" : "")
            self.arrContent.append(userProfile.countries != nil ? userProfile.countries!.count > 0 ? userProfile.countries![0].name! : "" : "")
            self.arrContent.append(userProfile.cities != nil ? userProfile.cities!.count > 0 ? userProfile.cities![0].name! : "" : "")
            self.arrContent.append(userProfile.companyName != nil ? userProfile.companyName! : "")
            var appenString: String = ""
            if let arrCarrer = userProfile.desideratedCareer {
                self.desideratedCareer = arrCarrer
                for i in 0...arrCarrer.count - 1 {
                    appenString.append(i == arrCarrer.count - 1 ? arrCarrer[i].name! : "\(arrCarrer[i].name!), ")
                }
            }
            self.arrContent.append(appenString)
            self.arrContent.append(userProfile.contractDate != nil ? DateUtils.shared.convertFormatDateFull(dateString: "\(userProfile.contractDate!)") : "")
            self.arrContent.append("1")
            self.tableView.estimatedRowHeight = 76
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }, failure: { error in
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: error)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    var cellHeader:HeaderCell?
    var cellEdit = [IsEditCell]()
    var cellEditGo = [GoToCell]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! HeaderCell
            cell.textViewName.text = self.arrContent[indexPath.row]
            cell.textViewName.autocapitalizationType = .words
            cell.textViewName.isEditable = false
            cell.textViewName.isScrollEnabled = false
            cell.lblEmail.text = self.arrContent[indexPath.row+1]
            cell.imgAva.showImage(imgUrl:StringUtils.shared.checkEmpty(value: self.userProfile!.imageURL), imageNullName: "ava_null")
            cell.imgAva.circleImage()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe(sender: )))
            cell.imgAva.isUserInteractionEnabled = true
            cell.imgAva.addGestureRecognizer(tap)
            
            let tapEditName = UITapGestureRecognizer(target: self, action: #selector(self.tappedEditName(sender: )))
            cell.imgEditName.isUserInteractionEnabled = true
            cell.imgEditName.addGestureRecognizer(tapEditName)
            cell.imgEditName.tag = indexPath.row
            cell.selectionStyle = .none
            self.cellHeader = cell
            return cell
        } else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iseditcell") as! IsEditCell
            cell.imgEdit.image = Image(named: indexPath.row == 8 ? "arrow_right" : "change_pass")
            self.showHideView(view: cell.imgEdit, isHidden: indexPath.row == 1 ? true : false)
            //            self.showHideView(view: cell, isHidden: self.arrContent[indexPath.row+1] == "" ? true : false)
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.textViewContent.text = self.arrContent[indexPath.row+1]
            cell.textViewContent.autocapitalizationType = .words
            cell.textViewContent.isScrollEnabled = false
            let tapEdit = UITapGestureRecognizer(target: self, action: #selector(self.tappedEdit(sender: )))
            cell.imgEdit.isUserInteractionEnabled = true
            cell.imgEdit.addGestureRecognizer(tapEdit)
            cell.imgEdit.tag = indexPath.row
            if indexPath.row != 1 {
                if self.cellEdit.count < 6 {
                    self.cellEdit.append(cell)
                } else {
                    switch indexPath.row{
                    case 2:
                        cell.imgEdit.image = Image(named: self.isEditPhone ? "tick_blue" : "change_pass")
                        self.cellEdit[0] = cell
                        break
                    case 3:
                        cell.imgEdit.image = Image(named: self.isEditBirthday ? "tick_blue" : "change_pass")
                        self.cellEdit[1] = cell
                        break
                    case 4:
                        cell.imgEdit.image = Image(named: self.isEditAddress ? "tick_blue" : "change_pass")
                        self.cellEdit[2] = cell
                        break
                    case 7:
                        cell.imgEdit.image = Image(named: self.isEditCompany ? "tick_blue" : "change_pass")
                        self.cellEdit[3] = cell
                        break
                    case 8:
                        self.cellEdit[4] = cell
                        break
                    case 9:
                        cell.imgEdit.image = Image(named: self.isEditContractDate ? "tick_blue" : "change_pass")
                        self.cellEdit[5] = cell
                        break
                    default:
                        break
                    }
                }
            }
            if indexPath.row == 8 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedGoCarrer(sender: )))
                cell.textViewContent.isUserInteractionEnabled = true
                cell.textViewContent.addGestureRecognizer(tap)
                cell.textViewContent.isEditable = false
                let fixedWidth = cell.textViewContent.frame.size.width
                let newSize = cell.textViewContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                cell.textViewContent.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            }else {
                cell.textViewContent.isEditable = false
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gotocell") as! GoToCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrContent[indexPath.row+1]
            self.showHideView(view: cell.lblContent, isHidden: indexPath.row == 10 ? true : false)
            cell.selectionStyle = .none
            self.cellEditGo.append(cell)
            return cell
        }
    }
    @objc func tappedEditName(sender: UITapGestureRecognizer) {
        if self.isEditName {
            self.isEditName = false
            self.cellHeader!.textViewName.isEditable = false
            self.saveProfile()
            self.cellHeader!.textViewName.resignFirstResponder()
            self.cellHeader!.imgEditName.image = Image(named:"change_pass")
        } else {
            self.isEditName = true
            self.cellHeader!.textViewName.isEditable = true
            self.cellHeader!.textViewName.becomeFirstResponder()
            self.cellHeader!.imgEditName.image = Image(named:"tick_blue")
        }
    }
    @objc func tappedEdit(sender: UITapGestureRecognizer) {
        if sender.view!.tag == 2 {
            if self.isEditPhone{
                self.isEditPhone = false
                self.cellEdit[0].textViewContent.isEditable = false
                self.saveProfile()
                self.cellEdit[0].textViewContent.resignFirstResponder()
                self.cellEdit[0].imgEdit.image = UIImage(named: "change_pass")
            } else {
                self.isEditPhone = true
                self.cellEdit[0].textViewContent.isEditable = true
                self.cellEdit[0].textViewContent.keyboardType = UIKeyboardType.numberPad
                self.cellEdit[0].textViewContent.becomeFirstResponder()
                self.cellEdit[0].imgEdit.image = UIImage(named: "tick_blue")
            }
        } else if sender.view!.tag == 3 {
            if self.isEditBirthday {
                self.isEditBirthday = false
                self.saveProfile()
                self.cellEdit[1].imgEdit.image = UIImage(named: "change_pass")
            } else {
                self.isEditBirthday = true
                self.showViewChooseDate()
                self.cellEdit[1].imgEdit.image = UIImage(named: "tick_blue")
            }
        }else if sender.view!.tag == 4 {
            if self.isEditAddress {
                self.isEditAddress = false
                self.cellEdit[2].textViewContent.isEditable = false
                self.saveProfile()
                self.cellEdit[2].textViewContent.resignFirstResponder()
                self.cellEdit[2].imgEdit.image = UIImage(named: "change_pass")
            } else {
                self.isEditAddress = true
                self.cellEdit[2].textViewContent.isEditable = true
                self.cellEdit[2].textViewContent.becomeFirstResponder()
                self.cellEdit[2].imgEdit.image = UIImage(named: "tick_blue")
            }
        }else if sender.view!.tag == 7 {
            if self.isEditCompany {
                self.isEditCompany = false
                self.cellEdit[3].textViewContent.isEditable = false
                self.saveProfile()
                self.cellEdit[3].textViewContent.resignFirstResponder()
                self.cellEdit[3].imgEdit.image = UIImage(named: "change_pass")
            } else {
                self.isEditCompany = true
                self.cellEdit[3].textViewContent.isEditable = true
                self.cellEdit[3].textViewContent.becomeFirstResponder()
                self.cellEdit[3].imgEdit.image = UIImage(named: "tick_blue")
            }
        }else if sender.view!.tag == 9 {
            if self.isEditContractDate {
                self.isEditContractDate = false
                self.saveProfile()
                self.cellEdit[5].imgEdit.image = UIImage(named: "change_pass")
            } else {
                self.isEditContractDate = true
                self.showViewChooseDate()
                self.cellEdit[5].imgEdit.image = UIImage(named: "tick_blue")
            }
        }
    }
    func showViewChooseDate(){
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
    var somedateString:String = ""
    var birthday:Int = 0
    var contractDate:Int = 0
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en-EN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        somedateString = dateFormatter.string(from: self.datePicker.date)
        if self.isEditBirthday {
            self.cellEdit[1].textViewContent.text = somedateString
            dateFormatter.dateFormat = "yyyyMMdd"
            birthday = Int(dateFormatter.string(from: self.datePicker.date))!
        } else if self.isEditContractDate {
            self.cellEdit[5].textViewContent.text = somedateString
            dateFormatter.dateFormat = "yyyyMMdd"
            contractDate = Int(dateFormatter.string(from: self.datePicker.date))!
        }
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    
    @objc func cancelClick() {
        datePicker.isHidden = true
        viewChooseDateTime.isHidden = true
        self.toolBar!.isHidden = true
    }
    @objc func tappedMe(sender: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self){ image in
            UIApplication.showNetworkActivity()
            if let cellHeader = self.cellHeader {
                Alamofire.upload(multipartFormData: { multipartFormData in
                    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                        multipartFormData.append(imageData, withName: "file", fileName: "\(Int64(NSDate().timeIntervalSince1970 * 1000)).png", mimeType: "image/png")
                    }
                }, to: "\(App.baseUrl)/svccollaborator/api/saveProfileAvatar", method: .post, headers: ["Authorization": "Bearer \(SessionManager.currentSession!.accessToken!)"],
                   encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { [weak self] response in
                            guard self != nil else {
                                return
                            }
                            UIApplication.hideNetworkActivity()
                            if response.response!.statusCode == 200 {
                                cellHeader.imgAva.image = image
                            } else {
                                self?.showMessage(title: "Thông báo", message: "Upload không thành công")
                            }
                        }
                    case .failure(let encodingError):
                        UIApplication.hideNetworkActivity()
                        self.showMessage(title: "Thông báo", message: "Không kết nối được đến máy chủ, vui lòng thử lại sau.")
                        debugLog(object: encodingError)
                    }
                })
            }
        }
    }
    @objc func tappedGoCarrer(sender: UITapGestureRecognizer) {
        vc.isCarrer = true
        vc.isCountry = false
        vc.isCity = false
        vc.isStatus = false
        vc.isMultiChoice = true
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8 {
            vc.isCarrer = true
            vc.isCountry = false
            vc.isCity = false
            vc.isStatus = false
            vc.isMultiChoice = true
            vc.title = NSLocalizedString("carrer", comment: "")
            vc.delegateMulti = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            self.isEditCountry = true
            self.isEditCity = false
            vc.isCarrer = false
            vc.isCountry = true
            vc.isCity = false
            vc.isStatus = false
            vc.isMultiChoice = false
            vc.title = "Lựa chọn quốc gia"
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            self.isEditCountry = false
            self.isEditCity = true
            vc.isCarrer = false
            vc.isCountry = false
            vc.isCity = true
            vc.isStatus = false
            vc.isMultiChoice = false
            vc.title = "Lựa chọn tỉnh thành"
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
            vc.title = NSLocalizedString("change_pass_tit", comment: "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrContent.count-1)
    }
    func saveProfile(){
        view.endEditing(true)
        if self.mychooseMulti.count > 0 {
            self.desideratedCareer.removeAll()
            for i in 0...self.mychooseMulti.count - 1 {
                self.desideratedCareer.append(CountryMyProfile(id: mychooseMulti[i].id,name: mychooseMulti[i].name))
            }
        }
        if self.myChoose != nil {
            if self.isEditCity {
                if self.mArrCity.count == 0 {
                    debugLog(object: myChoose!.countryID)
                    self.mArrCity.append(CityMyProfile(countryID: myChoose!.countryID, enName: nil, id: myChoose!.id, name: myChoose!.name))
                } else {
                    debugLog(object: myChoose!.countryID)
                    self.mArrCity[0] = CityMyProfile(countryID: myChoose!.countryID, enName: nil, id: myChoose!.id, name: myChoose!.name)
                }
                if self.userProfile!.countries != nil {
                    if self.mArrCountry.count == 0 {
                        self.mArrCountry.append(CountryMyProfile(id: self.userProfile!.countries![0].id!, name: self.userProfile!.countries![0].name!))
                    } else {
                        self.mArrCountry[0] = CountryMyProfile(id: self.userProfile!.countries![0].id!, name: self.userProfile!.countries![0].name!)
                    }
                }
            } else if self.isEditCountry {
                if self.mArrCountry.count == 0 {
                    self.mArrCountry.append(CountryMyProfile(id: myChoose!.id, name: myChoose!.name))
                } else {
                    self.mArrCountry[0] = CountryMyProfile(id: myChoose!.id, name: myChoose!.name)
                }
                if self.userProfile!.cities != nil {
                    if self.mArrCity.count == 0 {
                        self.mArrCity.append(CityMyProfile(countryID: self.userProfile!.cities![0].countryID!, enName: nil, id:self.userProfile!.cities![0].id!, name: self.userProfile!.cities![0].name!))
                    } else {
                        self.mArrCity[0] = CityMyProfile(countryID: self.userProfile!.cities![0].countryID!, enName: nil, id:self.userProfile!.cities![0].id!, name: self.userProfile!.cities![0].name!)
                    }
                }
            }
        } else {
            if self.userProfile!.cities != nil {
                if self.mArrCity.count == 0 {
                    self.mArrCity.append(CityMyProfile(countryID: self.userProfile!.cities![0].countryID!, enName: nil, id:self.userProfile!.cities![0].id!, name: self.userProfile!.cities![0].name!))
                } else {
                    self.mArrCity[0] = CityMyProfile(countryID: self.userProfile!.cities![0].countryID!, enName: nil, id:self.userProfile!.cities![0].id!, name: self.userProfile!.cities![0].name!)
                }
            }
            if self.userProfile!.countries != nil {
                if self.mArrCountry.count == 0 {
                    self.mArrCountry.append(CountryMyProfile(id: self.userProfile!.countries![0].id!, name: self.userProfile!.countries![0].name!))
                } else {
                    self.mArrCountry[0] = CountryMyProfile(id: self.userProfile!.countries![0].id!, name: self.userProfile!.countries![0].name!)
                }
            }
        }
        
        viewModel.saveMyProfile(fullName: self.cellHeader!.textViewName.text!, phone: self.cellEdit[0].textViewContent.text!, address: self.cellEdit[2].textViewContent.text!, carrer: "", arrCarrerHunt: self.desideratedCareer,arrCity: mArrCity,arrCountry: self.mArrCountry,companyName: self.cellEdit.count > 4 ? self.cellEdit[3].textViewContent.text! : StringUtils.shared.checkEmpty(value: self.userProfile?.companyName) ,birthday: self.birthday != 0 ? self.birthday : StringUtils.shared.checkEmptyInt(value: self.userProfile?.birthday) ,contractDate: self.contractDate != 0 ? self.contractDate : StringUtils.shared.checkEmptyInt(value: self.userProfile?.contractDate), success: {user in
            let toast = Toast(text: NSLocalizedString("update_profile_success", comment: ""))
            toast.show()
        }, failure: {error in
            let toast = Toast(text: NSLocalizedString("update_profile_fail", comment: ""))
            toast.show()
        })
    }
    var myChoose:MyChoose?
    func didChoose(mychoose: MyChoose) {
        self.myChoose = mychoose
        if self.isEditCity {
            self.cellEditGo[1].lblContent.text = mychoose.name
        } else if self.isEditCountry {
            self.cellEditGo[0].lblContent.text = mychoose.name
        }
        self.saveProfile()
    }
    var mychooseMulti = [MyChoose]()
    func didChooseMulti(mychooseMulti: [MyChoose]) {
        self.mychooseMulti = mychooseMulti
        var appenString: String = ""
        for i in 0...mychooseMulti.count - 1 {
            if i == mychooseMulti.count - 1{
                appenString.append(mychooseMulti[i].name)
            } else {
                appenString.append("\(mychooseMulti[i].name), ")
            }
        }
        self.cellEdit[4].textViewContent.text = appenString
        self.arrContent[9] = appenString
        self.tableView.reloadData()
        self.saveProfile()
    }
    
}
