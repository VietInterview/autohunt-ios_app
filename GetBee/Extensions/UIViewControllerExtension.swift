//
//  UIViewControllerExtension.swift
//  ios-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit
import Toaster

extension UIViewController {
  // MARK: - Message Error
  func showMessage(title: String, message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  func showToast(title:String){
    let toast = Toast(text: title)
    toast.show()
  }
  func showHideView(view:UIView, isHidden:Bool){
    view.isHidden = isHidden
    if isHidden {
      view.gone()
    } else {
      view.visible()
    }
  }
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
