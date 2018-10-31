///**
/**
Created by: Hiep Nguyen Nghia on 10/14/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class ChangePasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "tick_black.png"), for: UIControlState.normal)
//        button.addTarget(self, action:#selector(ViewController.callMethod), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
