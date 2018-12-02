//
//  ExpandableCells.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 7..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit
import ExpandableCell


class NormalCell: UITableViewCell {
    static let ID = "NormalCell"
}

class ExpandableCell2: ExpandableCell {
    static let ID = "ExpandableCell"
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
}
class ExpandableLanCell: ExpandableCell {
    static let ID = "ExpandableLanCell"
    
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
}
class ExpandedLanCell: UITableViewCell {
    static let ID = "ExpandedLanCell"
    
    @IBOutlet weak var lblTitleWrite: UILabel!
    @IBOutlet weak var lblTitleRead: UILabel!
    @IBOutlet weak var lblTitleSpeak: UILabel!
    @IBOutlet weak var lblTitleListen: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblListen: UILabel!
    @IBOutlet weak var lblSpeak: UILabel!
    @IBOutlet weak var lblRead: UILabel!
    @IBOutlet weak var lblWrite: UILabel!
    
}
class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    @IBOutlet weak var lblTargetJob: UILabel!
    @IBOutlet weak var lblJobDes: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblIsCurrentJob: UILabel!
    @IBOutlet weak var lblTimeWork: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblQuantityEmp: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var titleLabel: UILabel!
}
class ExpandedLevelCell: UITableViewCell {
    static let ID = "ExpandedLevelCell"
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblGraduationType: UILabel!
    @IBOutlet weak var lblSpecialized: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblCer: UILabel!
}
