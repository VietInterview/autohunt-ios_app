///**
/**
Created by: Hiep Nguyen Nghia on 12/18/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit
import ExpandableLabel

class ExpandableDetailJobCell: UITableViewCell {
    @IBOutlet weak var expandableLabel: ExpandableLabel!
    
    @IBOutlet weak var lblPre: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        expandableLabel.collapsed = true
        expandableLabel.text = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
