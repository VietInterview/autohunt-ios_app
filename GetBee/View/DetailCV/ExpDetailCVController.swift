///**
/**
 Created by: Hiep Nguyen Nghia on 11/17/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
import ExpandableCell
protocol SendHeightViewExpDetailCV{
    func sendHeightExpDetailCV(height: Int)
}
class ExpDetailCVController: UIViewController {
    @IBOutlet weak var mExpTableView: ExpandableTableView!
    @IBOutlet weak var lblNodata: UILabel!
    
    @IBOutlet var viewParent: UIView!
    var delegate:SendHeightViewExpDetailCV?
    var mCell:ExpandedCell?
    var lastIndexPath:IndexPath?
    var detailCV = DetailCV()
    var cell: UITableViewCell {
        return mExpTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mExpTableView.expandableDelegate = self
        mExpTableView.animation = .automatic
        if detailCV.lstEmploymentHis!.count > 0 {
            lblNodata.isHidden = true
            lblNodata.gone()
            mExpTableView.isHidden = false
            mExpTableView.visible()
        } else {
            lblNodata.isHidden = false
            lblNodata.visible()
            mExpTableView.isHidden = true
            mExpTableView.gone()
        }
        mExpTableView.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
        mExpTableView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let mDelegate = self.delegate {
            self.viewParent.setNeedsLayout()
            self.viewParent.layoutIfNeeded()
            if let mCell = self.mCell {
                mDelegate.sendHeightExpDetailCV(height: Int(80 + self.mCell!.heightContentView.constant))
            } else {
                mDelegate.sendHeightExpDetailCV(height: Int(100 * self.detailCV.lstEmploymentHis!.count))
            }
        }
    }
}
extension ExpDetailCVController: ExpandableDelegate {
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell1 = self.mExpTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        cell1.lblCompanyName.text = self.detailCV.lstEmploymentHis![indexPath.row].companyName
        cell1.lblQuantityEmp.text = StringUtils.genStringHumanResource(value: self.detailCV.lstEmploymentHis![indexPath.row].humanResources!)
        cell1.lblJobTitle.text = self.detailCV.lstEmploymentHis![indexPath.row].title!
        cell1.lblTimeWork.text = "\(DateUtils.convertFormatDate(dateString: "\(self.detailCV.lstEmploymentHis![indexPath.row].fromMonth!)")) - \(DateUtils.convertFormatDate(dateString: "\(self.detailCV.lstEmploymentHis![indexPath.row].toMonth!)"))"
        if let isCurrent = self.detailCV.lstEmploymentHis![indexPath.row].isCurrent {
            if isCurrent == 0{
                cell1.lblIsCurrentJob.isHidden = true
            } else {
                cell1.lblIsCurrentJob.isHidden = false
                cell1.lblIsCurrentJob.text = NSLocalizedString("current_job", comment: "")
            }
        } else {
            cell1.lblIsCurrentJob.isHidden = true
        }
        cell1.lblSalary.text = StringUtils.currencyFormat(value: StringUtils.checkEmptyInt(value: self.detailCV.lstEmploymentHis![indexPath.row].salary)) + StringUtils.genStringCurrency(value:StringUtils.checkEmptyInt(value: self.detailCV.lstEmploymentHis![indexPath.row].salaryCurency))
        cell1.lblJobDes.text = self.detailCV.lstEmploymentHis![indexPath.row].jobDescription!
        cell1.lblTargetJob.text = StringUtils.checkEmpty(value: self.detailCV.lstEmploymentHis![indexPath.row].achievement)
        cell1.contentView.layoutIfNeeded()
        cell1.lblTargetJob.layoutIfNeeded()
        cell1.lblTargetJob.setNeedsLayout()
        cell1.lblJobDes.layoutIfNeeded()
        cell1.lblJobDes.setNeedsLayout()
        cell1.heightContentView.constant = ScreenUtils.getScreenWidth() == 414 ?  500 + cell1.lblTargetJob.frame.size.height + cell1.lblJobDes.frame.size.height : 750 + cell1.lblTargetJob.frame.size.height + cell1.lblJobDes.frame.size.height
        cell1.contentView.layoutIfNeeded()
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell1.viewContent.frame
        rectShape.position = cell1.viewContent.center
        rectShape.path = UIBezierPath(roundedRect: cell1.viewContent.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        cell1.viewContent.layer.borderColor = UIColor.gray.cgColor
        cell1.viewContent.layer.borderWidth = 1
        cell1.viewContent.layer.mask = rectShape
        self.mCell = cell1
        if let mDelegate = self.delegate {
            mDelegate.sendHeightExpDetailCV(height: Int(80 + self.mCell!.heightContentView.constant))
        }
        return [cell1]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [self.mCell!.viewContent.frame.size.height]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailCV.lstEmploymentHis!.count
    }
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //        if let lastIndex = self.lastIndexPath {
        //            if self.lastIndexPath!.row != -1 && indexPath.row != self.lastIndexPath!.row {
        //                self.mExpTableView.close(at: self.lastIndexPath!)
        //            }
        //        }
        //        self.lastIndexPath = indexPath
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableCell2.ID) as! ExpandableCell2
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell.viewHeader.frame
        rectShape.position = cell.viewHeader.center
        rectShape.path = UIBezierPath(roundedRect: cell.viewHeader.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        cell.viewHeader.layer.borderColor = UIColor.gray.cgColor
        cell.viewHeader.layer.borderWidth = 1
        cell.viewHeader.layer.mask = rectShape
        cell.lblTitle.text = self.detailCV.lstEmploymentHis![indexPath.row].title!
        cell.lblSubTitle.text = self.detailCV.lstEmploymentHis![indexPath.row].companyName!
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc(expandableTableView:didHighlightRowAt:) func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }
}
