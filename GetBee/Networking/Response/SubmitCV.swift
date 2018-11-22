// To parse the JSON, add this file to your project and do:
//
//   let submitCV = try? newJSONDecoder().decode(SubmitCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSubmitCV { response in
//     if let submitCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class SubmitCV: Codable {
    var copyMyCv, cvID, jobID, parentCvID: Int?
    var type: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case copyMyCv
        case cvID = "cvId"
        case jobID = "jobId"
        case parentCvID = "parentCvId"
        case type
    }
    
    init(copyMyCv: Int?, cvID: Int?, jobID: Int?, parentCvID: Int?, type: Int?) {
        self.copyMyCv = copyMyCv
        self.cvID = cvID
        self.jobID = jobID
        self.parentCvID = parentCvID
        self.type = type
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
    func responseSubmitCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SubmitCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
