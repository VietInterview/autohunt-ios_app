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
  func showMessageErrorApi() {
   self.showMessage(title: NSLocalizedString("noti_title", comment: ""), message: NSLocalizedString("error_please_try", comment: ""))
  }
  func showMessageFull(title: String, message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil,handlerCancel: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Không", style: UIAlertActionStyle.default, handler: handlerCancel))
    alert.addAction(UIAlertAction(title: "Có", style: UIAlertActionStyle.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  func showToast(title:String){
    let toast = Toast(text: title)
    toast.show()
  }
  func showHideView(view:UIView, isHidden:Bool){
    //    view.isHidden = isHidden
    UIView.animate(withDuration: 3, animations: {
      view.alpha = 1
    }, completion: {
      finished in
      view.isHidden = isHidden
    })
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
  func assignValueToController(nameController:String) -> UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController? = storyboard.instantiateViewController(withIdentifier: nameController)
    return viewController!
  }
  func pushViewController(controller:UIViewController){
    navigationController?.pushViewController(controller, animated: true)
  }
}
