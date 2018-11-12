///**
/**
Created by: Hiep Nguyen Nghia on 11/7/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
//   let getMyProfile = try? newJSONDecoder().decode(GetMyProfile.self, from: jsonData)
import Foundation
class GetMyProfile: Codable {
    let addressColl, careerColl: String?
    let desideratedCareer: [DesideratedCareer]?
    let emailColl, fullNameColl: String?
    let idColl: Int?
    let phoneColl: String?
    
    init(addressColl: String?, careerColl: String?, desideratedCareer: [DesideratedCareer]?, emailColl: String?, fullNameColl: String?, idColl: Int?, phoneColl: String?) {
        self.addressColl = addressColl
        self.careerColl = careerColl
        self.desideratedCareer = desideratedCareer
        self.emailColl = emailColl
        self.fullNameColl = fullNameColl
        self.idColl = idColl
        self.phoneColl = phoneColl
    }
}

class DesideratedCareer: Codable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
