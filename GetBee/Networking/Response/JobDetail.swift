///**
/**
Created by: Hiep Nguyen Nghia on 11/12/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

// To parse the JSON, add this file to your project and do:
//
//   let jobDetail = try? newJSONDecoder().decode(JobDetail.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseJobDetail { response in
//     if let jobDetail = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class JobDetail: Codable {
    let careerID: Int?
    let careerName: String?
    let collStatus: Int?
    let companyImg, companyName: String?
    let countColl, countCv, countGotoWork, countInterview: Int?
    let countOffer, countView, currency: Int?
    let currencyName: String?
    let customerID: Int?
    let expireDate: String?
    let fee, fromSalary, id, isHotjob: Int?
    let jobDescription: String?
    let jobLevel: Int?
    let jobLevelName, jobRequirements, jobTitle, listcityName: String?
    let lstJobApply: [LstJobApply]?
    let myCountCv, myCountGotoWork, myCountInterview, myCountInviteInterview: Int?
    let myCountOffer, quantity, status: Int?
    let submitDate: String?
    let toSalary: Int?
    
    enum CodingKeys: String, CodingKey {
        case careerID = "careerId"
        case careerName, collStatus, companyImg, companyName, countColl, countCv, countGotoWork, countInterview, countOffer, countView, currency, currencyName
        case customerID = "customerId"
        case expireDate, fee, fromSalary, id, isHotjob, jobDescription, jobLevel, jobLevelName, jobRequirements, jobTitle, listcityName, lstJobApply, myCountCv, myCountGotoWork, myCountInterview, myCountInviteInterview, myCountOffer, quantity, status, submitDate, toSalary
    }
    
    init(careerID: Int?, careerName: String?, collStatus: Int?, companyImg: String?, companyName: String?, countColl: Int?, countCv: Int?, countGotoWork: Int?, countInterview: Int?, countOffer: Int?, countView: Int?, currency: Int?, currencyName: String?, customerID: Int?, expireDate: String?, fee: Int?, fromSalary: Int?, id: Int?, isHotjob: Int?, jobDescription: String?, jobLevel: Int?, jobLevelName: String?, jobRequirements: String?, jobTitle: String?, listcityName: String?, lstJobApply: [LstJobApply]?, myCountCv: Int?, myCountGotoWork: Int?, myCountInterview: Int?, myCountInviteInterview: Int?, myCountOffer: Int?, quantity: Int?, status: Int?, submitDate: String?, toSalary: Int?) {
        self.careerID = careerID
        self.careerName = careerName
        self.collStatus = collStatus
        self.companyImg = companyImg
        self.companyName = companyName
        self.countColl = countColl
        self.countCv = countCv
        self.countGotoWork = countGotoWork
        self.countInterview = countInterview
        self.countOffer = countOffer
        self.countView = countView
        self.currency = currency
        self.currencyName = currencyName
        self.customerID = customerID
        self.expireDate = expireDate
        self.fee = fee
        self.fromSalary = fromSalary
        self.id = id
        self.isHotjob = isHotjob
        self.jobDescription = jobDescription
        self.jobLevel = jobLevel
        self.jobLevelName = jobLevelName
        self.jobRequirements = jobRequirements
        self.jobTitle = jobTitle
        self.listcityName = listcityName
        self.lstJobApply = lstJobApply
        self.myCountCv = myCountCv
        self.myCountGotoWork = myCountGotoWork
        self.myCountInterview = myCountInterview
        self.myCountInviteInterview = myCountInviteInterview
        self.myCountOffer = myCountOffer
        self.quantity = quantity
        self.status = status
        self.submitDate = submitDate
        self.toSalary = toSalary
    }
}

class LstJobApply: Codable {
    let createdDate: String?
    let cvID: Int?
    let fullName: String?
    let id, status: Int?
    
    enum CodingKeys: String, CodingKey {
        case createdDate
        case cvID = "cvId"
        case fullName, id, status
    }
    
    init(createdDate: String?, cvID: Int?, fullName: String?, id: Int?, status: Int?) {
        self.createdDate = createdDate
        self.cvID = cvID
        self.fullName = fullName
        self.id = id
        self.status = status
    }
}

//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

// MARK: - Alamofire response handlers

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
    func responseJobDetail(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<JobDetail>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
