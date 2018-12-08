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
    
    @IBOutlet weak var imgArrowRequi: UIImageView!
    @IBOutlet weak var imgArrowDes: UIImageView!
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
         let gestureSwift2AndHigher2 = UITapGestureRecognizer(target: self, action:  #selector (self.someAction2))
        self.mViewDes.isUserInteractionEnabled = true
        self.mViewRequi.isUserInteractionEnabled = true
        self.mViewRequi.addGestureRecognizer(gestureSwift2AndHigher2)
        self.mViewDes.addGestureRecognizer(gestureSwift2AndHigher)
    }
    var isShowDes:Bool = true
    var isShowRequi:Bool = true
    @objc func someAction(sender:UITapGestureRecognizer){
        if isShowDes {
            isShowDes = false
            lblJobDescription.isHidden = true
            lblJobDescription.gone()
        } else {
            isShowDes = true
            lblJobDescription.isHidden = false
            lblJobDescription.visible()
        }
        imgArrowDes.image = isShowDes ? UIImage(named: "arrow_down") : UIImage(named: "arrow_right")
    }
    @objc func someAction2(sender:UITapGestureRecognizer){
        if isShowRequi {
            isShowRequi = false
            lblRequireJob.isHidden = true
            lblRequireJob.gone()
        } else {
            isShowRequi = true
            lblRequireJob.isHidden = false
            lblRequireJob.visible()
        }
        imgArrowRequi.image = isShowRequi ? UIImage(named: "arrow_down") : UIImage(named: "arrow_right")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.lblJobDescription.setNeedsLayout()
        self.lblJobDescription.layoutIfNeeded()
        self.lblRequireJob.setNeedsLayout()
        self.lblRequireJob.layoutIfNeeded()
        if let delegateSendHeight = self.delegate {
            delegateSendHeight.sendHeight(height: Int(self.lblJobDescription.frame.size.height + self.lblRequireJob.frame.size.height + 500))
        }
    }
}
