///**
/**
Created by: Hiep Nguyen Nghia on 1/31/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class DetailResumeOriginalController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var arrTitle = ["","Mã hồ sơ","Vị trí ứng tuyển","Email","Số điện thoại","Loại hồ sơ","Ngày đăng"]
    let numberOfCells : NSInteger = 20
    let viewModel = HomeViewModel()
    var arrContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return 67
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalcell") as! NormalTableCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = self.arrTitle[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headercell") as! HeaderCell
            cell.imgAva.showImage(imgUrl: nil, imageNullName: "ava_null")
            cell.lblEmail.text = "Nguyễn Nghĩa Hiệp"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
}
