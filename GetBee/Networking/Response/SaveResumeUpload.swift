///**
/**
Created by: Hiep Nguyen Nghia on 2/13/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var saveResumeUpload = try? newJSONDecoder().decode(SaveResumeUpload.self, from: jsonData)

import Foundation

class SaveResumeUpload: Codable {
    var total: Int?
    var cvList: [CvListUpload]?
    init(){}
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case cvList = "cvList"
    }
    
    init(total: Int?, cvList: [CvListUpload]?) {
        self.total = total
        self.cvList = cvList
    }
}

class CvListUpload: Codable {
    var id: Int?
    var fullName: String?
    var email: String?
    var phone: String?
    var fileURL: String?
    var status: Int?
    var cvID: Int?
    var createdBy: String?
    var createdDate: String?
    var updatedBy: String?
    var updatedDate: String?
    var careerName: String?
    var createdByName: String?
    var lstCareer: [LstCareerUpload]?
    init(){}
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "fullName"
        case email = "email"
        case phone = "phone"
        case fileURL = "fileUrl"
        case status = "status"
        case cvID = "cvId"
        case createdBy = "createdBy"
        case createdDate = "createdDate"
        case updatedBy = "updatedBy"
        case updatedDate = "updatedDate"
        case careerName = "careerName"
        case createdByName = "createdByName"
        case lstCareer = "lstCareer"
    }
    
    init(id: Int?, fullName: String?, email: String?, phone: String?, fileURL: String?, status: Int?, cvID: Int?, createdBy: String?, createdDate: String?, updatedBy: String?, updatedDate: String?, careerName: String?, createdByName: String?, lstCareer: [LstCareerUpload]?) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.fileURL = fileURL
        self.status = status
        self.cvID = cvID
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.updatedBy = updatedBy
        self.updatedDate = updatedDate
        self.careerName = careerName
        self.createdByName = createdByName
        self.lstCareer = lstCareer
    }
}

class LstCareerUpload: Codable {
    var id: Int?
    var name: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
