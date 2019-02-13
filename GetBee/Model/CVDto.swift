///**
/**
Created by: Hiep Nguyen Nghia on 2/13/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var cVDto = try? newJSONDecoder().decode(CVDto.self, from: jsonData)

import Foundation

class CVDto: Codable {
    var email: String?
    var fullName: String?
    var id: Int?
    var lstCareer: [LstCareerCVDto]?
    var phone: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case fullName = "fullName"
        case id = "id"
        case lstCareer = "lstCareer"
        case phone = "phone"
    }
    
    init(email: String?, fullName: String?, id: Int?, lstCareer: [LstCareerCVDto]?, phone: String?) {
        self.email = email
        self.fullName = fullName
        self.id = id
        self.lstCareer = lstCareer
        self.phone = phone
    }
}

class LstCareerCVDto: Codable {
    var id: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
