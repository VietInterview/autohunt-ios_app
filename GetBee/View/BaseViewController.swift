///**
/**
 Created by: Hiep Nguyen Nghia on 12/9/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#042E51")
        self.navigationController?.navigationBar.barTintColor = StringUtils.shared.hexStringToUIColor(hex: "#042E51")
    }
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.barTintColor = StringUtils.shared.hexStringToUIColor(hex: "#042E51")
        self.navigationController?.navigationBar.tintColor = StringUtils.shared.hexStringToUIColor(hex: "#3C84F7")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 20)!]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Sets the status bar to visible when the view is about to disappear
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
        statusBar.visible()
    }
    func embeddedInNavigationController() -> UINavigationController {
        let nav = UINavigationController(rootViewController: self)
//        nav.navigationBar.barTintColor = StringUtils.shared.hexStringToUIColor(hex: "#FFD215")
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
