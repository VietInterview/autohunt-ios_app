///**
/**
Created by: Hiep Nguyen Nghia on 1/23/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var errorResetPass = try? newJSONDecoder().decode(ErrorResetPass.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseErrorResetPass { response in
//     if var errorResetPass = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ErrorResetPass: Codable {
    var type, title: String?
    var status: Int?
    
    init(type: String?, title: String?, status: Int?) {
        self.type = type
        self.title = title
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
    func responseErrorResetPass(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ErrorResetPass>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
