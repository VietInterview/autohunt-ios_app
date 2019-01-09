///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class DetailInterviewController: BaseViewController {
    
    @IBOutlet weak var lblRound: UILabel!
    @IBOutlet weak var lblDateInterview: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    
    var lstInterviewHi:LstInterviewHi?
    
    convenience init() {
        self.init(nibName: "DetailInterviewController", bundle: nil)
    }
    
    func setArgument(lstInterviewHi:LstInterviewHi? = nil) -> DetailInterviewController{
        let vc = self.assignValueToController(nameController: "DetailInterviewController") as! DetailInterviewController
        vc.lstInterviewHi = lstInterviewHi
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblRound.text = self.lstInterviewHi?.round!
        self.lblDateInterview.text = self.lstInterviewHi?.interviewDate!
        self.lblAdd.text = self.lstInterviewHi?.interviewAddress!
        self.lblNote.text = StringUtils.shared.checkEmpty(value: self.lstInterviewHi?.note) 
        self.lblResult.text = self.switchStatus(value: self.lstInterviewHi!.status!)
    }
    func switchStatus(value:Int) -> String {
        var stringStatus:String
        switch value {
        case 1:
            stringStatus = "Đạt"
        case 2:
            stringStatus = "Không đạt"
        case 3:
            stringStatus = "Ứng viên không đến"
        default:
            stringStatus = "Chưa có kết quả"
        }
        return stringStatus
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
