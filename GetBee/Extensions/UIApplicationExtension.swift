//
//  UIApplicationExtension.swift
//  ios-base
//
//  Created by Agustina Chaer on 24/10/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func showNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    }
    
    class func hideNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        LoadingOverlay.shared.hideOverlayView()
    }
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
