///**
/**
Created by: Hiep Nguyen Nghia on 11/7/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var labelFee: UILabel!
    @IBOutlet weak var labelDeadlineDate: UILabel!
    @IBOutlet weak var labelCityList: UILabel!
    @IBOutlet weak var labelCarrer: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelJob: UILabel!
    @IBOutlet weak var imgSaveUnSaveJob: UIImageView!
    @IBOutlet weak var imgCompany: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
