//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class SessionManager: NSObject {

  static var currentSession: Session? {
    get {
      if let data = UserDefaults.standard.data(forKey: "current_user"), let session = try? JSONDecoder().decode(Session.self, from: data) {
        return session
      }
      return nil
    }
    
    set {
      let session = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(session, forKey: "current_user")
    }
  }
  
  class func deleteSession() {
    UserDefaults.standard.removeObject(forKey: "current_user")
  }
  
  static var validSession: Bool {
//    if let session = currentSession, let uid = session.uid,
//       let tkn = session.accessToken, let client = session.client {
//      return !uid.isEmpty && !tkn.isEmpty && !client.isEmpty
//    }
    return false
  }
}
