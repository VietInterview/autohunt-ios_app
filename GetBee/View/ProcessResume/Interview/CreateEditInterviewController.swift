///**
/**
 Created by: Hiep Nguyen Nghia on 12/22/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import UIKit

class CreateEditInterviewController: BaseViewController {
    var id:Int = 0
    var value:String = ""
    convenience init() {
        self.init(nibName: "CreateEditInterviewController", bundle: nil)
    }
    func setArgument(id:Int, value:String) -> CreateEditInterviewController{
        let vc = self.assignValueToController(nameController: "CreateEditInterviewController") as! CreateEditInterviewController
        vc.id = id
        vc.value = value
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.value) \(self.id)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
