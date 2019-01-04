///**
/**
Created by: Hiep Nguyen Nghia on 1/2/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var detailProcessResume = try? newJSONDecoder().decode(DetailProcessResume.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDetailProcessResume { response in
//     if var detailProcessResume = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class DetailProcessResume: Codable {
    var cvID: Int?
    var cvProcessInfo: CvProcessInfo?
    var jobCvGotoWorkDto: JobCvGotoWorkDto?
    var jobID: Int?
    var lstInterviewHis: [LstInterviewHi]?
    var lstOfferHis: [LstOfferHi]?
    var status: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case cvProcessInfo, jobCvGotoWorkDto
        case jobID = "jobId"
        case lstInterviewHis, lstOfferHis, status
    }
    
    init(cvID: Int?, cvProcessInfo: CvProcessInfo?, jobCvGotoWorkDto: JobCvGotoWorkDto?, jobID: Int?, lstInterviewHis: [LstInterviewHi]?, lstOfferHis: [LstOfferHi]?, status: Int?) {
        self.cvID = cvID
        self.cvProcessInfo = cvProcessInfo
        self.jobCvGotoWorkDto = jobCvGotoWorkDto
        self.jobID = jobID
        self.lstInterviewHis = lstInterviewHis
        self.lstOfferHis = lstOfferHis
        self.status = status
    }
}

class CvProcessInfo: Codable {
    var birthday: Int?
    var collEmail: String?
    var collID: Int?
    var collName, collPhone: String?
    var currencyID: Int?
    var currencyName: String?
    var cvID, cvType: Int?
    var educationLevelName, fullName, pictureURL, positionName: String?
    var reasonRejectID: Int?
    var reasonRejectName, rejectNote: String?
    var rejectStep, salary, status, supporterID: Int?
    var workAddress, yearsExperienceName: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case birthday, collEmail
        case collID = "collId"
        case collName, collPhone
        case currencyID = "currencyId"
        case currencyName
        case cvID = "cvId"
        case cvType, educationLevelName, fullName
        case pictureURL = "pictureUrl"
        case positionName
        case reasonRejectID = "reasonRejectId"
        case reasonRejectName, rejectNote, rejectStep, salary, status
        case supporterID = "supporterId"
        case workAddress, yearsExperienceName
    }
    
    init(birthday: Int?, collEmail: String?, collID: Int?, collName: String?, collPhone: String?, currencyID: Int?, currencyName: String?, cvID: Int?, cvType: Int?, educationLevelName: String?, fullName: String?, pictureURL: String?, positionName: String?, reasonRejectID: Int?, reasonRejectName: String?, rejectNote: String?, rejectStep: Int?, salary: Int?, status: Int?, supporterID: Int?, workAddress: String?, yearsExperienceName: String?) {
        self.birthday = birthday
        self.collEmail = collEmail
        self.collID = collID
        self.collName = collName
        self.collPhone = collPhone
        self.currencyID = currencyID
        self.currencyName = currencyName
        self.cvID = cvID
        self.cvType = cvType
        self.educationLevelName = educationLevelName
        self.fullName = fullName
        self.pictureURL = pictureURL
        self.positionName = positionName
        self.reasonRejectID = reasonRejectID
        self.reasonRejectName = reasonRejectName
        self.rejectNote = rejectNote
        self.rejectStep = rejectStep
        self.salary = salary
        self.status = status
        self.supporterID = supporterID
        self.workAddress = workAddress
        self.yearsExperienceName = yearsExperienceName
    }
}

class JobCvGotoWorkDto: Codable {
    var countUpdate, cvID, id, jobID: Int?
    var note: String?
    var numDayWarranty: Int?
    var startWorkDate: String?
    var updateBy: Int?
    var updateDate, warrantyExpireDate: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case countUpdate
        case cvID = "cvId"
        case id
        case jobID = "jobId"
        case note, numDayWarranty, startWorkDate, updateBy, updateDate, warrantyExpireDate
    }
    
    init(countUpdate: Int?, cvID: Int?, id: Int?, jobID: Int?, note: String?, numDayWarranty: Int?, startWorkDate: String?, updateBy: Int?, updateDate: String?, warrantyExpireDate: String?) {
        self.countUpdate = countUpdate
        self.cvID = cvID
        self.id = id
        self.jobID = jobID
        self.note = note
        self.numDayWarranty = numDayWarranty
        self.startWorkDate = startWorkDate
        self.updateBy = updateBy
        self.updateDate = updateDate
        self.warrantyExpireDate = warrantyExpireDate
    }
}

class LstInterviewHi: Codable {
    var cvID: Int?
    var emailTemplate: String?
    var id: Int?
    var interviewAddress, interviewDate: String?
    var jobID: Int?
    var note, round: String?
    var status: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case emailTemplate, id, interviewAddress, interviewDate
        case jobID = "jobId"
        case note, round, status
    }
    
    init(cvID: Int?, emailTemplate: String?, id: Int?, interviewAddress: String?, interviewDate: String?, jobID: Int?, note: String?, round: String?, status: Int?) {
        self.cvID = cvID
        self.emailTemplate = emailTemplate
        self.id = id
        self.interviewAddress = interviewAddress
        self.interviewDate = interviewDate
        self.jobID = jobID
        self.note = note
        self.round = round
        self.status = status
    }
}

class LstOfferHi: Codable {
    var curency, cvID: Int?
    var emailTemplate: String?
    var id, jobID: Int?
    var note, position, round: String?
    var salary, status: Int?
    var workAddress, workTime: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case curency
        case cvID = "cvId"
        case emailTemplate, id
        case jobID = "jobId"
        case note, position, round, salary, status, workAddress, workTime
    }
    
    init(curency: Int?, cvID: Int?, emailTemplate: String?, id: Int?, jobID: Int?, note: String?, position: String?, round: String?, salary: Int?, status: Int?, workAddress: String?, workTime: String?) {
        self.curency = curency
        self.cvID = cvID
        self.emailTemplate = emailTemplate
        self.id = id
        self.jobID = jobID
        self.note = note
        self.position = position
        self.round = round
        self.salary = salary
        self.status = status
        self.workAddress = workAddress
        self.workTime = workTime
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
    func responseDetailProcessResume(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DetailProcessResume>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
