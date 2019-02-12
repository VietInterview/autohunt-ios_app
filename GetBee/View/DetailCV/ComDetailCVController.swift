///**
/**
Created by: Hiep Nguyen Nghia on 11/18/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import ExpandableCell
protocol SendHeightViewComDetailCV{
    func sendHeightComDetailCV(height: Int)
}
class ComDetailCVController: UIViewController {
    @IBOutlet weak var mComTableView: ExpandableTableView!
    @IBOutlet weak var lblNodata: UILabel!
    
    @IBOutlet var viewParent: UIView!
    var delegate:SendHeightViewComDetailCV?
    var detailCV = DetailCV()
    var cell: UITableViewCell {
        return mComTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mComTableView.expandableDelegate = self
        mComTableView.animation = .automatic
        if detailCV.lstComputerSkill!.count > 0 {
            lblNodata.isHidden = true
            lblNodata.gone()
            mComTableView.isHidden = false
            mComTableView.visible()
        } else {
            lblNodata.isHidden = false
            lblNodata.visible()
            mComTableView.isHidden = true
            mComTableView.gone()
        }
        mComTableView.register(UINib(nibName: "ExpandedLanCell", bundle: nil), forCellReuseIdentifier: ExpandedLanCell.ID)
        mComTableView.register(UINib(nibName: "ExpandableLanCell", bundle: nil), forCellReuseIdentifier: ExpandableLanCell.ID)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let mDelegate = self.delegate {
            self.mComTableView.layoutIfNeeded()
            self.mComTableView.setNeedsDisplay()
            mDelegate.sendHeightComDetailCV(height: Int(self.mComTableView.frame.size.height))
        }
    }
}

extension ComDetailCVController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell1 = self.mComTableView.dequeueReusableCell(withIdentifier: ExpandedLanCell.ID) as! ExpandedLanCell
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell1.viewContent.frame
        rectShape.position = cell1.viewContent.center
        rectShape.path = UIBezierPath(roundedRect: cell1.viewContent.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        cell1.viewContent.layer.borderColor = UIColor.gray.cgColor
        cell1.viewContent.layer.borderWidth = 1
        cell1.viewContent.layer.mask = rectShape
        cell1.lblListen.text = StringUtils.genStringLan(value: self.detailCV.lstComputerSkill![indexPath.row].msWord!)
        cell1.lblSpeak.text = StringUtils.genStringLan(value: self.detailCV.lstComputerSkill![indexPath.row].msExcel!)
        cell1.lblRead.text = StringUtils.genStringLan(value: self.detailCV.lstComputerSkill![indexPath.row].msPowerPoint!)
        cell1.lblWrite.text = StringUtils.genStringLan(value: self.detailCV.lstComputerSkill![indexPath.row].msOutlook!)
        cell1.lblTitleListen.text = "MS Word"
        cell1.lblTitleSpeak.text = "MS Excel"
        cell1.lblTitleRead.text = "MS PowerPoint"
        cell1.lblTitleWrite.text = "MS OutLook"
        return [cell1]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [344]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailCV.lstComputerSkill!.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        //        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.titleLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableLanCell.ID) as! ExpandableLanCell
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell.viewHeader.frame
        rectShape.position = cell.viewHeader.center
        rectShape.path = UIBezierPath(roundedRect: cell.viewHeader.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        cell.viewHeader.layer.borderColor = UIColor.gray.cgColor
        cell.viewHeader.layer.borderWidth = 1
        cell.viewHeader.layer.mask = rectShape
        cell.lblTItle.text = NSLocalizedString("office_information", comment: "")
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc(expandableTableView:didHighlightRowAt:) func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        //        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        //        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //        let cell = expandableTableView.cellForRow(at: indexPath)
        //        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        //        cell?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    //    func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
    //
    //    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 33
    //    }
}
