///**
/**
Created by: Hiep Nguyen Nghia on 11/12/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
class MyChoose: Codable {
    var id: Int
    var name: String
    var isStatus: Bool
    var isCarrer: Bool
    var isCity: Bool
    var countryID: Int
    init(id: Int, name: String, isStatus: Bool, isCarrer: Bool, isCity: Bool) {
        self.id = id
        self.name = name
        self.isStatus = isStatus
        self.isCarrer = isCarrer
        self.isCity = isCity
        self.countryID = 0
    }
    init(id: Int, name: String, isStatus: Bool, isCarrer: Bool, isCity: Bool, countryID:Int) {
        self.id = id
        self.name = name
        self.isStatus = isStatus
        self.isCarrer = isCarrer
        self.isCity = isCity
        self.countryID = countryID
    }
}
