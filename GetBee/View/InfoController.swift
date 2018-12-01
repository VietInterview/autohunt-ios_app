///**
/**
 Created by: Hiep Nguyen Nghia on 10/15/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit
protocol SendHeightView{
    func sendHeight(height: Int)
}
class InfoController: UIViewController {
    
    @IBOutlet weak var lblRequireJob: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    @IBOutlet weak var lblCarrerName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPublicDate: UILabel!
    @IBOutlet weak var lblExpirationDate: UILabel!
    @IBOutlet weak var lblSalaryCandidate: UILabel!
    @IBOutlet weak var lblCVSend: UILabel!
//    @IBOutlet weak var lblJobDescription: UITextView!
    @IBOutlet weak var lblQuantityHiring: UILabel!
    @IBOutlet weak var lblCollaboratorsReward: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
//    @IBOutlet weak var requireJob: UITextView!
    @IBOutlet weak var mViewDes: UIView!
    @IBOutlet weak var mViewRequi: UIView!
    @IBOutlet weak var lblDesTit: UILabel!
    
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
    var requireJobContent: String = ""
    var delegate: SendHeightView?
    
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
        self.lblRequireJob.text = requireJobContent
        
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction))
        self.mViewDes.isUserInteractionEnabled = true
        self.lblDesTit.isUserInteractionEnabled = true
        self.lblDesTit.addGestureRecognizer(gestureSwift2AndHigher)
        self.mViewDes.addGestureRecognizer(gestureSwift2AndHigher)
//        self.mViewRequi.addGestureRecognizer(gestureSwift2AndHigher)
 
    
    }
    
    @objc func someAction(sender:UITapGestureRecognizer){
       debugLog(object: "Des press")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.lblJobDescription.setNeedsLayout()
        self.lblJobDescription.layoutIfNeeded()
        self.lblRequireJob.setNeedsLayout()
        self.lblRequireJob.layoutIfNeeded()
           debugLog(object: "\(self.lblJobDescription.frame.size.height) \(self.lblRequireJob.frame.size.height)")
        if let delegateSendHeight = self.delegate {
            delegateSendHeight.sendHeight(height: Int(self.lblJobDescription.frame.size.height + self.lblRequireJob.frame.size.height))
        }
    }
}
