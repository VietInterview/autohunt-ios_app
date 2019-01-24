//
//  SignUpViewModel.swift
//  ios-base
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewModelWithEmail {
    
    var email = "" {
        didSet {
            onFormChange?()
        }
    }
    var password = "" {
        didSet {
            onFormChange?()
        }
    }
    var passwordConfirmation = "" {
        didSet {
            onFormChange?()
        }
    }
    var onFormChange: (() -> Void)?
    
    var hasValidData: Bool {
        return email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation
    }
    func resetPass(email:String, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        UserAPI.resetPass(email, success: {
            success()
        }, failure: {error in
            failure(error)
        })
    }
    func signup(email: String, address: String, carrer:String, fullName: String, phone:String ,companyName:String,mType:Int,contact:String,birthday:Int , success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        UserAPI.signup(email, address: address, career: carrer, fullName: fullName, phone: phone,companyName:companyName,mType:mType,contact:contact,birthday:birthday, success: {
            success()
        }, failure: {error in
            failure(error)
        })
    }
}
