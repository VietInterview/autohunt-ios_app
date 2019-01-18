///**
/**
 Created by: Hiep Nguyen Nghia on 10/14/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ACFloatingTextfield_Swift
import Toaster

class InfoAccountController: BaseViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource, ChooseMultiDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var desideratedCareer = [DesideratedCareer]()
    var vc = CarrerOrCityController()
    var viewModel = HomeViewModel()
    var arrTitle = ["","Mã nhân viên","Số điện thoại","Ngày sinh","Địa chỉ","Quốc gia","Tỉnh/Thành","Tên công ty hiện tại","Ngaanhf nghề muốn hợp tác","Ngày ký hợp đồng","Đổi mật khẩu"]
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
            if let code = userProfile.idColl {
                self.arrContent.append("\(code)")
            } else {
                self.arrContent.append("")
            }
            if let phone = userProfile.phoneColl {
                self.arrContent.append("\(phone)")
            } else {
                self.arrContent.append("")
            }
            self.arrContent.append("12/08/1991")
            if let address = userProfile.addressColl {
                self.arrContent.append("\(address)")
            } else {
                self.arrContent.append("")
            }
            self.arrContent.append("Việt Nam")
            self.arrContent.append("Hà Nội")
             self.arrContent.append("IIST")
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
            self.arrContent.append("Hà Nội")
            self.arrContent.append("IIST")
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
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! HeaderCell
            cell.lblName.text = self.arrContent[indexPath.row]
            cell.lblEmail.text = self.arrContent[indexPath.row+1]
            return cell
        } else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iseditcell") as! IsEditCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrContent[indexPath.row+1]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gotocell") as! GoToCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrContent[indexPath.row+1]
            return cell
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
                self.desideratedCareer.append(DesideratedCareer(id: mychooseMulti[i].id,name: mychooseMulti[i].name))
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
