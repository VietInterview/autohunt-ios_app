///**
/**
Created by: Hiep Nguyen Nghia on 1/7/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var profileCustomer = try? newJSONDecoder().decode(ProfileCustomer.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProfileCustomer { response in
//     if var profileCustomer = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ProfileCustomer: Codable {
    var address: String?
    var careerSelectedItems: [CareerSelectedItem]?
    var city: [CityCustomer]?
    var companyName, contactEmail, contactName, contactPhone: String?
    var country: [Country]?
    var customerImg: [CustomerImg]?
    var customerWelfare: [CustomerWelfare]?
    var descripstion: String?
    var humanResources: [Country]?
    var id: Int?
    var logoImg: String?
    var saleAssignDto: SaleAssignDto?
    var salerID: Int?
    var timeservingSelectedItems: [Country]?
    var videoLink: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case address, careerSelectedItems, city, companyName, contactEmail, contactName, contactPhone, country, customerImg, customerWelfare, descripstion, humanResources, id, logoImg, saleAssignDto
        case salerID = "salerId"
        case timeservingSelectedItems, videoLink
    }
    
    init(address: String?, careerSelectedItems: [CareerSelectedItem]?, city: [CityCustomer]?, companyName: String?, contactEmail: String?, contactName: String?, contactPhone: String?, country: [Country]?, customerImg: [CustomerImg]?, customerWelfare: [CustomerWelfare]?, descripstion: String?, humanResources: [Country]?, id: Int?, logoImg: String?, saleAssignDto: SaleAssignDto?, salerID: Int?, timeservingSelectedItems: [Country]?, videoLink: String?) {
        self.address = address
        self.careerSelectedItems = careerSelectedItems
        self.city = city
        self.companyName = companyName
        self.contactEmail = contactEmail
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.country = country
        self.customerImg = customerImg
        self.customerWelfare = customerWelfare
        self.descripstion = descripstion
        self.humanResources = humanResources
        self.id = id
        self.logoImg = logoImg
        self.saleAssignDto = saleAssignDto
        self.salerID = salerID
        self.timeservingSelectedItems = timeservingSelectedItems
        self.videoLink = videoLink
    }
}

class CareerSelectedItem: Codable {
    var careerID, customerID, id: Int?
    var lstCareer: [Country]?
    var name: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case careerID = "careerId"
        case customerID = "customerId"
        case id, lstCareer, name
    }
    
    init(careerID: Int?, customerID: Int?, id: Int?, lstCareer: [Country]?, name: String?) {
        self.careerID = careerID
        self.customerID = customerID
        self.id = id
        self.lstCareer = lstCareer
        self.name = name
    }
}

class Country: Codable {
    var id: Int?
    var name: String?
    init(){}
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

class CityCustomer: Codable {
    var countryID: Int?
    var enName: String?
    var id: Int?
    var name: String?
    init(){}
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

class CustomerImg: Codable {
    var customerID, id: Int?
    var imageURL: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case id
        case imageURL = "imageUrl"
    }
    
    init(customerID: Int?, id: Int?, imageURL: String?) {
        self.customerID = customerID
        self.id = id
        self.imageURL = imageURL
    }
}

class CustomerWelfare: Codable {
    var customerID, id: Int?
    var lstWelfare: [Country]?
    var name, note: String?
    var welfareID: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case id, lstWelfare, name, note
        case welfareID = "welfareId"
    }
    
    init(customerID: Int?, id: Int?, lstWelfare: [Country]?, name: String?, note: String?, welfareID: Int?) {
        self.customerID = customerID
        self.id = id
        self.lstWelfare = lstWelfare
        self.name = name
        self.note = note
        self.welfareID = welfareID
    }
}

class SaleAssignDto: Codable {
    var firstName: String?
    var id: Int?
    var login: String?
    init(){}
    init(firstName: String?, id: Int?, login: String?) {
        self.firstName = firstName
        self.id = id
        self.login = login
    }
}

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseProfileCustomer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ProfileCustomer>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
