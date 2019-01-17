///**
/**
Created by: Hiep Nguyen Nghia on 1/4/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var gotoWorkUpdate = try? newJSONDecoder().decode(GotoWorkUpdate.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGotoWorkUpdate { response in
//     if var gotoWorkUpdate = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class GotoWorkUpdate: Codable {
    var countUpdate, cvID, id, jobID: Int?
    var note: String?
    var numDayWarranty: Int?
    var startWorkDate: String?
    var updateBy: Int?
    var updateDate, warrantyExpireDate: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case countUpdate
        case cvID = "cvId"
        case id
        case jobID = "jobId"
        case note, numDayWarranty, startWorkDate, updateBy, updateDate, warrantyExpireDate
    }
    
    init(countUpdate: Int?, cvID: Int?, id: Int?, jobID: Int?, note: String?, numDayWarranty: Int?, startWorkDate: String?, updateBy: Int?, updateDate: String?, warrantyExpireDate: String?) {
        self.countUpdate = countUpdate
        self.cvID = cvID
        self.id = id
        self.jobID = jobID
        self.note = note
        self.numDayWarranty = numDayWarranty
        self.startWorkDate = startWorkDate
        self.updateBy = updateBy
        self.updateDate = updateDate
        self.warrantyExpireDate = warrantyExpireDate
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
    func responseGotoWorkUpdate(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<GotoWorkUpdate>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
