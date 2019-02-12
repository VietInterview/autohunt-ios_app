///**
/**
Created by: Hiep Nguyen Nghia on 11/20/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import SwipeCellKit

class MyCVTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblQuantityView: UILabel!
    @IBOutlet weak var mQuantityView: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblDateUpdate: UILabel!
    @IBOutlet weak var lblCarrer: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
