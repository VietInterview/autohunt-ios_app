// To parse the JSON, add this file to your project and do:
//
//   let myCV = try? newJSONDecoder().decode(MyCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMyCV { response in
//     if let myCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class MyCV: Codable {
    var total: Int?
    var cvList: [CvList]?
    
    init(total: Int?, cvList: [CvList]?) {
        self.total = total
        self.cvList = cvList
    }
}

class CvList: Codable {
    var id: Int?
    var fullName, careerName, jobCityName, updatedDate: String?
    var jobTitle: String?
    
    init(id: Int?, fullName: String?, careerName: String?, jobCityName: String?, updatedDate: String?, jobTitle: String?) {
        self.id = id
        self.fullName = fullName
        self.careerName = careerName
        self.jobCityName = jobCityName
        self.updatedDate = updatedDate
        self.jobTitle = jobTitle
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
    func responseMyCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<MyCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
