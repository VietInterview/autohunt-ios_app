///**
/**
Created by: Hiep Nguyen Nghia on 10/13/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

// To parse the JSON, add this file to your project and do:
//
//   let login = try? newJSONDecoder().decode(Login.self, from: jsonData)

import Foundation

class Login: Codable {
    let idToken: String?
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
    }
    
    init(idToken: String?) {
        self.idToken = idToken
    }
}

