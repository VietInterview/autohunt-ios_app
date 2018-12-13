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
  func addRadius( weight: CGFloat = 5){
    layer.masksToBounds = true
    layer.cornerRadius = weight
  }
  func setRoundBorders(_ cornerRadius: CGFloat = 5.0) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
  }
  func shadowView(opacity:Float = 0.5, radius: CGFloat = 5){
    layer.shadowColor = StringUtils.shared.hexStringToUIColor(hex: "#191830").cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = radius
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
