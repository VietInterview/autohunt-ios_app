//
//  UserServiceManager.swift
//  ios-base
//
//  Created by Rootstrap on 16/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class UserAPI {
  
  fileprivate static let usersUrl = "/api/authenticate"
  fileprivate static let currentUserUrl = "/user/"
  fileprivate static let collUrl = "/svccollaborator/api"
  fileprivate static let collCusUrl = "/svccustomer/api"
  
  class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl
    let parameters = [
      "password": password,
      "rememberMe": true,
      "username": email
      ] as [String : Any]
    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      LoadingOverlay.shared.hideOverlayView()
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      LoadingOverlay.shared.hideOverlayView()
      failure(error)
    })
  }
  
  class func signup(_ email: String, address: String, career: String, fullName:String, phone: String, success: @escaping () -> Void, failure: @escaping (_ error: String) -> Void) {
    let url = "/api/register"
    let parameters = [
      "email": email,
      "address": address,
      "career": career,
      "fullName": fullName,
      "phone": phone
    ]
    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    APIClient.request1(.post, url: url, params: parameters, success: { response, headers in
        LoadingOverlay.shared.hideOverlayView()
        success()
    }, failure: { error , statusCode in
      LoadingOverlay.shared.hideOverlayView()
      var dict : Dictionary = error
      let errorString:String = dict["X-gwautohuntApp-error"] as? String ?? ""
      failure(errorString)
    })
  }
  
  //Example method that uploads base64 encoded image.
  class func signup(_ email: String, password: String, avatar64: UIImage, success: @escaping (_ response: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let picData = UIImageJPEGRepresentation(avatar64, 0.75)
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "image": picData!.asBase64Param()
      ]
    ]
    
    APIClient.request(.post, url: usersUrl, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success(response)
    }, failure: { error in
      failure(error)
    })
  }
  
  class func getMyProfile(_ success: @escaping (_ user: GetMyProfile) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = collUrl + "/getProfiles"
    APIClient.request(.get, url: url, success: { response, _ in
      if let getMyProfile = try? JSONDecoder().decode(GetMyProfile.self, from: response){
        UserDataManager.currentUser = getMyProfile
        success(getMyProfile)
      }
    }, failure: { error in
      failure(error)
    })
  }
  class func getCusProfile(_ success: @escaping (_ user: ProfileCustomer) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = collCusUrl + "/getProfiles"
    APIClient.request(.get, url: url, success: { response, _ in
      if let getCusProfile = try? JSONDecoder().decode(ProfileCustomer.self, from: response){
        CustomerDataManager.currentCustomer = getCusProfile
        success(getCusProfile)
      }
    }, failure: { error in
      failure(error)
    })
  }
  class func getAccount(_ success: @escaping (_ user: Account) -> Void, failure: @escaping (_ error: Error) -> Void){
    let url = "/api/account"
    APIClient.request(.get, url: url, success: { response, _ in
      if let account = try? JSONDecoder().decode(Account.self, from: response){
        AccountManager.currentAccount = account
        success(account)
      }
    }, failure: { error in
      failure(error)
    })
  }
  class func saveMyProfile(fullName: String, phone: String, address: String, carrer: String, arrCarrerHunt: [DesideratedCareer]?,_ success: @escaping (_ user: GetMyProfile) -> Void, failure: @escaping (_ error: Error) -> Void){
    let url = collUrl + "/saveProfile"
    var arrayList : [String: Any]//one item of array
    var list = [[String: Any]]()//data array
    if let mArrCarrerHunt = arrCarrerHunt {
      for i in 0..<mArrCarrerHunt.count {
        arrayList = [
          "id":mArrCarrerHunt[i].id!,
          "name":mArrCarrerHunt[i].name!,
        ]
        list.append(arrayList)//append to your list
      }
    }
    let parameters = [
      "addressColl": address,
      "careerColl": carrer,
      "fullNameColl": fullName,
      "phoneColl": phone,
      "desideratedCareer":list
      ] as [String : Any]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      LoadingOverlay.shared.hideOverlayView()
      if let getMyProfile = try? JSONDecoder().decode(GetMyProfile.self, from: response){
        UserDataManager.currentUser = getMyProfile
        success(getMyProfile)
      }
    }, failure: { error in
       LoadingOverlay.shared.hideOverlayView()
      failure(error)
    })
  }
  class func changePassword(currentPassword: String, newPassword: String, success: @escaping () -> Void, failure: @escaping (_ error: String,_ statusCode: Int) -> Void){
    let url = "/api/account/change-password"
    let parameters = [
      "currentPassword": currentPassword,
      "newPassword": newPassword
      ] as [String : Any]
    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    APIClient.request1(.post, url: url, params: parameters, success: { response, headers in
      LoadingOverlay.shared.hideOverlayView()
      debugLog(object: headers)
      success()
    }, failure: { error, statusCode  in
      LoadingOverlay.shared.hideOverlayView()
      var dict : Dictionary = error
      let errorString:String = dict["X-svcCollaboratorApp-error"] as? String ?? ""
      failure(errorString, statusCode)
    })
  }
  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "facebook"
    let parameters = [
      "access_token": token
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
  class func saveUserSession(fromResponse response: [String: Any], headers: [AnyHashable: Any]) {
    //    UserDataManager.currentUser = try? JSONDecoder().decode(User.self, from: response["user"] as? [String: Any] ?? [:])
    SessionManager.currentSession = try? JSONDecoder().decode(Session.self, from: response)
    print(SessionManager.currentSession!.accessToken!)
    //    if let headers = headers as? [String: Any] {
    //      SessionManager.currentSession!.accessToken = login!.idToken!
    //    }
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    //    let url = usersUrl + "sign_out"
    //    APIClient.request(.delete, url: url, success: {_, _ in
    UserDataManager.deleteUser()
    SessionManager.deleteSession()
    success()
    //      success()
    //    }, failure: { error in
    //      failure(error)
    //    })
  }
}
