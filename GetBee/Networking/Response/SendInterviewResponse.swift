///**
/**
Created by: Hiep Nguyen Nghia on 1/3/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   var sendInterviewResponse = try? newJSONDecoder().decode(SendInterviewResponse.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseSendInterviewResponse { response in
//     if var sendInterviewResponse = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class SendInterviewResponse: Codable {
    var cvID: Int?
    var emailTemplate: String?
    var id: Int?
    var interviewAddress, interviewDate: String?
    var jobID: Int?
    var note, round: String?
    var status: Int?
    init(){}
    enum CodingKeys: String, CodingKey {
        case cvID = "cvId"
        case emailTemplate, id, interviewAddress, interviewDate
        case jobID = "jobId"
        case note, round, status
    }
    
    init(cvID: Int?, emailTemplate: String?, id: Int?, interviewAddress: String?, interviewDate: String?, jobID: Int?, note: String?, round: String?, status: Int?) {
        self.cvID = cvID
        self.emailTemplate = emailTemplate
        self.id = id
        self.interviewAddress = interviewAddress
        self.interviewDate = interviewDate
        self.jobID = jobID
        self.note = note
        self.round = round
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
    func responseSendInterviewResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SendInterviewResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
