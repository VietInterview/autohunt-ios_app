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

class ListCV: Codable {
    var total: Int?
    var cvList: [CvList2]?
    init(){
        
    }
    init(total: Int?, cvList: [CvList2]?) {
        self.total = total
        self.cvList = cvList
    }
}

class CvList2: Codable {
    var id: Int?
    var fullName, careerName, jobCityName, updatedDate: String?
    var status: Int?
    init(){
        
    }
    init(id: Int?, fullName: String?, careerName: String?, jobCityName: String?, updatedDate: String?, status: Int?) {
        self.id = id
        self.fullName = fullName
        self.careerName = careerName
        self.jobCityName = jobCityName
        self.updatedDate = updatedDate
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
    func responseListCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ListCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
