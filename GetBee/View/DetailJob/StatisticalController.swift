///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class StatisticalController: UIViewController {
    @IBOutlet weak var lblCountCV: UILabel!
    @IBOutlet weak var lblCountCared: UILabel!
    @IBOutlet weak var lblCountInterviewd: UILabel!
    @IBOutlet weak var lblCountOffer: UILabel!
    @IBOutlet weak var lblCountGoToWork: UILabel!
    @IBOutlet weak var lblMyCountCV: UILabel!
    @IBOutlet weak var lblMyCountInviteInterview: UILabel!
    @IBOutlet weak var lblMyCountInterviewed: UILabel!
    @IBOutlet weak var lblMyCountOffered: UILabel!
    @IBOutlet weak var lblMyCountGoToWork: UILabel!
    
    var CountCV: String = ""
    var CountCared: String = ""
    var CountInterviewd: String = ""
    var CountOffer: String = ""
    var CountGoToWork: String = ""
    var MyCountCV: String = ""
    var MyCountInviteInterview: String = ""
    var MyCountInterviewed: String = ""
    var MyCountOffered: String = ""
    var MyCountGoToWork: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCountCV.text = CountCV
        self.lblCountCared.text = CountCared
        self.lblCountInterviewd.text = CountInterviewd
        self.lblCountOffer.text = CountOffer
        self.lblCountGoToWork.text = CountGoToWork
        self.lblMyCountCV.text = MyCountCV
        self.lblMyCountInviteInterview.text = MyCountInviteInterview
        self.lblMyCountInterviewed.text = MyCountInterviewed
        self.lblMyCountOffered.text = MyCountOffered
        self.lblMyCountGoToWork.text = MyCountGoToWork
    }
    
}
