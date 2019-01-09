///**
/**
Created by: Hiep Nguyen Nghia on 1/9/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class SimpleCell: UITableViewCell {

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewQuantity: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
