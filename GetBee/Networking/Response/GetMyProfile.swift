///**
/**
Created by: Hiep Nguyen Nghia on 11/7/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   let getMyProfile = try? newJSONDecoder().decode(GetMyProfile.self, from: jsonData)

import Foundation

class GetMyProfile: Codable {
    let addressColl: String?
    let birthday: Int?
    let careerColl: String?
    let cities: [CityMyProfile]?
    let code, companyName: String?
    let contractDate: Int?
    let countries, desideratedCareer: [CountryMyProfile]?
    let emailColl, fullNameColl: String?
    let idColl: Int?
    let imageURL, phoneColl: String?
    
    enum CodingKeys: String, CodingKey {
        case addressColl, birthday, careerColl, cities, code, companyName, contractDate, countries, desideratedCareer, emailColl, fullNameColl, idColl
        case imageURL = "imageUrl"
        case phoneColl
    }
    
    init(addressColl: String?, birthday: Int?, careerColl: String?, cities: [CityMyProfile]?, code: String?, companyName: String?, contractDate: Int?, countries: [CountryMyProfile]?, desideratedCareer: [CountryMyProfile]?, emailColl: String?, fullNameColl: String?, idColl: Int?, imageURL: String?, phoneColl: String?) {
        self.addressColl = addressColl
        self.birthday = birthday
        self.careerColl = careerColl
        self.cities = cities
        self.code = code
        self.companyName = companyName
        self.contractDate = contractDate
        self.countries = countries
        self.desideratedCareer = desideratedCareer
        self.emailColl = emailColl
        self.fullNameColl = fullNameColl
        self.idColl = idColl
        self.imageURL = imageURL
        self.phoneColl = phoneColl
    }
}

class CityMyProfile: Codable {
    let countryID: Int?
    let enName: String?
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case enName, id, name
    }
    
    init(countryID: Int?, enName: String?, id: Int?, name: String?) {
        self.countryID = countryID
        self.enName = enName
        self.id = id
        self.name = name
    }
}

class CountryMyProfile: Codable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
