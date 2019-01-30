///**
/**
Created by: Hiep Nguyen Nghia on 1/17/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgEditName: UIImageView!
    @IBOutlet weak var textViewName: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
