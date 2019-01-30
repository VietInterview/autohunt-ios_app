///**
/**
Created by: Hiep Nguyen Nghia on 1/17/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class IsEditCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var textViewContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
