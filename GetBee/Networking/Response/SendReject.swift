///**
/**
Created by: Hiep Nguyen Nghia on 1/2/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var sendReject = try? newJSONDecoder().decode(SendReject.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSendReject { response in
//     if var sendReject = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class SendReject: Codable {
    var cvID, jobID: Int?
    var reasonNote: String?
    var reasonRejectID, rejectStep: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case jobID = "jobId"
        case reasonNote
        case reasonRejectID = "reasonRejectId"
        case rejectStep
    }
    
    init(cvID: Int?, jobID: Int?, reasonNote: String?, reasonRejectID: Int?, rejectStep: Int?) {
        self.cvID = cvID
        self.jobID = jobID
        self.reasonNote = reasonNote
        self.reasonRejectID = reasonRejectID
        self.rejectStep = rejectStep
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
    func responseSendReject(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SendReject>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
