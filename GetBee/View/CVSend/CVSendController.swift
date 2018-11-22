///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class CVSendController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var lstJobApply = [LstJobApply]()
    
    @IBOutlet weak var lblQuantityCV: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblQuantityCV.text = "\(self.lstJobApply.count) hồ sơ được nộp"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.lstJobApply.count > 0 {
            return self.lstJobApply.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cvsenditemcell", for: indexPath) as! CVSendTableViewCell
        cell.lblName.text = self.lstJobApply[indexPath.row].fullName!
        cell.lblCarrer.text = "Ngày nộp: \(DateUtils.shared.convertToShowFormatDate(dateString: self.lstJobApply[indexPath.row].createdDate!))"
        cell.btnStatus.setTitle(StringUtils.shared.genStringStatus(valueStatus: self.lstJobApply[indexPath.row].status!) , for: .normal)
        cell.btnStatus.backgroundColor = StringUtils.shared.genColor(valueStatus: self.lstJobApply[indexPath.row].status!)
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
}
