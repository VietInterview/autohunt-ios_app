///**
/**
Created by: Hiep Nguyen Nghia on 11/7/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
//   let job = try? newJSONDecoder().decode(Job.self, from: jsonData)
import Foundation
class Job: Codable {
    var total: Int?
    var jobList: [JobList]?
    init() {

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
    var jobDescription, submitDate, expireDate: String?
    var status, isHotjob, countCv, countColl: Int?
    var countInterview, countOffer, countGotoWork: Int?
    var createDate, createBy, updateDate, updateBy: String?
    var collStatus: Int?
    var companyName: String?
    var companyImg: JSONNull?
    var careerName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customerId"
        case jobTitle
        case careerID = "careerId"
        case jobLevel, jobLevelName, listcityName, quantity, fromSalary, toSalary, currency, fee, jobDescription, submitDate, expireDate, status, isHotjob, countCv, countColl, countInterview, countOffer, countGotoWork, createDate, createBy, updateDate, updateBy, collStatus, companyName, companyImg, careerName
    }
    init() {
        
    }
    init(id: Int?, customerID: Int?, jobTitle: String?, careerID: Int?, jobLevel: Int?, jobLevelName: String?, listcityName: String?, quantity: Int?, fromSalary: Int?, toSalary: Int?, currency: Int?, fee: Int?, jobDescription: String?, submitDate: String?, expireDate: String?, status: Int?, isHotjob: Int?, countCv: Int?, countColl: Int?, countInterview: Int?, countOffer: Int?, countGotoWork: Int?, createDate: String?, createBy: String?, updateDate: String?, updateBy: String?, collStatus: Int?, companyName: String?, companyImg: JSONNull?, careerName: String?) {
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
        self.submitDate = submitDate
        self.expireDate = expireDate
        self.status = status
        self.isHotjob = isHotjob
        self.countCv = countCv
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

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

