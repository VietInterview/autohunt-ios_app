///**
/**
Created by: Hiep Nguyen Nghia on 1/2/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

// To parse the JSON, add this file to your project and do:
//
//   var listRejectReason = try? newJSONDecoder().decode(ListRejectReason.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListRejectReason { response in
//     if var listRejectReason = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias ListRejectReason = [ListRejectReasonElement]

class ListRejectReasonElement: Codable {
    var code: String?
    var id: Int?
    var name: String?
    var step: Int?
    init(){}
    init(code: String?, id: Int?, name: String?, step: Int?) {
        self.code = code
        self.id = id
        self.name = name
        self.step = step
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
    func responseListRejectReason(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ListRejectReason>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
