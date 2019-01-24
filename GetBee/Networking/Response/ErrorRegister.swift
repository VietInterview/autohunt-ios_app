///**
/**
Created by: Hiep Nguyen Nghia on 1/23/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var errorRegister = try? newJSONDecoder().decode(ErrorRegister.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseErrorRegister { response in
//     if var errorRegister = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ErrorRegister: Codable {
    var entityName, errorKey, type, title: String?
    var status: Int?
    var message, params: String?
    
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
    func responseErrorRegister(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ErrorRegister>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
