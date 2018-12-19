///**
/**
 Created by: Hiep Nguyen Nghia on 12/11/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ExpandableLabel

class DetailJobCustomerController: BaseViewController,ExpandableLabelDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
    
    var arrTitle = ["Cấp bậc","Hình thức làm việc","Lĩnh vực ngành nghề","Yêu cầu kinh nghiệm","Nơi làm việc","Số lượng tuyển","Bằng cấp","Độ tuổi","Mức lương","Thưởng cộng tác viên","Ngày đăng","Ngày hết hạn","Từ khóa","Nhận hồ sơ bằng ngôn ngữ","Người liên hệ","Email nhận thông báo","Mô tả công việc","Yêu cầu công việc"]
    let numberOfCells : NSInteger = 18
    var states : Array<Bool>!
    let viewModel = HomeViewModel()
    var arrContent = [String]()
    var jobId:Int = 0
    var limit:Int = 0
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.getDetailJobCustomer(jobId: self.jobId)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func getDetailJobCustomer(jobId:Int){
        viewModel.getJobDetailCustomer(jobId: jobId, success: {jobDetailCustomer in
            self.lblJobTitle.text = jobDetailCustomer.jobTitle!
            if self.status == 1 && self.limit > 0 && self.limit < 8 {
                self.lblDeadline.text = "Sắp hết hạn"
            } else if self.status == 1 && self.limit > 7 {
                self.lblDeadline.text = "Còn " + "\(self.limit)" + " ngày"
            } else if self.status == 1 && self.limit == 0 {
                self.lblDeadline.text = "Đã hết hạn"
            } else if self.status == 0 {
                self.lblDeadline.text = "Nháp"
            }
            if let currentlevel = jobDetailCustomer.currentLevel{
                self.arrContent.append(StringUtils.shared.checkEmpty(value: currentlevel.name))
            }else {
                self.arrContent.append("")
            }
            
            if let workingForm = jobDetailCustomer.workingForm {
                self.arrContent.append(StringUtils.shared.checkEmpty(value: workingForm.name))
            }else {
                self.arrContent.append("")
            }
            
            if let lstCarrer = jobDetailCustomer.lstCareer {
                var lstCareer:String = ""
                for i in 0...lstCarrer.count-1 {
                    if i == lstCarrer.count-1 {
                        lstCareer.append("\(StringUtils.shared.checkEmpty(value: lstCarrer[i].name))")
                    } else {
                        lstCareer.append("\(StringUtils.shared.checkEmpty(value: lstCarrer[i].name)), ")
                    }
                }
                self.arrContent.append(lstCareer)
            }else{
                 self.arrContent.append("")
            }
            
            self.arrContent.append(StringUtils.shared.checkEmpty(value: jobDetailCustomer.workExperience))
            
            if let lstCitys = jobDetailCustomer.lstJobCity {
                var lstCity:String = ""
                for i in 0...lstCitys.count-1 {
                    if i == lstCitys.count-1 {
                        lstCity.append("\(StringUtils.shared.checkEmpty(value: lstCitys[i].name))")
                    } else {
                        lstCity.append("\(StringUtils.shared.checkEmpty(value: lstCitys[i].name)), ")
                    }
                }
                self.arrContent.append(lstCity)
            }else{
                self.arrContent.append("")
            }
            
            self.arrContent.append("\(StringUtils.shared.checkEmptyInt(value: jobDetailCustomer.quantity))")
            
            if let educationLevel = jobDetailCustomer.educationLevel{
                self.arrContent.append(StringUtils.shared.checkEmpty(value: educationLevel.name))
            }else{
                self.arrContent.append("")
            }
            
            self.arrContent.append("\(StringUtils.shared.checkEmptyInt(value: jobDetailCustomer.age))")
            
            self.arrContent.append("\(StringUtils.shared.checkEmptyInt(value: jobDetailCustomer.fromSalary)) - \(StringUtils.shared.checkEmptyInt(value: jobDetailCustomer.toSalary))")
            
            self.arrContent.append("\(StringUtils.shared.checkEmptyInt(value: jobDetailCustomer.fee))")
            
            self.arrContent.append(DateUtils.shared.convertFormatDateFull(dateString: StringUtils.shared.checkEmpty(value: jobDetailCustomer.submitDate)))
            
            self.arrContent.append(DateUtils.shared.convertFormatDateFull(dateString: StringUtils.shared.checkEmpty(value: jobDetailCustomer.expireDate)))
            
            self.arrContent.append(StringUtils.shared.checkEmpty(value: jobDetailCustomer.tag))
            
            if let language = jobDetailCustomer.language{
                self.arrContent.append("\(language)")
            }else{
                self.arrContent.append("Bất kỳ")
            }
            
            if let customer = jobDetailCustomer.customers{
                self.arrContent.append(StringUtils.shared.checkEmpty(value: customer.contactName))
                self.arrContent.append(StringUtils.shared.checkEmpty(value: customer.contactEmail))
            }else{
                self.arrContent.append("")
                self.arrContent.append("")
            }
            
            self.arrContent.append(StringUtils.shared.stringFromHtml(string: StringUtils.shared.checkEmpty(value: jobDetailCustomer.jobDescription))!)
            
            self.arrContent.append(StringUtils.shared.stringFromHtml(string: StringUtils.shared.checkEmpty(value: jobDetailCustomer.jobRequirements))!)
            self.states = [Bool](repeating: true, count: self.numberOfCells)
            self.tableView.estimatedRowHeight = 76
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }, failure: {error in
            self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
        })
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
            cell.lblContent.text = self.arrContent[indexPath.row]
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
            self.showHideView(view: self.headerView, isHidden: true)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.showHideView(view: self.headerView, isHidden: false)
        } else {
        }
    }
}
