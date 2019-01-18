///**
/**
Created by: Hiep Nguyen Nghia on 1/18/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class SignUpCustomerController: BaseViewController {

    @IBOutlet weak var viewInput: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewInput.shadowView(opacity: 15/100, radius: 5, color: "#191830")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
