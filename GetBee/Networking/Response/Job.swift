// To parse the JSON, add this file to your project and do:
//
//   let job = try? newJSONDecoder().decode(Job.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseJob { response in
//     if let job = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class Job: Codable {
    var total: Int?
    var jobList: [JobList]?
    init(){
        
    }
    init(total: Int?, jobList: [JobList]?) {
        self.total = total
        self.jobList = jobList
    }
}

class JobList: Codable {
    var id, customerID: Int?
    var jobTitle: String?
    var careerID, jobLevel: Int?
    var jobLevelName, listcityName: String?
    var quantity, fromSalary, toSalary, currency: Int?
    var fee: Int?
    var jobDescription, jobRequirements, submitDate, expireDate: String?
    var status, isHotjob, countCv, countView: Int?
    var countColl, countInterview, countOffer, countGotoWork: Int?
    var createDate, createBy, updateDate, updateBy: String?
    var collStatus: Int?
    var companyName, companyImg, careerName: String?
    init(){
        
    }
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customerId"
        case jobTitle
        case careerID = "careerId"
        case jobLevel, jobLevelName, listcityName, quantity, fromSalary, toSalary, currency, fee, jobDescription, jobRequirements, submitDate, expireDate, status, isHotjob, countCv, countView, countColl, countInterview, countOffer, countGotoWork, createDate, createBy, updateDate, updateBy, collStatus, companyName, companyImg, careerName
    }
    
    init(id: Int?, customerID: Int?, jobTitle: String?, careerID: Int?, jobLevel: Int?, jobLevelName: String?, listcityName: String?, quantity: Int?, fromSalary: Int?, toSalary: Int?, currency: Int?, fee: Int?, jobDescription: String?, jobRequirements: String?, submitDate: String?, expireDate: String?, status: Int?, isHotjob: Int?, countCv: Int?, countView: Int?, countColl: Int?, countInterview: Int?, countOffer: Int?, countGotoWork: Int?, createDate: String?, createBy: String?, updateDate: String?, updateBy: String?, collStatus: Int?, companyName: String?, companyImg: String?, careerName: String?) {
        self.id = id
        self.customerID = customerID
        self.jobTitle = jobTitle
        self.careerID = careerID
        self.jobLevel = jobLevel
        self.jobLevelName = jobLevelName
        self.listcityName = listcityName
        self.quantity = quantity
        self.fromSalary = fromSalary
        self.toSalary = toSalary
        self.currency = currency
        self.fee = fee
        self.jobDescription = jobDescription
        self.jobRequirements = jobRequirements
        self.submitDate = submitDate
        self.expireDate = expireDate
        self.status = status
        self.isHotjob = isHotjob
        self.countCv = countCv
        self.countView = countView
        self.countColl = countColl
        self.countInterview = countInterview
        self.countOffer = countOffer
        self.countGotoWork = countGotoWork
        self.createDate = createDate
        self.createBy = createBy
        self.updateDate = updateDate
        self.updateBy = updateBy
        self.collStatus = collStatus
        self.companyName = companyName
        self.companyImg = companyImg
        self.careerName = careerName
    }
}

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
    func responseJob(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Job>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
