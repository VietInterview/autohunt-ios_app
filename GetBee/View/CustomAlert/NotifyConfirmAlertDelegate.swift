///**
/**
Created by: Hiep Nguyen Nghia on 2/1/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
protocol NotifyConfirmAlertDelegate: class {
    func okButtonTapped(id:Int, position:Int)
    func cancelButtonTapped()
}
