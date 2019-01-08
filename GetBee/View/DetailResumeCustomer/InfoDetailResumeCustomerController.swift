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
    var lstEmploymentHis = [LstEmploymentHiResumeDetailCustomer]()
    var lstComputerSkill =  [LstComputerSkillResumeDetailCustomer]()
    var lstEducationHi = [LstEducationHiResumeDetailCustomer]()
    var lstLanguage = [LstLanguageResumeDetailCustomer]()
    var cvSkill = CvSkillResumeDetailCustomer()
    let numberOfCells : NSInteger = 13
    var states : Array<Bool>!
    var positionTab:Int = 0
    var arrContent = ["","","","","","","","","","","","",""]
    var arrTitle = ["Ngày sinh","Giới tính","Tình trạng hôn nhân","Tỉnh/Thành phố","Vị trí mong muốn","Cấp bậc hiện tại","Cấp bậc mong muốn","Ngành nghề","Địa điểm làm việc","Trình độ học vấn","Số năm kinh nghiệm","Mức lương mong muốn","Mục tiêu nghề nghiệp"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.arrContent[0] = DateUtils.shared.convertFormatDateFull(dateString: "\(StringUtils.shared.checkEmptyInt(value: self.resumeDetailCustomer.birthday))")
        self.arrContent[1] = StringUtils.shared.checkEmptyInt(value: self.resumeDetailCustomer.sex) == 1 ? "Nam" : "Nữ"
        self.arrContent[2] = StringUtils.shared.checkEmptyInt(value: self.resumeDetailCustomer.maritalStatus) == 1 ? "Chưa kết hôn" : "Đã kết hôn"
        if let city = self.resumeDetailCustomer.city {
            self.arrContent[3] = StringUtils.shared.checkEmpty(value: city.name)
        }
        self.arrContent[4] = StringUtils.shared.checkEmpty(value: self.resumeDetailCustomer.desiredPosition)
        if let currentLevel = self.resumeDetailCustomer.currentLevel {
            self.arrContent[5] = StringUtils.shared.checkEmpty(value: currentLevel.name)
        }
        if let desiredLevel = self.resumeDetailCustomer.desiredLevel {
            self.arrContent[6] = StringUtils.shared.checkEmpty(value: desiredLevel.name)
        }
        if let lstCarrer = self.resumeDetailCustomer.lstCareer {
            var carrer:String = ""
            for i in 0...lstCarrer.count-1 {
                if i == lstCarrer.count-1 {
                    carrer.append(StringUtils.shared.checkEmpty(value: lstCarrer[i].name))
                } else {
                    carrer.append("\(StringUtils.shared.checkEmpty(value: lstCarrer[i].name)), ")
                }
            }
            self.arrContent[7] = carrer
        }
        self.arrContent[8] = StringUtils.shared.checkEmpty(value: self.resumeDetailCustomer.jobListcityName)
        if let educationLevel = self.resumeDetailCustomer.educationLevel {
            self.arrContent[9] = StringUtils.shared.checkEmpty(value: educationLevel.name)
        }
        if let expYear = self.resumeDetailCustomer.experienceYear{
            self.arrContent[10] = StringUtils.shared.checkEmpty(value: expYear.name)
        }
        self.arrContent[11] = StringUtils.shared.currencyFormat(value: StringUtils.shared.checkEmptyInt(value: self.resumeDetailCustomer.desiredSalary))
        self.arrContent[12] = StringUtils.shared.checkEmpty(value: self.resumeDetailCustomer.careerObjectives)
        if let lstEmploy = self.resumeDetailCustomer.lstEmploymentHis {
            self.lstEmploymentHis = lstEmploy
        }
        if let lstEdu = self.resumeDetailCustomer.lstEducationHis {
            self.lstEducationHi = lstEdu
        }
        if let lstLan = self.resumeDetailCustomer.lstLanguage {
            self.lstLanguage = lstLan
        }
        if let lstCom = self.resumeDetailCustomer.lstComputerSkill {
            self.lstComputerSkill = lstCom
        }
        if let skill = self.resumeDetailCustomer.cvSkill {
            self.cvSkill = skill
        }
        self.states = [Bool](repeating: true, count: self.numberOfCells)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if positionTab == 0 {
            if indexPath.row <= 11 {
                return 76
            } else {
                return UITableViewAutomaticDimension
            }
        }else if positionTab == 1 {
//            return UITableViewAutomaticDimension
        }else if positionTab == 2{
            
        }else if positionTab == 3 {
            return 199
        } else if positionTab == 4{
            if indexPath.row == 0 {
                return 199
            } else {
                return 100
            }
        } else if positionTab == 5 {
            
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.positionTab == 0 {
            if indexPath.row <= 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
                cell.lblTitle.text = self.arrTitle[indexPath.row]
                cell.lblContent.text = "\(self.arrContent[indexPath.row])"
                return cell
            } else {
                let currentSource = preparedSources()[0]
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
        } else if positionTab == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
            cell.lblTitle.text = self.lstEmploymentHis[indexPath.row].companyName!
            cell.lblContent.text = "\(StringUtils.shared.checkEmpty(value:self.lstEmploymentHis[indexPath.row].title))\n\(StringUtils.shared.genStringHumanResource(value:StringUtils.shared.checkEmptyInt(value:  self.lstEmploymentHis[indexPath.row].humanResources)))\nTháng \(DateUtils.shared.convertFormatDate(dateString: "\(StringUtils.shared.checkEmptyInt(value: self.lstEmploymentHis[indexPath.row].fromMonth))")) - \(DateUtils.shared.convertFormatDate(dateString: "\(StringUtils.shared.checkEmptyInt(value: self.lstEmploymentHis[indexPath.row].toMonth))"))\n\(StringUtils.shared.checkEmpty(value:  self.lstEmploymentHis[indexPath.row].jobDescription))"
            return cell
        } else if positionTab == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
            cell.lblTitle.text = self.lstEducationHi[indexPath.row].subject!
            cell.lblContent.text = "\(StringUtils.shared.checkEmpty(value: self.lstEducationHi[indexPath.row].school))\nChuyên ngành: \(StringUtils.shared.checkEmpty(value: self.lstEducationHi[indexPath.row].career))\n\(StringUtils.shared.checkEmpty(value: self.lstEducationHi[indexPath.row].graduationTypeName))"
            
            return cell
        } else if positionTab == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LanComCell") as! LanComCell
            cell.lblTitle.text = self.lstLanguage[indexPath.row].languageName!
            cell.lblTitle1.text = "Nghe:"
            cell.lblTitle2.text = "Nói:"
            cell.lblTitle3.text = "Đọc:"
            cell.lblTitle4.text = "Viết:"
            cell.lblContent1.text = StringUtils.shared.genStringLan(value: self.lstLanguage[indexPath.row].listen!)
            cell.lblContent2.text = StringUtils.shared.genStringLan(value: self.lstLanguage[indexPath.row].speak!)
            cell.lblContent3.text = StringUtils.shared.genStringLan(value: self.lstLanguage[indexPath.row].read!)
            cell.lblContent4.text = StringUtils.shared.genStringLan(value: self.lstLanguage[indexPath.row].write!)
            return cell
        } else if positionTab == 4 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LanComCell") as! LanComCell
                self.showHideView(view: cell.lblTitle, isHidden: true)
                cell.lblTitle1.text = "Microsoft Word:"
                cell.lblTitle2.text = "Microsoft Excel:"
                cell.lblTitle3.text = "Microsoft Power Point:"
                cell.lblTitle4.text = "Microsoft Outlook:"
                if let comSkill = self.resumeDetailCustomer.lstComputerSkill {
                    if comSkill.count > 0 {
                        cell.lblContent1.text = StringUtils.shared.genStringLan(value: comSkill[0].msWord!)
                        cell.lblContent2.text = StringUtils.shared.genStringLan(value: comSkill[0].msExcel!)
                        cell.lblContent3.text = StringUtils.shared.genStringLan(value: comSkill[0].msPowerPoint!)
                        cell.lblContent4.text = StringUtils.shared.genStringLan(value: comSkill[0].msOutlook!)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
                cell.lblTitle.text = "Phần mềm khác"
                if let comSkill = self.resumeDetailCustomer.lstComputerSkill {
                    cell.lblContent.text = StringUtils.shared.checkEmpty(value: comSkill[0].other)
                }
                return cell
            }
        } else if positionTab == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
            if indexPath.row == 0 {
                cell.lblTitle.text = "Kỹ năng chính"
                if let skill = self.resumeDetailCustomer.cvSkill {
                    cell.lblContent.text = StringUtils.shared.checkEmpty(value: skill.primarySkill)
                }
            } else if indexPath.row == 1 {
                cell.lblTitle.text = "Kỹ năng khác"
                var other:String = ""
                if let skill = self.resumeDetailCustomer.cvSkill {
                    if let otherSkill = skill.lstOtherSkillName{
                        for i in 0...otherSkill.count-1 {
                            other.append("\(StringUtils.shared.checkEmpty(value: self.resumeDetailCustomer.cvSkill!.lstOtherSkillName![i]))\n")
                        }
                        cell.lblContent.text = other
                    }
                }
            } else if indexPath.row == 2 {
                cell.lblTitle.text = "Sở thích"
                if let skill = self.resumeDetailCustomer.cvSkill {
                    cell.lblContent.text = StringUtils.shared.checkEmpty(value: skill.hobby)
                }
            }
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalTableCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if positionTab == 0 {
            return arrContent.count
        } else if positionTab == 1 {
            return self.lstEmploymentHis.count
        } else if positionTab == 2 {
            return self.lstEducationHi.count
        } else if positionTab == 3 {
            return self.lstLanguage.count
        } else if positionTab == 4 {
            return self.lstComputerSkill.count+1
        } else if positionTab == 5 {
            return 3
        }else{
            return 0
        }
    }
    
    func preparedSources() -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        return [(self.arrContent[12], .word, 3, .left)]
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
