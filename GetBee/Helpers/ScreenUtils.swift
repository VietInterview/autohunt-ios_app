///**
/**
 Created by: Hiep Nguyen Nghia on 11/19/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
import UIKit

class ScreenUtils:NSObject {
    static let shared = ScreenUtils()
    func getScreenWidth() -> CGFloat? {
        return UIScreen.main.bounds.width
    }
    func getScreenHeight() -> CGFloat? {
        return UIScreen.main.bounds.height
    }
}
