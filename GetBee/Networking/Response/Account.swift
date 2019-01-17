// To parse the JSON, add this file to your project and do:
//
//   let account = try? newJSONDecoder().decode(Account.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAccount { response in
//     if let account = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class Account: Codable {
    var activated: Int?
    var address: String?
    var authorities: [String]?
    var career, createdBy, createdDate, email: String?
    var firstName, fullName: String?
    var id: Int?
    var imageURL, langKey, lastModifiedBy, lastModifiedDate: String?
    var lastName, login: String?
    var lstFunctionAuthority, lstMenuAuthority: [LstAuthority]?
    var phone: String?
    var type: Int?
    
    enum CodingKeys: String, CodingKey {
        case activated, address, authorities, career, createdBy, createdDate, email, firstName, fullName, id
        case imageURL = "imageUrl"
        case langKey, lastModifiedBy, lastModifiedDate, lastName, login, lstFunctionAuthority, lstMenuAuthority, phone, type
    }
    init(){}
    init(activated: Int?, address: String?, authorities: [String]?, career: String?, createdBy: String?, createdDate: String?, email: String?, firstName: String?, fullName: String?, id: Int?, imageURL: String?, langKey: String?, lastModifiedBy: String?, lastModifiedDate: String?, lastName: String?, login: String?, lstFunctionAuthority: [LstAuthority]?, lstMenuAuthority: [LstAuthority]?, phone: String?, type: Int?) {
        self.activated = activated
        self.address = address
        self.authorities = authorities
        self.career = career
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.email = email
        self.firstName = firstName
        self.fullName = fullName
        self.id = id
        self.imageURL = imageURL
        self.langKey = langKey
        self.lastModifiedBy = lastModifiedBy
        self.lastModifiedDate = lastModifiedDate
        self.lastName = lastName
        self.login = login
        self.lstFunctionAuthority = lstFunctionAuthority
        self.lstMenuAuthority = lstMenuAuthority
        self.phone = phone
        self.type = type
    }
}

class LstAuthority: Codable {
    var code: String?
    var id: Int?
    var name: String?
    init(){}
    init(code: String?, id: Int?, name: String?) {
        self.code = code
        self.id = id
        self.name = name
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
    func responseAccount(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Account>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
