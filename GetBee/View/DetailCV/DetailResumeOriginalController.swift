///**
/**
Created by: Hiep Nguyen Nghia on 1/31/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class DetailResumeOriginalController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var arrTitle = [String]()
    let numberOfCells : NSInteger = 20
    let viewModel = HomeViewModel()
    var arrContent = [String]()
    var isAttached:Bool = false
    var cvUploadDetail:CvListUpload?
    var cvOrigin:CvList2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isAttached {
            arrTitle = ["","Họ tên ứng viên","Email","Số điện thoại","Lĩnh vực","Hồ sơ đính kèm","Thời gian"]
        } else {
            arrTitle = ["","Mã hồ sơ","Vị trí ứng tuyển","Email","Số điện thoại","Loại hồ sơ","Ngày đăng"]
        }
        if let cvUpload = self.cvUploadDetail {
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.fullName))
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.fullName))
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.email))
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.phone))
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.careerName))
            let fullName    = StringUtils.checkEmpty(value: cvUpload.fileURL)
            let fullNameArr = fullName.components(separatedBy: "/")
            
            arrContent.append(StringUtils.checkEmpty(value: fullNameArr[fullNameArr.count-1]))
            arrContent.append(StringUtils.checkEmpty(value: cvUpload.createdDate))
        } else if let cvOrigin = self.cvOrigin {
            arrContent.append(StringUtils.checkEmpty(value: cvOrigin.fullName))
            arrContent.append(StringUtils.checkEmpty(value: "cvOrigin.id"))
            arrContent.append(StringUtils.checkEmpty(value: "cvOrigin."))
            arrContent.append(StringUtils.checkEmpty(value: "cvOrigin."))
            arrContent.append(StringUtils.checkEmpty(value: "cvOrigin."))
            arrContent.append(StringUtils.checkEmpty(value: "cvOrigin.fileURL"))
            arrContent.append(StringUtils.checkEmpty(value: cvOrigin.updatedDate))
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.isAttached ? 0 : 160
        } else {
            return 67
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalcell") as! NormalTableCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrContent[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! HeaderCell
            cell.imgAva.showImage(imgUrl: nil, imageNullName: "ava_null")
            cell.lblEmail.text = "Nguyễn Nghĩa Hiệp"
            self.showHideView(view: cell, isHidden: self.isAttached ? true : false)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
}
