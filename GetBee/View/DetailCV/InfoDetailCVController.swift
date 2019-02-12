///**
/**
 Created by: Hiep Nguyen Nghia on 11/17/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
protocol SendHeightViewInfoDetailCV{
    func sendHeightInfoDetailCV(height: Int)
}
class InfoDetailCVController: UIViewController {
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblMarried: UILabel!
    @IBOutlet weak var lblPositionWish: UILabel!
    @IBOutlet weak var lblCurrentLevel: UILabel!
    @IBOutlet weak var lblWishLevel: UILabel!
    @IBOutlet weak var lblCarrer: UILabel!
    @IBOutlet weak var lblLocationWork: UILabel!
    @IBOutlet weak var lblEdu: UILabel!
    @IBOutlet weak var lblExpYear: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblTarget: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    @IBOutlet weak var lblWorkingForm: UILabel!
    var detailCV = DetailCV()
    var delegate:SendHeightViewInfoDetailCV?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPhone.text = StringUtils.checkEmpty(value: self.detailCV.phone)
        lblEmail.text = StringUtils.checkEmpty(value: self.detailCV.email)
        if let sex = self.detailCV.sex {
            if self.detailCV.sex! == 1 {
                lblGender.text = NSLocalizedString("male", comment: "")
            } else  if self.detailCV.sex! == 0{
                lblGender.text = NSLocalizedString("female", comment: "")
            } else {
                lblGender.text = NSLocalizedString("other", comment: "")
            }
        }
        lblAdd.text = StringUtils.checkEmpty(value: self.detailCV.address)
        lblCity.text = StringUtils.checkEmpty(value: self.detailCV.city!.name)
        if let marialStatus = self.detailCV.maritalStatus{
            lblMarried.text = self.detailCV.maritalStatus! == 1 ? NSLocalizedString("have_married", comment: "") : NSLocalizedString("not_have_married", comment: "")
        }
        lblWorkingForm.text = StringUtils.checkEmpty(value: self.detailCV.workingForm!.name)
        lblPositionWish.text = StringUtils.checkEmpty(value: self.detailCV.desiredPosition)
        lblCurrentLevel.text = StringUtils.checkEmpty(value: self.detailCV.currentLevel!.name)
        lblWishLevel.text = StringUtils.checkEmpty(value: self.detailCV.desiredLevel!.name)
        if let lstCarrer = self.detailCV.lstCareer {
            var carrerAppendString = ""
            for i in 0...self.detailCV.lstCareer!.count-1{
                if i == self.detailCV.lstCareer!.count-1{
                    carrerAppendString.append(self.detailCV.lstCareer![i].name!)
                }else{
                    carrerAppendString.append("\(self.detailCV.lstCareer![i].name!),")
                }
            }
            lblCarrer.text = carrerAppendString
        }
        if let lstJobCity = self.detailCV.lstJobCity {
            var appendString = ""
            for i in 0...self.detailCV.lstJobCity!.count-1 {
                if i == self.detailCV.lstJobCity!.count-1 {
                    appendString.append("\(self.detailCV.lstJobCity![i].name!)")
                } else {
                    appendString.append("\(self.detailCV.lstJobCity![i].name!),")
                }
            }
            
            lblLocationWork.text = appendString
        }
        lblEdu.text = StringUtils.checkEmpty(value: self.detailCV.educationLevel!.name)
        lblExpYear.text = StringUtils.checkEmpty(value: self.detailCV.experienceYear!.name)
        if let salary = self.detailCV.desiredSalary{
            lblSalary.text = "\(StringUtils.currencyFormat(value: self.detailCV.desiredSalary!) ) \(StringUtils.checkEmpty(value:  self.detailCV.currencyName))"
        }
        lblTarget.text = StringUtils.checkEmpty(value: self.detailCV.careerObjectives)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblTarget.layoutIfNeeded()
        lblTarget.setNeedsLayout()
        self.heightContentView.constant = self.heightContentView.constant + lblTarget.frame.size.height
        self.contentView.layoutIfNeeded()
        if let mDelegate = self.delegate {
            mDelegate.sendHeightInfoDetailCV(height: Int(lblTarget.frame.size.height))
        }
    }
}
