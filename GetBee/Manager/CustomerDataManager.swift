///**
/**
Created by: Hiep Nguyen Nghia on 1/7/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
class CustomerDataManager: NSObject {
    
    static var currentCustomer: ProfileCustomer? {
        get {
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "getbee-user"), let customer = try? JSONDecoder().decode(ProfileCustomer.self, from: data) {
                return customer
            }
            return nil
        }
        
        set {
            let user = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(user, forKey: "getbee-user")
        }
    }
    
    class func deleteUser() {
        UserDefaults.standard.removeObject(forKey: "getbee-user")
    }
    
    static var isUserLogged: Bool {
        return currentCustomer != nil
    }
}
