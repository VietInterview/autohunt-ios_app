///**
/**
Created by: Hiep Nguyen Nghia on 1/4/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var sendOffer = try? newJSONDecoder().decode(SendOffer.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSendOffer { response in
//     if var sendOffer = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class SendOffer: Codable {
    var curency, cvID: Int?
    var emailTemplate: String?
    var id, jobID: Int?
    var note, position, round: String?
    var salary, status: Int?
    var workAddress, workTime: String?
    init(){}
    enum CodingKeys: String, CodingKey {
        case curency
        case cvID = "cvId"
        case emailTemplate, id
        case jobID = "jobId"
        case note, position, round, salary, status, workAddress, workTime
    }
    
    init(curency: Int?, cvID: Int?, emailTemplate: String?, id: Int?, jobID: Int?, note: String?, position: String?, round: String?, salary: Int?, status: Int?, workAddress: String?, workTime: String?) {
        self.curency = curency
        self.cvID = cvID
        self.emailTemplate = emailTemplate
        self.id = id
        self.jobID = jobID
        self.note = note
        self.position = position
        self.round = round
        self.salary = salary
        self.status = status
        self.workAddress = workAddress
        self.workTime = workTime
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
    func responseSendOffer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SendOffer>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
