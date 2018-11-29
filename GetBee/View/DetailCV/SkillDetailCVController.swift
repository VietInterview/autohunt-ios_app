///**
/**
 Created by: Hiep Nguyen Nghia on 11/18/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class SkillDetailCVController: UIViewController {
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var lblHobby: UILabel!
    
    @IBOutlet weak var lblPrimarySkill: UILabel!
    var detailCV = DetailCV()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let cvSkill = self.detailCV.cvSkill{
        lblPrimarySkill.text = StringUtils.shared.checkEmpty(value: self.detailCV.cvSkill!.primarySkill)
            lblHobby.text = StringUtils.shared.checkEmpty(value: self.detailCV.cvSkill!.hobby)
        if let skillOther = self.detailCV.cvSkill!.lstOtherSkillName{
            var appendString = ""
            for i in 0...(self.detailCV.cvSkill!.lstOtherSkillName!.count - 1) {
                appendString.append("\u{2022} \(self.detailCV.cvSkill!.lstOtherSkillName![i])\n")
            }
            lblSkills.text = appendString
        }
        }
    }
}
