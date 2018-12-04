///**
/**
 Created by: Hiep Nguyen Nghia on 11/13/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
import UIKit

class StringUtils:NSObject {
    static let shared = StringUtils()
    func stringFromHtml(string: String) -> String? {
        let data = string.data(using: String.Encoding.unicode)! // mind "!"
        let attrStr = try? NSAttributedString( // do catch
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        return attrStr!.string
    }
    func genStringCurrency(value: Int) -> String {
        var someNumber = ""
        switch value {
        case 1:
            someNumber="VND"
        case 2:
            someNumber="USD"
        case 3:
            someNumber="JPY"
        default:
            print("Fallback option")
        }
        return someNumber
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func genStringLan(value: Int) -> String {
        var someNumber = ""
        switch value {
        case 1:
            someNumber=NSLocalizedString("good", comment: "")
        case 2:
            someNumber=NSLocalizedString("rather", comment: "")
        case 3:
            someNumber=NSLocalizedString("medium", comment: "")
        case 4:
            someNumber=NSLocalizedString("least", comment: "")
        default:
            print("Fallback option")
        }
        return someNumber
    }
    func genColor(valueStatus: Int) -> UIColor {
        var color: UIColor = .gray
        switch valueStatus {
        case 0:
            color = hexStringToUIColor(hex: "#ADADAD")
        case 1:
            color = hexStringToUIColor(hex: "#E8C21F")
        case 2:
            color = hexStringToUIColor(hex: "#E8C21F")
        case 3:
            color = hexStringToUIColor(hex: "#E8C21F")
        case 4:
            color = hexStringToUIColor(hex: "#ADADAD")
        case 5:
            color = hexStringToUIColor(hex: "#DB4443")
        case 6:
            color = hexStringToUIColor(hex: "#54CE4E")
        case 7:
            color = hexStringToUIColor(hex: "#54CE4E")
        case 8:
            color = hexStringToUIColor(hex: "#54CE4E")
        case 9:
            color = hexStringToUIColor(hex: "#E8C21F")
        default:
            color = hexStringToUIColor(hex: "#ADADAD")
        }
        return color
    }
    func genStringHumanResource(value: Int) -> String {
        var statusString = ""
        switch value {
        case 1:
            statusString=NSLocalizedString("below_50", comment: "")
        case 2:
            statusString=NSLocalizedString("from_50_to_100", comment: "")
        case 3:
            statusString=NSLocalizedString("above_100", comment: "")
        case 4:
            statusString=NSLocalizedString("above_500", comment: "")
        case 5:
            statusString=NSLocalizedString("average", comment: "")
        default:
            statusString=""
        }
        return statusString
    }
    func genStringStatus(valueStatus: Int) -> String {
        var statusString = ""
        switch valueStatus {
        case 0:
            statusString=NSLocalizedString("not_send", comment: "")
        case 1:
            statusString=NSLocalizedString("sent", comment: "")
        case 2:
            statusString=NSLocalizedString("sent", comment: "")
        case 3:
            statusString=NSLocalizedString("seen", comment: "")
        case 4:
            statusString=NSLocalizedString("not_accept", comment: "")
        case 5:
            statusString=NSLocalizedString("invite_interview", comment: "")
        case 6:
            statusString=NSLocalizedString("interviewd", comment: "")
        case 7:
            statusString=NSLocalizedString("offered", comment: "")
        case 8:
            statusString=NSLocalizedString("go_to_work", comment: "")
        case 9:
            statusString=NSLocalizedString("contract", comment: "")
        default:
             statusString=NSLocalizedString("not_accept", comment: "")
        }
        return statusString
    }
    func currencyFormat(value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        if let formattedTipAmount = formatter.string(from: value as NSNumber) {
            return formattedTipAmount
        }
        return ""
    }
    func checkEmpty(value: String?) -> String {
        if let string = value{
            return string
        }
        return ""
    }
    func checkEmptyInt(value: Int?) -> Int {
        if let string = value{
            return string
        }
        return 0
    }
    func prettyPrint(with json: [String:Any]) -> String{
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string! as String
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
