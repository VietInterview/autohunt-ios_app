///**
/**
Created by: Hiep Nguyen Nghia on 1/18/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class SignUpCustomerController: BaseViewController {

    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var textFieldCompanyName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhonenumber: UITextField!
    @IBOutlet weak var textFieldContact: UITextField!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var btnSignupCustomer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewInput.shadowView(opacity: 15/100, radius: 5, color: "#191830")
    }

}
