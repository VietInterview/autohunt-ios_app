///**
/**
Created by: Hiep Nguyen Nghia on 12/10/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import SwipeCellKit

class JobEmployerCell: SwipeTableViewCell {

    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var lblCountOffer: UILabel!
    @IBOutlet weak var lblCountCV: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
