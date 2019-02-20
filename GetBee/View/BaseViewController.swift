///**
/**
 Created by: Hiep Nguyen Nghia on 12/9/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = StringUtils.hexStringToUIColor(hex: "#042E51")
        self.navigationController?.navigationBar.barTintColor = StringUtils.hexStringToUIColor(hex: "#042E51")
    }
    func showBackButton( nameImage:String = "back"){
        let yourBackImage = UIImage(named: nameImage)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    func showRightButton( nameImage:String = "tick_blue.png"){
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: nameImage), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.tappedMe), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc func tappedMe(sender: UITapGestureRecognizer){
        debugLog(object: "press")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = StringUtils.hexStringToUIColor(hex: "#042E51")
        self.navigationController?.navigationBar.tintColor = StringUtils.hexStringToUIColor(hex: "#3C84F7")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 18)!]
    }
    override func viewWillAppear(_ animated: Bool) {
        // Sets the status bar to hidden when the view has finished appearing
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
        if #available(iOS 10.0, *) {
            UIApplication.shared.isStatusBarHidden = false
        }
        statusBar.visible()
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    func embeddedInNavigationController() -> UINavigationController {
        let nav = UINavigationController(rootViewController: self)
        //        nav.navigationBar.barTintColor = StringUtils.hexStringToUIColor(hex: "#FFD215")
        //        nav.navigationBar.isTranslucent = false
        //        nav.navigationBar.isOpaque = false
        //        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        nav.navigationBar.backgroundColor = UIColor.white
        //        nav.navigationBar.barTintColor = AppColors.violet
        //        nav.navigationBar.shadowImage = UIImage()
        //        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        return nav
    }
}
