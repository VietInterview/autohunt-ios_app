///**
/**
Created by: Hiep Nguyen Nghia on 2/13/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
import UIKit
import Foundation
extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}
