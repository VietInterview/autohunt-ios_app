///**
/**
 Created by: Hiep Nguyen Nghia on 11/13/18
 Copyright (c) 2018 Vietinterview. All rights reserved.
 */

import Foundation
class DateUtils: NSObject {
    static let shared = DateUtils()
    public func convertToShowFormatDate(dateString: String) -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let serverDate: Date = dateFormatterDate.date(from: dateString)!
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "dd/MM/yyyy"
        let newDate: String = dateFormatterString.string(from: serverDate)
        return newDate
    }
    public func convertToShowFormatDate2(dateString: String) -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+0000"
        let serverDate: Date = dateFormatterDate.date(from: dateString)!
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "dd/MM/yyyy"
        let newDate: String = dateFormatterString.string(from: serverDate)
        return newDate
    }
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let mDate = dt {
            return dateFormatter.string(from: dt!)
        } else { return "" }
    }
    public func convertFormatDateFull(dateString: String) -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyyMMdd"
        let serverDate: Date = dateFormatterDate.date(from: dateString)!
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "dd/MM/yyyy"
        let newDate: String = dateFormatterString.string(from: serverDate)
        return newDate
    }
    public func convertFormatDateAMPM(dateString: String) -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "dd/MM/yyyy HH:mm a"
        let serverDate: Date = dateFormatterDate.date(from: dateString)!
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "dd/MM/yyyy"
        let newDate: String = dateFormatterString.string(from: serverDate)
        return newDate
    }
    public func convertFormatDate(dateString: String) -> String {
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyyMM"
        let serverDate: Date = dateFormatterDate.date(from: dateString)!
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM/yyyy"
        let newDate: String = dateFormatterString.string(from: serverDate)
        return newDate
    }
}
