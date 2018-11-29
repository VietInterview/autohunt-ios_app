///**
/**
Created by: Hiep Nguyen Nghia on 11/18/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import ExpandableCell

class LevelDetailCVController: UIViewController {
    @IBOutlet weak var LevelTableView: ExpandableTableView!
    @IBOutlet weak var lblNodata: UILabel!
    
    
    var detailCV = DetailCV()
    var cell: UITableViewCell {
        return LevelTableView.dequeueReusableCell(withIdentifier: ExpandedLevelCell.ID)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        LevelTableView.expandableDelegate = self
        LevelTableView.animation = .automatic
        if detailCV.lstEducationHis!.count > 0 {
            lblNodata.isHidden = true
            lblNodata.gone()
            LevelTableView.isHidden = false
            LevelTableView.visible()
        } else {
            lblNodata.isHidden = false
            lblNodata.visible()
            LevelTableView.isHidden = true
            LevelTableView.gone()
        }
        LevelTableView.register(UINib(nibName: "ExpandableLevelCell2", bundle: nil), forCellReuseIdentifier: ExpandedLevelCell.ID)
        LevelTableView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
    }

}
extension LevelDetailCVController: ExpandableDelegate {
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell1 = self.LevelTableView.dequeueReusableCell(withIdentifier: ExpandedLevelCell.ID) as! ExpandedLevelCell
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell1.viewContent.frame
        rectShape.position = cell1.viewContent.center
        rectShape.path = UIBezierPath(roundedRect: cell1.viewContent.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        cell1.viewContent.layer.borderColor = UIColor.gray.cgColor
        cell1.viewContent.layer.borderWidth = 1
        cell1.viewContent.layer.mask = rectShape
        cell1.lblCer.text = self.detailCV.lstEducationHis![indexPath.row].subject!
        cell1.lblSchool.text = self.detailCV.lstEducationHis![indexPath.row].school!
        cell1.lblTime.text = "\(DateUtils.shared.convertFormatDate(dateString: "\(self.detailCV.lstEducationHis![indexPath.row].fromMonth!)")) - \(DateUtils.shared.convertFormatDate(dateString: "\(self.detailCV.lstEducationHis![indexPath.row].toMonth!)"))"
        cell1.lblSpecialized.text = self.detailCV.lstEducationHis![indexPath.row].career!
        cell1.lblGraduationType.text = self.detailCV.lstEducationHis![indexPath.row].graduationTypeName!
        return [cell1]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [450]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailCV.lstEducationHis!.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        //        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
//        if let cell = expandedCell as? ExpandedCell {
//            print("\(cell.titleLabel.text ?? "")")
//        }
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
        cell.lblTitle.text = self.detailCV.lstEducationHis![indexPath.row].school!
        cell.lblSubTitle.text = "\(DateUtils.shared.convertFormatDate(dateString: "\(self.detailCV.lstEducationHis![indexPath.row].fromMonth!)")) - \(DateUtils.shared.convertFormatDate(dateString: "\(self.detailCV.lstEducationHis![indexPath.row].toMonth!)"))"
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
