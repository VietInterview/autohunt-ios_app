///**
/**
Created by: Hiep Nguyen Nghia on 11/23/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class IntroThreeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func gotoSignUp(_ sender: Any) {
        performSegue(withIdentifier: "gotosignup", sender: self)
    }
    
    @IBAction func gotoSingIn() {
        performSegue(withIdentifier: "gotosignin", sender: self)
    }
    
}
