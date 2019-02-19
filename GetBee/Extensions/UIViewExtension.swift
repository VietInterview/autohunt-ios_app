//
//  UIViewExtension.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  // MARK: - Instance methods
  //Change the default values for params as you wish
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 0.5) {
    layer.borderColor = color.cgColor
    layer.borderWidth = weight
  }
  func addRadius(weight: CGFloat = 5, isBound:Bool = true){
    layer.masksToBounds = isBound
    layer.cornerRadius = weight
  }
  func addBorderRadius(color: UIColor = UIColor.black, weight: CGFloat = 0.5, weightRadius: CGFloat = 5) {
    layer.borderColor = color.cgColor
    layer.borderWidth = weight
    layer.masksToBounds = true
    layer.cornerRadius = weightRadius
  }
  func setRoundBorders(_ cornerRadius: CGFloat = 5.0) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
  }
  func hideWithAnimation(hidden: Bool) {
    UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
      self.isHidden = hidden
    })
  }
  func shadowView(opacity:Float = 0.5, radius: CGFloat = 5, color:String = "#042E51"){
    layer.shadowColor = StringUtils.hexStringToUIColor(hex: color).cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = radius
  }
  
  func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0
    
    UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.isHidden = false
      self.alpha = 1.0
    }, completion: completion)
  }
  
  func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    self.alpha = 1.0
    
    UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.alpha = 0.0
    }) { (completed) in
      self.isHidden = true
      completion(true)
    }
  }
}

extension Array where Element: UIView {
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    for view in self {
      view.addBorder(color: color, weight: weight)
    }
  }
  
  func roundBorders(cornerRadius: CGFloat = 10.0) {
    for view in self {
      view.setRoundBorders(cornerRadius)
    }
  }
}
