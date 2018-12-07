//
//  UserDataManager.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class UserDataManager: NSObject {
  
  static var currentUser: GetMyProfile? {
    get {
      let defaults = UserDefaults.standard
      if let data = defaults.data(forKey: "getbee-user"), let user = try? JSONDecoder().decode(GetMyProfile.self, from: data) {
        return user
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
    return currentUser != nil
  }
}
