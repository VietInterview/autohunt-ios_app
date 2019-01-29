///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ACFloatingTextfield_Swift
import Toaster
import Alamofire

class InfoAccountController: BaseViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource, ChooseMultiDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var tableView: UITableView!
    
    var desideratedCareer = [CountryMyProfile]()
    var vc = CarrerOrCityController()
    var userProfile:GetMyProfile?
    var imagePicker = UIImagePickerController()
    var viewModel = HomeViewModel()
    var arrTitle = ["","Mã nhân viên","Số điện thoại","Ngày sinh","Địa chỉ","Quốc gia","Tỉnh/Thành","Tên công ty hiện tại","Ngành nghề muốn hợp tác","Ngày ký hợp đồng","Đổi mật khẩu"]
    let numberOfCells : NSInteger = 11
    var arrContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("profile", comment: "")
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        gestureSwift2AndHigher.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        viewModel.loadUserProfile(success: { userProfile in
            self.userProfile = userProfile
            if let fullName = userProfile.fullNameColl {
                self.arrContent.append(fullName)
            } else {
                self.arrContent.append("")
            }
            if let email = userProfile.emailColl {
                self.arrContent.append(email)
            } else {
                self.arrContent.append("")
            }
            if let code = userProfile.code {
                self.arrContent.append("\(code)")
            } else {
                self.arrContent.append("")
            }
            if let phone = userProfile.phoneColl {
                self.arrContent.append("\(phone)")
            } else {
                self.arrContent.append("")
            }
            if let birthday = userProfile.birthday{
            self.arrContent.append(DateUtils.shared.convertFormatDateFull(dateString: "\(birthday)"))
            }
            if let address = userProfile.addressColl {
                self.arrContent.append("\(address)")
            } else {
                self.arrContent.append("")
            }
            if let countries = userProfile.countries {
                if countries.count > 0 {
                    self.arrContent.append(countries[0].name!)
                } else {
                    self.arrContent.append("")
                }
            } else {
                self.arrContent.append("")
            }
            if let cities = userProfile.cities {
                if cities.count > 0 {
                    self.arrContent.append(cities[0].name!)
                } else {
                    self.arrContent.append("")
                }
            } else {
                self.arrContent.append("")
            }
            if let company = userProfile.companyName {
                self.arrContent.append(company)
            } else {
                self.arrContent.append("")
            }
            var appenString: String = ""
            if let arrCarrer = userProfile.desideratedCareer {
                self.desideratedCareer = arrCarrer
                for i in 0...arrCarrer.count - 1 {
                    if i == arrCarrer.count - 1{
                        appenString.append(arrCarrer[i].name!)
                    } else {
                        appenString.append("\(arrCarrer[i].name!), ")
                    }
                }
                self.arrContent.append(appenString)
            } else {
                self.arrContent.append("")
            }
            if let contractDate = userProfile.contractDate {
                self.arrContent.append(DateUtils.shared.convertFormatDateFull(dateString: "\(contractDate)"))
            }
            self.arrContent.append("1")
            self.tableView.estimatedRowHeight = 76
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }, failure: { error in
            print("User Profile Error: " + error)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrContent[indexPath.row+1] == "" {
            return 0
        }else{
            return UITableViewAutomaticDimension
        }
    }
    var cellHeader:HeaderCell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! HeaderCell
            cell.lblName.text = self.arrContent[indexPath.row]
            cell.lblEmail.text = self.arrContent[indexPath.row+1]
            cell.imgAva.showImage(imgUrl:StringUtils.shared.checkEmpty(value: self.userProfile!.imageURL), imageNullName: "ava_null")
            cell.imgAva.circleImage()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe(sender: )))
            cell.imgAva.isUserInteractionEnabled = true
            cell.imgAva.addGestureRecognizer(tap)
            self.cellHeader = cell
            return cell
        } else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iseditcell") as! IsEditCell
            if indexPath.row == 8 {
                cell.imgEdit.image = Image(named: "arrow_right")
            } else {
                cell.imgEdit.image = Image(named: "change_pass")
            }
            if indexPath.row == 1 {
                cell.imgEdit.isHidden = true
            } else {
                cell.imgEdit.isHidden = false
            }
            if self.arrContent[indexPath.row+1] == "" {
                cell.isHidden = true
                cell.gone()
            } else {
                cell.isHidden = false
                cell.visible()
                cell.lblTitle.text = self.arrTitle[indexPath.row]
                cell.lblContent.text = self.arrContent[indexPath.row+1]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gotocell") as! GoToCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrContent[indexPath.row+1]
            if indexPath.row == 10 {
                cell.lblContent.isHidden = true
            } else {
                cell.lblContent.isHidden = false
            }
            return cell
        }
    }
    @objc func tappedMe(sender: UITapGestureRecognizer) {
        ImagePickerManager().pickImage(self){ image in
            UIApplication.showNetworkActivity()
            if let cellHeader = self.cellHeader {
                Alamofire.upload(multipartFormData: { multipartFormData in
                    if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                        multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
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
                                    debugLog(object: response)
                                    if response.response!.statusCode == 200 {
                                        cellHeader.imgAva.contentMode = .scaleAspectFill;
                                        cellHeader.imgAva.image = image
                                    } else {
                                        self?.showMessage(title: "Thông báo", message: "Upload không thành công")
                                    }
                                }
                            case .failure(let encodingError):
                                UIApplication.hideNetworkActivity()
                                debugLog(object: encodingError)
                            }
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrContent.count-1)
    }
    @IBAction func gotoCarrerTouch(_ sender: Any) {
        vc.isCarrer = true
        vc.isStatus = false
        vc.isCity = false
        vc.isCity = false
        vc.isMultiChoice = true
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        vc.isCarrer = true
        vc.isStatus = false
        vc.isCity = false
        vc.isCity = false
        vc.isMultiChoice = true
        vc.title = NSLocalizedString("carrer", comment: "")
        vc.delegateMulti = self
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changePassTouchup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
        vc.title = NSLocalizedString("change_pass_tit", comment: "")
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func saveProfileTouch(_ sender: Any) {
        view.endEditing(true)
        if self.mychooseMulti.count > 0 {
            self.desideratedCareer.removeAll()
            for i in 0...self.mychooseMulti.count - 1 {
                self.desideratedCareer.append(CountryMyProfile(id: mychooseMulti[i].id,name: mychooseMulti[i].name))
            }
        }
        //        viewModel.saveMyProfile(fullName: self.textfieldFullname.text!, phone: self.textfieldPhone.text!, address: self.textFieldAdd.text!, carrer: self.textFieldCarrer.text!, arrCaerrerhunt: self.desideratedCareer, success: {user in
        //            let toast = Toast(text: NSLocalizedString("update_profile_success", comment: ""))
        //            toast.show()
        //        }, failure: {error in
        //            let toast = Toast(text: NSLocalizedString("update_profile_fail", comment: ""))
        //            toast.show()
        //        })
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
    }
    
}
extension UILabel {
    
    func addImageWith(name: String, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
