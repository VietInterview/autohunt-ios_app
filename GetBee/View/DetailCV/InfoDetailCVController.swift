///**
/**
 Created by: Hiep Nguyen Nghia on 11/17/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

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
    @IBOutlet weak var textViewJobDes: UITextView!
    
    var detailCV = DetailCV()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPhone.text = self.detailCV.phone!
        lblEmail.text = self.detailCV.email!
        if self.detailCV.sex! == 1 {
            lblGender.text = "Nam"
        } else  if self.detailCV.sex! == 0{
            lblGender.text = "Nữ"
        } else {
            lblGender.text = "Khác"
        }
        lblAdd.text = self.detailCV.address!
        lblCity.text = self.detailCV.city!.name!
        lblMarried.text = self.detailCV.maritalStatus! == 1 ? "Chưa kết hôn" : "Đã kết hôn"
        lblPositionWish.text = self.detailCV.desiredPosition!
        lblCurrentLevel.text = self.detailCV.currentLevel!.name!
        lblWishLevel.text = self.detailCV.desiredLevel!.name!
        var carrerAppendString = ""
        for i in 0...self.detailCV.lstCareer!.count-1{
            if i == self.detailCV.lstCareer!.count-1{
                carrerAppendString.append(self.detailCV.lstCareer![i].name!)
            }else{
                carrerAppendString.append("\(self.detailCV.lstCareer![i].name!),")
            }
        }
        lblCarrer.text = carrerAppendString
        var appendString = ""
        for i in 0...self.detailCV.lstJobCity!.count-1 {
            if i == self.detailCV.lstJobCity!.count-1 {
                appendString.append("\(self.detailCV.lstJobCity![i].name!)")
            } else {
                appendString.append("\(self.detailCV.lstJobCity![i].name!),")
            }
        }
        lblLocationWork.text = appendString
        lblEdu.text = self.detailCV.educationLevel!.name!
        lblExpYear.text = self.detailCV.experienceYear!.name!
        lblSalary.text = "\(StringUtils.shared.currencyFormat(value: self.detailCV.desiredSalary!) ) \(self.detailCV.currencyName!)"
        textViewJobDes.text = self.detailCV.careerObjectives!
    }
    
    
}
