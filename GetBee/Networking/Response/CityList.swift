///**
/**
Created by: Hiep Nguyen Nghia on 1/30/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/
// To parse the JSON, add this file to your project and do:
//
//   let cityList = try? newJSONDecoder().decode(CityList.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCityList { response in
//     if let cityList = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias CityList = [CityListElement]

class CityListElement: Codable {
    let id: Int?
    let name: String?
    let enName: String?
    let countryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case enName = "enName"
        case countryID = "countryId"
    }
    
    init(id: Int?, name: String?, enName: String?, countryID: Int?) {
        self.id = id
        self.name = name
        self.enName = enName
        self.countryID = countryID
    }
}


// MARK: - Alamofire response handlers

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
    func responseCityList(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CityList>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
