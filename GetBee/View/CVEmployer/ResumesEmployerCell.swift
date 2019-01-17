///**
/**
Created by: Hiep Nguyen Nghia on 12/11/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import SwipeCellKit

class ResumesEmployerCell: SwipeTableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDateSubmit: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
