// To parse the JSON, add this file to your project and do:
//
//   let jobCustomer = try? newJSONDecoder().decode(JobCustomer.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseJobCustomer { response in
//     if let jobCustomer = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class JobCustomer: Codable {
    var total: Int?
    var jobList: [JobListCustomer]?
    init(){}
    init(total: Int?, jobList: [JobListCustomer]?) {
        self.total = total
        self.jobList = jobList
    }
}

class JobListCustomer: Codable {
    var id: Int?
    var jobTitle: String?
    var expireDate: String?
    var status, countView, countOffer, countCv: Int?
    var limited: Int?
    var submitDate: String?
    init(){}
    init(id: Int?, jobTitle: String?, expireDate: String?, status: Int?, countView: Int?, countOffer: Int?, countCv: Int?, limited: Int?, submitDate: String?) {
        self.id = id
        self.jobTitle = jobTitle
        self.expireDate = expireDate
        self.status = status
        self.countView = countView
        self.countOffer = countOffer
        self.countCv = countCv
        self.limited = limited
        self.submitDate = submitDate
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
    func responseJobCustomer(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<JobCustomer>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
