// To parse the JSON, add this file to your project and do:
//
//   let resumesByJobCustomer = try? newJSONDecoder().decode(ResumesByJobCustomer.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseResumesByJobCustomer { response in
//     if let resumesByJobCustomer = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ResumesByJobCustomer: Codable {
    var total: Int?
    var cvList: [CvListByJobCustomer]?
    init(){}
    init(total: Int?, cvList: [CvListByJobCustomer]?) {
        self.total = total
        self.cvList = cvList
    }
}

class CvListByJobCustomer: Codable {
    var id: Int?
    var fullName, birthday, address, city: String?
    var educationLevel, experienceYear, createdDate, companyNameOld: String?
    var countDay, status: Int?
    init(){}
    init(id: Int?, fullName: String?, birthday: String?, address: String?, city: String?, educationLevel: String?, experienceYear: String?, createdDate: String?, companyNameOld: String?, countDay: Int?, status: Int?) {
        self.id = id
        self.fullName = fullName
        self.birthday = birthday
        self.address = address
        self.city = city
        self.educationLevel = educationLevel
        self.experienceYear = experienceYear
        self.createdDate = createdDate
        self.companyNameOld = companyNameOld
        self.countDay = countDay
        self.status = status
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
    func responseResumesByJobCustomer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResumesByJobCustomer>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
