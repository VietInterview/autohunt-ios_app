///**
/**
Created by: Hiep Nguyen Nghia on 12/19/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

// To parse the JSON, add this file to your project and do:
//
//   var jobDetailCustomer = try? newJSONDecoder().decode(JobDetailCustomer.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseJobDetailCustomer { response in
//     if var jobDetailCustomer = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class JobDetailCustomer: Codable {
    var age, careerID, countColl, countCv: Int?
    var countGotoWork, countInterview, countOffer, countView: Int?
    var createBy: Int?
    var createDate: String?
    var currency: Int?
    var currentLevel: CurrentLevel?
    var customerID: Int?
    var customers: Customers?
    var educationLevel: CurrentLevel?
    var educationLevelID: Int?
    var expireDate: String?
    var fee, fromSalary, id, isHotjob: Int?
    var jobDescription: String?
    var jobLevel: Int?
    var jobRequirements, jobTitle: String?
    var language: CurrentLevel?
    var languageID: Int?
    var lstCareer: [CurrentLevel]?
    var lstCareerID, lstCountryID: String?
    var lstJobCity: [LstJobCity]?
    var lstJobCountry: [CurrentLevel]?
    var quantity, sex: Int?
    var specialTreatment: String?
    var status: Int?
    var submitDate, tag: String?
    var toSalary, updateBy: Int?
    var updateDate: String?
    var warranty: Int?
    var workExperience: String?
    var workingForm: CurrentLevel?
    var workingFormID: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case age
        case careerID = "careerId"
        case countColl, countCv, countGotoWork, countInterview, countOffer, countView, createBy, createDate, currency, currentLevel
        case customerID = "customerId"
        case customers, educationLevel
        case educationLevelID = "educationLevelId"
        case expireDate, fee, fromSalary, id, isHotjob, jobDescription, jobLevel, jobRequirements, jobTitle, language
        case languageID = "languageId"
        case lstCareer
        case lstCareerID = "lstCareerId"
        case lstCountryID = "lstCountryId"
        case lstJobCity, lstJobCountry, quantity, sex, specialTreatment, status, submitDate, tag, toSalary, updateBy, updateDate, warranty, workExperience, workingForm
        case workingFormID = "workingFormId"
    }
    
    init(age: Int?, careerID: Int?, countColl: Int?, countCv: Int?, countGotoWork: Int?, countInterview: Int?, countOffer: Int?, countView: Int?, createBy: Int?, createDate: String?, currency: Int?, currentLevel: CurrentLevel?, customerID: Int?, customers: Customers?, educationLevel: CurrentLevel?, educationLevelID: Int?, expireDate: String?, fee: Int?, fromSalary: Int?, id: Int?, isHotjob: Int?, jobDescription: String?, jobLevel: Int?, jobRequirements: String?, jobTitle: String?, language: CurrentLevel?, languageID: Int?, lstCareer: [CurrentLevel]?, lstCareerID: String?, lstCountryID: String?, lstJobCity: [LstJobCity]?, lstJobCountry: [CurrentLevel]?, quantity: Int?, sex: Int?, specialTreatment: String?, status: Int?, submitDate: String?, tag: String?, toSalary: Int?, updateBy: Int?, updateDate: String?, warranty: Int?, workExperience: String?, workingForm: CurrentLevel?, workingFormID: Int?) {
        self.age = age
        self.careerID = careerID
        self.countColl = countColl
        self.countCv = countCv
        self.countGotoWork = countGotoWork
        self.countInterview = countInterview
        self.countOffer = countOffer
        self.countView = countView
        self.createBy = createBy
        self.createDate = createDate
        self.currency = currency
        self.currentLevel = currentLevel
        self.customerID = customerID
        self.customers = customers
        self.educationLevel = educationLevel
        self.educationLevelID = educationLevelID
        self.expireDate = expireDate
        self.fee = fee
        self.fromSalary = fromSalary
        self.id = id
        self.isHotjob = isHotjob
        self.jobDescription = jobDescription
        self.jobLevel = jobLevel
        self.jobRequirements = jobRequirements
        self.jobTitle = jobTitle
        self.language = language
        self.languageID = languageID
        self.lstCareer = lstCareer
        self.lstCareerID = lstCareerID
        self.lstCountryID = lstCountryID
        self.lstJobCity = lstJobCity
        self.lstJobCountry = lstJobCountry
        self.quantity = quantity
        self.sex = sex
        self.specialTreatment = specialTreatment
        self.status = status
        self.submitDate = submitDate
        self.tag = tag
        self.toSalary = toSalary
        self.updateBy = updateBy
        self.updateDate = updateDate
        self.warranty = warranty
        self.workExperience = workExperience
        self.workingForm = workingForm
        self.workingFormID = workingFormID
    }
}

class CurrentLevel: Codable {
    var id: Int?
    var name: String?
    init(){}
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

class Customers: Codable {
    var address: String?
    var cityID: Int?
    var companyName, contactEmail, contactName, contactPhone: String?
    var countryID, createdBy: Int?
    var createdDate, descripstion: String?
    var humanResourcesID, id: Int?
    var logoImg: String?
    var salerID, status, updatedBy: Int?
    var updatedDate, videoLink: String?
    var workingTime: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case address
        case cityID = "cityId"
        case companyName, contactEmail, contactName, contactPhone
        case countryID = "countryId"
        case createdBy, createdDate, descripstion
        case humanResourcesID = "humanResourcesId"
        case id, logoImg
        case salerID = "salerId"
        case status, updatedBy, updatedDate, videoLink, workingTime
    }
    
    init(address: String?, cityID: Int?, companyName: String?, contactEmail: String?, contactName: String?, contactPhone: String?, countryID: Int?, createdBy: Int?, createdDate: String?, descripstion: String?, humanResourcesID: Int?, id: Int?, logoImg: String?, salerID: Int?, status: Int?, updatedBy: Int?, updatedDate: String?, videoLink: String?, workingTime: Int?) {
        self.address = address
        self.cityID = cityID
        self.companyName = companyName
        self.contactEmail = contactEmail
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.countryID = countryID
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.descripstion = descripstion
        self.humanResourcesID = humanResourcesID
        self.id = id
        self.logoImg = logoImg
        self.salerID = salerID
        self.status = status
        self.updatedBy = updatedBy
        self.updatedDate = updatedDate
        self.videoLink = videoLink
        self.workingTime = workingTime
    }
}

class LstJobCity: Codable {
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
    func responseJobDetailCustomer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<JobDetailCustomer>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

