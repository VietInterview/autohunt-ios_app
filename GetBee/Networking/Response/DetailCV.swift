// To parse the JSON, add this file to your project and do:
//
//   let detailCV = try? newJSONDecoder().decode(DetailCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDetailCV { response in
//     if let detailCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class DetailCV: Codable {
    var address: String?
    var birthday: Int?
    var careerName, careerObjectives: String?
    var city: City?
    var collaboratorID: Int?
    var companyName: String?
    var createdBy: Int?
    var createdDate: String?
    var currencyID: Int?
    var currencyName: String?
    var currentLevel: City?
    var cvSkill: CvSkill?
    var cvTitle: String?
    var desiredLevel: City?
    var desiredPosition: String?
    var desiredSalary: Int?
    var educationLevel: City?
    var email: String?
    var experienceYear: City?
    var fee, fromSalary: Int?
    var fullName: String?
    var id: Int?
    var jobCareerName: String?
    var jobID: Int?
    var jobListcityName, jobTitle, levelName: String?
    var lstCareer: [City]?
    var lstComputerSkill: [LstComputerSkill]?
    var lstEducationHis: [LstEducationHi]?
    var lstEmploymentHis: [LstEmploymentHi]?
    var lstJobCity: [City]?
    var lstJobCityID: String?
    var lstLanguage: [LstLanguage]?
    var maritalStatus, parentID: Int?
    var phone, pictureURL: String?
    var sex, status, supporterID, toSalary: Int?
    var updatedBy: Int?
    var updatedDate: String?
    var workingForm: City?
    init(){}
    enum CodingKeys: String, CodingKey {
        case address, birthday, careerName, careerObjectives, city
        case collaboratorID = "collaboratorId"
        case companyName, createdBy, createdDate
        case currencyID = "currencyId"
        case currencyName, currentLevel, cvSkill, cvTitle, desiredLevel, desiredPosition, desiredSalary, educationLevel, email, experienceYear, fee, fromSalary, fullName, id, jobCareerName
        case jobID = "jobId"
        case jobListcityName, jobTitle, levelName, lstCareer, lstComputerSkill, lstEducationHis, lstEmploymentHis, lstJobCity
        case lstJobCityID = "lstJobCityId"
        case lstLanguage, maritalStatus
        case parentID = "parentId"
        case phone
        case pictureURL = "pictureUrl"
        case sex, status
        case supporterID = "supporterId"
        case toSalary, updatedBy, updatedDate, workingForm
    }
    
    init(address: String?, birthday: Int?, careerName: String?, careerObjectives: String?, city: City?, collaboratorID: Int?, companyName: String?, createdBy: Int?, createdDate: String?, currencyID: Int?, currencyName: String?, currentLevel: City?, cvSkill: CvSkill?, cvTitle: String?, desiredLevel: City?, desiredPosition: String?, desiredSalary: Int?, educationLevel: City?, email: String?, experienceYear: City?, fee: Int?, fromSalary: Int?, fullName: String?, id: Int?, jobCareerName: String?, jobID: Int?, jobListcityName: String?, jobTitle: String?, levelName: String?, lstCareer: [City]?, lstComputerSkill: [LstComputerSkill]?, lstEducationHis: [LstEducationHi]?, lstEmploymentHis: [LstEmploymentHi]?, lstJobCity: [City]?, lstJobCityID: String?, lstLanguage: [LstLanguage]?, maritalStatus: Int?, parentID: Int?, phone: String?, pictureURL: String?, sex: Int?, status: Int?, supporterID: Int?, toSalary: Int?, updatedBy: Int?, updatedDate: String?, workingForm: City?) {
        self.address = address
        self.birthday = birthday
        self.careerName = careerName
        self.careerObjectives = careerObjectives
        self.city = city
        self.collaboratorID = collaboratorID
        self.companyName = companyName
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.currencyID = currencyID
        self.currencyName = currencyName
        self.currentLevel = currentLevel
        self.cvSkill = cvSkill
        self.cvTitle = cvTitle
        self.desiredLevel = desiredLevel
        self.desiredPosition = desiredPosition
        self.desiredSalary = desiredSalary
        self.educationLevel = educationLevel
        self.email = email
        self.experienceYear = experienceYear
        self.fee = fee
        self.fromSalary = fromSalary
        self.fullName = fullName
        self.id = id
        self.jobCareerName = jobCareerName
        self.jobID = jobID
        self.jobListcityName = jobListcityName
        self.jobTitle = jobTitle
        self.levelName = levelName
        self.lstCareer = lstCareer
        self.lstComputerSkill = lstComputerSkill
        self.lstEducationHis = lstEducationHis
        self.lstEmploymentHis = lstEmploymentHis
        self.lstJobCity = lstJobCity
        self.lstJobCityID = lstJobCityID
        self.lstLanguage = lstLanguage
        self.maritalStatus = maritalStatus
        self.parentID = parentID
        self.phone = phone
        self.pictureURL = pictureURL
        self.sex = sex
        self.status = status
        self.supporterID = supporterID
        self.toSalary = toSalary
        self.updatedBy = updatedBy
        self.updatedDate = updatedDate
        self.workingForm = workingForm
    }
}

class City: Codable {
    var id: Int?
    var name: String?
    init(){}
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

class CvSkill: Codable {
    var cvID: Int?
    var hobby: String?
    var id: Int?
    var lstOtherSkillName: [String]?
    var otherSkill, primarySkill: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case hobby, id, lstOtherSkillName, otherSkill, primarySkill
    }
    
    init(cvID: Int?, hobby: String?, id: Int?, lstOtherSkillName: [String]?, otherSkill: String?, primarySkill: String?) {
        self.cvID = cvID
        self.hobby = hobby
        self.id = id
        self.lstOtherSkillName = lstOtherSkillName
        self.otherSkill = otherSkill
        self.primarySkill = primarySkill
    }
}

class LstComputerSkill: Codable {
    var cvID, id, msExcel, msOutlook: Int?
    var msPowerPoint, msWord: Int?
    var other: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case id, msExcel, msOutlook, msPowerPoint, msWord, other
    }
    
    init(cvID: Int?, id: Int?, msExcel: Int?, msOutlook: Int?, msPowerPoint: Int?, msWord: Int?, other: String?) {
        self.cvID = cvID
        self.id = id
        self.msExcel = msExcel
        self.msOutlook = msOutlook
        self.msPowerPoint = msPowerPoint
        self.msWord = msWord
        self.other = other
    }
}

class LstEducationHi: Codable {
    var career: String?
    var cvID, fromMonth, graduationType: Int?
    var graduationTypeName: String?
    var id: Int?
    var note, school, subject: String?
    var toMonth: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case career
        case cvID = "cvId"
        case fromMonth, graduationType, graduationTypeName, id, note, school, subject, toMonth
    }
    
    init(career: String?, cvID: Int?, fromMonth: Int?, graduationType: Int?, graduationTypeName: String?, id: Int?, note: String?, school: String?, subject: String?, toMonth: Int?) {
        self.career = career
        self.cvID = cvID
        self.fromMonth = fromMonth
        self.graduationType = graduationType
        self.graduationTypeName = graduationTypeName
        self.id = id
        self.note = note
        self.school = school
        self.subject = subject
        self.toMonth = toMonth
    }
}

class LstEmploymentHi: Codable {
    var achievement, companyName: String?
    var currentJob, cvID, fromMonth, humanResources: Int?
    var id, isCurrent: Int?
    var jobDescription: String?
    var salary, salaryCurency: Int?
    var title: String?
    var toMonth: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case achievement, companyName, currentJob
        case cvID = "cvId"
        case fromMonth, humanResources, id, isCurrent, jobDescription, salary, salaryCurency, title, toMonth
    }
    
    init(achievement: String?, companyName: String?, currentJob: Int?, cvID: Int?, fromMonth: Int?, humanResources: Int?, id: Int?, isCurrent: Int?, jobDescription: String?, salary: Int?, salaryCurency: Int?, title: String?, toMonth: Int?) {
        self.achievement = achievement
        self.companyName = companyName
        self.currentJob = currentJob
        self.cvID = cvID
        self.fromMonth = fromMonth
        self.humanResources = humanResources
        self.id = id
        self.isCurrent = isCurrent
        self.jobDescription = jobDescription
        self.salary = salary
        self.salaryCurency = salaryCurency
        self.title = title
        self.toMonth = toMonth
    }
}

class LstLanguage: Codable {
    var cvID, id, languageID: Int?
    var languageName: String?
    var listen, read, speak, write: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case id
        case languageID = "languageId"
        case languageName, listen, read, speak, write
    }
    
    init(cvID: Int?, id: Int?, languageID: Int?, languageName: String?, listen: Int?, read: Int?, speak: Int?, write: Int?) {
        self.cvID = cvID
        self.id = id
        self.languageID = languageID
        self.languageName = languageName
        self.listen = listen
        self.read = read
        self.speak = speak
        self.write = write
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
    func responseDetailCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DetailCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
