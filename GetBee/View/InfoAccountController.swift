///**
/**
Created by: Hiep Nguyen Nghia on 10/14/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class InfoAccountController: UIViewController {
    @IBOutlet weak var mViewCarrerHunt: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "tick_black.png"), for: UIControlState.normal)
        //        button.addTarget(self, action:#selector(ViewController.callMethod), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
         self.navigationController?.navigationBar.tintColor = UIColor.black
       
        let gestureSwift2AndHigher = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.mViewCarrerHunt.addGestureRecognizer(gestureSwift2AndHigher)
        
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarrerOrCityController") as! CarrerOrCityController
        vc.title = "Ngành Nghề"
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    @IBAction func changePassTouchup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
        vc.title = "Thay đổi mật khẩu"
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    

}
