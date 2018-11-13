///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var lblCarrerName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPublicDate: UILabel!
    @IBOutlet weak var lblExpirationDate: UILabel!
    @IBOutlet weak var lblSalaryCandidate: UILabel!
    @IBOutlet weak var lblCVSend: UILabel!
    @IBOutlet weak var lblJobDescription: UITextView!
    @IBOutlet weak var lblQuantityHiring: UILabel!
    @IBOutlet weak var lblCollaboratorsReward: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var carrerName: String = ""
    var level: String = ""
    var location: String = ""
    var datePublic: String = ""
    var dateExpiration: String = ""
    var status: String = ""
    var salaryCandidate: String = ""
    var collaboratorsReward: String = ""
    var quantityHiring: String = ""
    var quantityCVSend: String = ""
    var jobDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCarrerName.text = carrerName
        self.lblLevel.text = level
        self.lblLocation.text = location
        self.lblPublicDate.text = datePublic
        self.lblExpirationDate.text = dateExpiration
        self.lblSalaryCandidate.text = salaryCandidate
        self.lblStatus.text = status
        self.lblCollaboratorsReward.text = collaboratorsReward
        self.lblQuantityHiring.text = quantityHiring
        self.lblCVSend.text = quantityCVSend
        self.lblJobDescription.text = jobDescription
    }
    
    
}
