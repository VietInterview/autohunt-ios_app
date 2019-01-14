//
//  SignInViewModel.swift
//  ios-base
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

class SignInViewModelWithCredentials {
  
  var email = "" {
    didSet {
      onCredentialsChange?()
    }
  }
  var password = "" {
    didSet {
      onCredentialsChange?()
    }
  }
  var onCredentialsChange: (() -> Void)?
  
  var hasValidCredentials: Bool {
    return !email.isEmpty && !password.isEmpty
  }
  
  func login(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
    UserAPI.login(email, password: password, success: success, failure: { error in
        if (error as NSError).code == 0 {
            failure("Đường truyền bị gián đoan. Vui lòng kiểm tra kết nối mạng.")
        } else {
            failure("Không kết nối tới server, bạn vui lòng thử lại.")
        }
    })
  }
}
