///**
/**
 Created by: Hiep Nguyen Nghia on 11/13/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
//import UIKit

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
}
