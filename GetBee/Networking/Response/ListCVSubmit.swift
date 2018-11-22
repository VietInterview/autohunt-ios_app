// To parse the JSON, add this file to your project and do:
//
//   let listCV = try? newJSONDecoder().decode(ListCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListCV { response in
//     if let listCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ListCVSubmit: Codable {
    var total: Int?
    var cvList: [CvListSubmit]?
    init(){}
    init(total: Int?, cvList: [CvListSubmit]?) {
        self.total = total
        self.cvList = cvList
    }
}

class CvListSubmit: Codable {
    var id: Int?
    var fullName, email, phone: String?
    var sex, maritalStatus: Int?
    var birthday, address, pictureURL, cvTitle: String?
    var desiredSalary: JSONNull?
    var careerObjectives: String?
    var collaboratorID, supporterID, status: Int?
    var createdDate, createdBy, updatedDate, updatedBy: String?
    var careerName: String?
    var parentID: Int?
    var currentLevel, desiredLevel: String?
    var city: JSONNull?
    var educationLevel, experienceYear, workingForm: String?
    var lstJobCity, lstCareer: JSONNull?
    var currencyID: Int?
    var currencyName, desiredPosition: String?
    var jobID: Int?
    var companyName: String?
    var lstJobCityID: JSONNull?
    var jobListcityName, jobCareerName, jobTitle: String?
    var toSalary, fromSalary, fee: Int?
    var levelName: String?
    var lstEmploymentHis, lstEducationHis, lstLanguage, lstComputerSkill: JSONNull?
    var cvSkill: JSONNull?
    init(){}
    enum CodingKeys: String, CodingKey {
        case id, fullName, email, phone, sex, maritalStatus, birthday, address
        case pictureURL = "pictureUrl"
        case cvTitle, desiredSalary, careerObjectives
        case collaboratorID = "collaboratorId"
        case supporterID = "supporterId"
        case status, createdDate, createdBy, updatedDate, updatedBy, careerName
        case parentID = "parentId"
        case currentLevel, desiredLevel, city, educationLevel, experienceYear, workingForm, lstJobCity, lstCareer
        case currencyID = "currencyId"
        case currencyName, desiredPosition
        case jobID = "jobId"
        case companyName
        case lstJobCityID = "lstJobCityId"
        case jobListcityName, jobCareerName, jobTitle, toSalary, fromSalary, fee, levelName, lstEmploymentHis, lstEducationHis, lstLanguage, lstComputerSkill, cvSkill
    }
    
    init(id: Int?, fullName: String?, email: String?, phone: String?, sex: Int?, maritalStatus: Int?, birthday: String?, address: String?, pictureURL: String?, cvTitle: String?, desiredSalary: JSONNull?, careerObjectives: String?, collaboratorID: Int?, supporterID: Int?, status: Int?, createdDate: String?, createdBy: String?, updatedDate: String?, updatedBy: String?, careerName: String?, parentID: Int?, currentLevel: String?, desiredLevel: String?, city: JSONNull?, educationLevel: String?, experienceYear: String?, workingForm: String?, lstJobCity: JSONNull?, lstCareer: JSONNull?, currencyID: Int?, currencyName: String?, desiredPosition: String?, jobID: Int?, companyName: String?, lstJobCityID: JSONNull?, jobListcityName: String?, jobCareerName: String?, jobTitle: String?, toSalary: Int?, fromSalary: Int?, fee: Int?, levelName: String?, lstEmploymentHis: JSONNull?, lstEducationHis: JSONNull?, lstLanguage: JSONNull?, lstComputerSkill: JSONNull?, cvSkill: JSONNull?) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.sex = sex
        self.maritalStatus = maritalStatus
        self.birthday = birthday
        self.address = address
        self.pictureURL = pictureURL
        self.cvTitle = cvTitle
        self.desiredSalary = desiredSalary
        self.careerObjectives = careerObjectives
        self.collaboratorID = collaboratorID
        self.supporterID = supporterID
        self.status = status
        self.createdDate = createdDate
        self.createdBy = createdBy
        self.updatedDate = updatedDate
        self.updatedBy = updatedBy
        self.careerName = careerName
        self.parentID = parentID
        self.currentLevel = currentLevel
        self.desiredLevel = desiredLevel
        self.city = city
        self.educationLevel = educationLevel
        self.experienceYear = experienceYear
        self.workingForm = workingForm
        self.lstJobCity = lstJobCity
        self.lstCareer = lstCareer
        self.currencyID = currencyID
        self.currencyName = currencyName
        self.desiredPosition = desiredPosition
        self.jobID = jobID
        self.companyName = companyName
        self.lstJobCityID = lstJobCityID
        self.jobListcityName = jobListcityName
        self.jobCareerName = jobCareerName
        self.jobTitle = jobTitle
        self.toSalary = toSalary
        self.fromSalary = fromSalary
        self.fee = fee
        self.levelName = levelName
        self.lstEmploymentHis = lstEmploymentHis
        self.lstEducationHis = lstEducationHis
        self.lstLanguage = lstLanguage
        self.lstComputerSkill = lstComputerSkill
        self.cvSkill = cvSkill
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
    func responseListCVSubmit(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ListCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
