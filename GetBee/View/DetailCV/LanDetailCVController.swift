    ///**
    /**
     Created by: Hiep Nguyen Nghia on 11/18/18
     Copyright (c) 2018 Vietinterview. All rights reserved.
     */
    
    import UIKit
    import ExpandableCell
    
    class LanDetailCVController: UIViewController {
        @IBOutlet weak var mLanTableView: ExpandableTableView!
        var detailCV = DetailCV()
        var cell: UITableViewCell {
            return mLanTableView.dequeueReusableCell(withIdentifier: ExpandedLanCell.ID)!
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            mLanTableView.expandableDelegate = self
            mLanTableView.animation = .automatic
            
            mLanTableView.register(UINib(nibName: "ExpandedLanCell", bundle: nil), forCellReuseIdentifier: ExpandedLanCell.ID)
            mLanTableView.register(UINib(nibName: "ExpandableLanCell", bundle: nil), forCellReuseIdentifier: ExpandableLanCell.ID)
        }
    }
    extension LanDetailCVController: ExpandableDelegate {
        func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
            let cell1 = self.mLanTableView.dequeueReusableCell(withIdentifier: ExpandedLanCell.ID) as! ExpandedLanCell
            let rectShape = CAShapeLayer()
            rectShape.bounds = cell1.viewContent.frame
            rectShape.position = cell1.viewContent.center
            rectShape.path = UIBezierPath(roundedRect: cell1.viewContent.bounds, byRoundingCorners: [.bottomRight , .bottomLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
            cell1.viewContent.layer.borderColor = UIColor.gray.cgColor
            cell1.viewContent.layer.borderWidth = 1
            cell1.viewContent.layer.mask = rectShape
            debugLog(object: indexPath.row)
            cell1.lblListen.text = StringUtils.shared.genStringLan(value: self.detailCV.lstLanguage![indexPath.row].listen!)
            cell1.lblRead.text = StringUtils.shared.genStringLan(value: self.detailCV.lstLanguage![indexPath.row].read!)
            cell1.lblSpeak.text = StringUtils.shared.genStringLan(value: self.detailCV.lstLanguage![indexPath.row].speak!)
            cell1.lblWrite.text = StringUtils.shared.genStringLan(value: self.detailCV.lstLanguage![indexPath.row].write!)
            return [cell1]
        }
        
        func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
            return [172]
        }
        
        func numberOfSections(in tableView: ExpandableTableView) -> Int {
            return 1
        }
        
        func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
            return self.detailCV.lstLanguage!.count
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
            debugLog(object: indexPath.row)
            cell.lblTItle.text = self.detailCV.lstLanguage![indexPath.row].languageName!
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
