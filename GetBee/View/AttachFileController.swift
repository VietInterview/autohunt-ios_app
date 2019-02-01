///**
/**
Created by: Hiep Nguyen Nghia on 2/1/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class AttachFileController: BaseViewController {

    @IBOutlet weak var viewAttach: UIView!
    convenience init() {
        self.init(nibName: "AttachFileController", bundle: nil)
    }
    
    func setArgument() -> AttachFileController{
        let vc = self.assignValueToController(nameController: "AttachFileController") as! AttachFileController
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tải lên hồ sơ"
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "tick_blue.png"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.tappedMe), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.viewAttach.addBorder(color: StringUtils.shared.hexStringToUIColor(hex: "#D6E1EA"), weight: 1)
        self.viewAttach.addRadius()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func tappedMe(sender: UITapGestureRecognizer){
    }
}
