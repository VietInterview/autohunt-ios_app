// To parse the JSON, add this file to your project and do:
//
//   let deleteCV = try? newJSONDecoder().decode(DeleteCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDeleteCV { response in
//     if let deleteCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class DeleteCV: Codable {
    var count: Int?
    init(){}
    init(count: Int?) {
        self.count = count
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
    func responseDeleteCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DeleteCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
