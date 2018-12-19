///**
/**
 Created by: Hiep Nguyen Nghia on 12/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ExpandableLabel
protocol UpDownState{
    func upDownState(isUp: Bool)
}
class InfoDetailResumeCustomerController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,ExpandableLabelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var resumeDetailCustomer = ResumeDetailCustomer()
    var delegate: UpDownState?
    let numberOfCells : NSInteger = 18
    var states : Array<Bool>!
    var positionTab:Int = 0
    var arrContent = ["Cấp bậc","Hình thức làm việc","Lĩnh vực ngành nghề","Yêu cầu kinh nghiệm","Nơi làm việc","Số lượng tuyển","Bằng cấp","Độ tuổi","Mức lương","Thưởng cộng tác viên","Ngày đăng","Ngày hết hạn","Từ khóa","Nhận hồ sơ bằng ngôn ngữ","Người liên hệ","Email nhận thông báo","Mô tả công việc","Yêu cầu công việc"]
    var arrTitle = ["Cấp bậc","Hình thức làm việc","Lĩnh vực ngành nghề","Yêu cầu kinh nghiệm","Nơi làm việc","Số lượng tuyển","Bằng cấp","Độ tuổi","Mức lương","Thưởng cộng tác viên","Ngày đăng","Ngày hết hạn","Từ khóa","Nhận hồ sơ bằng ngôn ngữ","Người liên hệ","Email nhận thông báo","Mô tả công việc","Yêu cầu công việc"]
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog(object: "\(self.positionTab)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.states = [Bool](repeating: true, count: self.numberOfCells)
        self.tableView.estimatedRowHeight = 76
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 15 {
            return 76
        } else {
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblContent.text = "\(self.arrContent[indexPath.row])\n he he"
            return cell
        } else {
            let currentSource = preparedSources()[indexPath.row == 16 ? 0 : 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "expanedCell") as! ExpandableDetailJobCell
            cell.expandableLabel.delegate = self
            cell.expandableLabel.setLessLinkWith(lessLink: "Rút gọn", attributes: [.foregroundColor:UIColor.blue], position: currentSource.textAlignment)
            cell.layoutIfNeeded()
            cell.lblTitle.text = arrTitle[indexPath.row]
            cell.expandableLabel.shouldCollapse = true
            cell.expandableLabel.textReplacementType = currentSource.textReplacementType
            cell.expandableLabel.numberOfLines = currentSource.numberOfLines
            cell.expandableLabel.collapsed = states[indexPath.row]
            cell.expandableLabel.text = currentSource.text
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContent.count
    }
    
    func preparedSources() -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        return [(self.arrContent[16], .word, 3, .left),
                (self.arrContent[17], .word, 3, .left)]
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    var lastContentOffset: CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            if let upDownStateDelegate = self.delegate {
                upDownStateDelegate.upDownState(isUp: true)
            }
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            if let upDownStateDelegate = self.delegate {
                upDownStateDelegate.upDownState(isUp: false)
            }
        } else {
        }
    }
}
