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
}
