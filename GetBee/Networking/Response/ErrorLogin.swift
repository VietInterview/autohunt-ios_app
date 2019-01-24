///**
/**
Created by: Hiep Nguyen Nghia on 1/23/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var errorLogin = try? newJSONDecoder().decode(ErrorLogin.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseErrorLogin { response in
//     if var errorLogin = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ErrorLogin: Codable {
    var type, title: String?
    var status: Int?
    var detail, path, message: String?
    
    init(type: String?, title: String?, status: Int?, detail: String?, path: String?, message: String?) {
        self.type = type
        self.title = title
        self.status = status
        self.detail = detail
        self.path = path
        self.message = message
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
    func responseErrorLogin(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ErrorLogin>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
