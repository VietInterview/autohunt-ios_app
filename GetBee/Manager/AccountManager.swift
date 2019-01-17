///**
/**
Created by: Hiep Nguyen Nghia on 12/10/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
import UIKit

class AccountManager: NSObject {
    
    static var currentAccount: Account? {
        get {
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "getbee-account"), let user = try? JSONDecoder().decode(Account.self, from: data) {
                return user
            }
            return nil
        }
        
        set {
            let user = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(user, forKey: "getbee-account")
        }
    }
    
    class func deleteUser() {
        UserDefaults.standard.removeObject(forKey: "getbee-account")
    }
    
    static var isUserLogged: Bool {
        return currentAccount != nil
    }
}
