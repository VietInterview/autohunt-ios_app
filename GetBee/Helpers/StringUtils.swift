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
    func genString(value: Int) -> String {
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
    func genStringLan(value: Int) -> String {
        var someNumber = ""
        switch value {
        case 1:
            someNumber="Tốt"
        case 2:
            someNumber="Khá"
        case 3:
            someNumber="Trung bình"
        case 4:
            someNumber="Kém"
        default:
            print("Fallback option")
        }
        return someNumber
    }
    func genColor(valueStatus: Int) -> UIColor {
        var color: UIColor = .gray
        switch valueStatus {
        case 0:
            color = .gray
        case 1:
            color = .yellow
        case 2:
            color = .yellow
        case 3:
            color = .yellow
        case 4:
            color = .gray
        case 5:
            color = .red
        case 6:
            color = .green
        case 7:
            color = .green
        case 8:
            color = .green
        case 9:
            color = .yellow
        default:
            color = .gray
        }
        return color
    }
    func genStringHumanResource(value: Int) -> String {
        var statusString = ""
        switch value {
        case 1:
            statusString="Dưới 50 người"
        case 2:
            statusString="Từ 50 - 100 người"
        case 3:
            statusString="Lớn hơn 100 người"
        case 4:
            statusString="Lớn hơn 500 người"
        case 5:
            statusString="Trung bình"
        default:
            statusString=""
        }
        return statusString
    }
    func genStringStatus(valueStatus: Int) -> String {
        var statusString = ""
        switch valueStatus {
        case 0:
            statusString="Chưa gửi"
        case 1:
            statusString="Đã gửi"
        case 2:
            statusString="Đã gửi"
        case 3:
            statusString="Đã xem"
        case 4:
            statusString="Từ chối"
        case 5:
            statusString="Mời phỏng vấn"
        case 6:
            statusString="Đã phỏng vấn"
        case 7:
            statusString="Được tuyển dụng"
        case 8:
            statusString="Đi làm"
        case 9:
            statusString="Ký hợp đồng"
        default:
             statusString="Từ chối"
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
    
    func prettyPrint(with json: [String:Any]) -> String{
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string as! String
    }
}
