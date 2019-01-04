///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class DetailOfferController: BaseViewController {
    
    @IBOutlet weak var lblRound: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblWorkTime: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    
    var lstOffer:LstOfferHi?
    
    convenience init() {
        self.init(nibName: "DetailOfferController", bundle: nil)
    }
    
    func setArgument(lstOffer:LstOfferHi? = nil) -> DetailOfferController{
        let vc = self.assignValueToController(nameController: "DetailOfferController") as! DetailOfferController
        vc.lstOffer = lstOffer
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thông tin Offer"
        self.lblRound.text = self.lstOffer!.round!
        self.lblSalary.text = "\(StringUtils.shared.currencyFormat(value: self.lstOffer!.salary!)) \(self.switchCurrency(value: self.lstOffer!.curency!))"
    self.lblWorkTime.text = self.lstOffer!.workTime!
        self.lblAdd.text = self.lstOffer!.workAddress!
        self.lblPosition.text = self.lstOffer!.position!
        self.lblNote.text = self.lstOffer!.note!
        self.lblResult.text = self.switchStatus(value: self.lstOffer!.status!)
    }
    func switchStatus(value:Int) -> String {
        var stringStatus:String
        switch value {
        case 1:
            stringStatus = "Đồng ý"
        case 2:
            stringStatus = "Không đồng ý"
        default:
            stringStatus = "Chưa có kết quả"
        }
        return stringStatus
    }
    func switchCurrency(value:Int) -> String {
        var currencyString:String = ""
        switch value {
        case 1:
            currencyString = "VND"
        case 2:
            currencyString = "USD"
        case 3:
            currencyString = "JPY"
        default:
            currencyString = "VND"
        }
        return currencyString
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
