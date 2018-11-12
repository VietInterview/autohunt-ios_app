///**
/**
Created by: Hiep Nguyen Nghia on 11/12/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
class CarrerCityStatus: Codable {
    var id: Int?
    var name: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
