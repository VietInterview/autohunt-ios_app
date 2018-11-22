///**
/**
 Created by: Hiep Nguyen Nghia on 11/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import GoneVisible

class ChooseCVSubmitController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var cvList: [CvList]?
    var jobId: Int = 0
    @IBOutlet weak var lblChooseMyCV: UILabel!
    @IBOutlet weak var quantityView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblChooseMyCV.text = "\(self.cvList!.count) hồ sơ được tìm thấy"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cvList!.count > 0 {
            return self.cvList!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CVSubmitTableViewCell", for: indexPath) as! CVSubmitTableViewCell
        cell.lblName.text = self.cvList![indexPath.row].fullName!
        cell.lblCarrer.text = self.cvList![indexPath.row].careerName!
       cell.lblDateUpdate.text = DateUtils.shared.convertToShowFormatDate(dateString: self.cvList![indexPath.row].updatedDate!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailCVController") as! DetailCVController
        vc.title = "Chi tiết Hồ sơ"
        vc.jobId = self.jobId
        vc.cvId = self.cvList![indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            quantityView.isHidden = false
            quantityView.visible()
            //            self.actionButton.visible()
        } else {
            quantityView.gone()
            //            self.actionButton.gone()
            quantityView.isHidden = true
        }
    }
}
