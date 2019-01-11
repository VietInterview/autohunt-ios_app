//
//  StringExtension.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation

extension String {
  var isAlphanumericWithNoSpaces: Bool {
    return rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted) == nil
  }
  
  var hasPunctuationCharacters: Bool {
    return rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil
  }
  
  var hasNumbers: Bool {
    return rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
  }
  
  @available(iOS, deprecated: 3.2, message: "Use String.count instead")
  var length: Int {
    return characters.count
  }
  
//  var localized: String {
//    return self.localize()
//  }
    
  func localize(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  var validFilename: String {
    guard !isEmpty else { return "emptyFilename" }
    return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "emptyFilename"
  }
  
  //Regex fulfill RFC 5322 Internet Message format
  func isEmailFormatted() -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?")
    return predicate.evaluate(with: self)
  }
  func index(at: Int) -> Index {
    return self.index(startIndex, offsetBy: at)
  }
  
  func substring(from: Int) -> String {
    let fromIndex = index(at: from)
    return substring(from: fromIndex)
  }
  
  func substring(to: Int) -> String {
    let toIndex = index(at: to)
    return substring(to: toIndex)
  }
  
  func substring(with r:Range<Int>) -> String {
    let startIndex  = index(at: r.lowerBound)
    let endIndex    = index(at: r.upperBound)
    return substring(with: startIndex..<endIndex)
  }
  func currencyInputFormatting() -> String {
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    formatter.usesGroupingSeparator = true
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    var amountWithPrefix = self
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double / 100))
    if let formattedTipAmount = formatter.string(from: number as NSNumber) {
      return formattedTipAmount
    }
    return ""
  }
  func currencyInputFormattingNumber() -> NSNumber {
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale.current
    formatter.usesGroupingSeparator = true
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    var amountWithPrefix = self
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double / 100))
    guard number != 0 as NSNumber else {
      return 0
    }
    return number
  }
}
