// To parse the JSON, add this file to your project and do:
//
//   let errorSubmitCV = try? newJSONDecoder().decode(ErrorSubmitCV.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseErrorSubmitCV { response in
//     if let errorSubmitCV = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

public class ErrorSubmitCV: Codable {
    var entityName, errorKey: String?
    var type: String?
    var title: String?
    var status: Int?
    var message, params: String?
    init(){}
    init(entityName: String?, errorKey: String?, type: String?, title: String?, status: Int?, message: String?, params: String?) {
        self.entityName = entityName
        self.errorKey = errorKey
        self.type = type
        self.title = title
        self.status = status
        self.message = message
        self.params = params
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
    func responseErrorSubmitCV(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ErrorSubmitCV>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
