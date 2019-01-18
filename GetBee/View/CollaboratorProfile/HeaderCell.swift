///**
/**
Created by: Hiep Nguyen Nghia on 1/17/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
