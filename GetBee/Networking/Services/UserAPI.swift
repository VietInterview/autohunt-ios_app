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
    APIClient.request(.post, url: url, params: parameters, success: { response, headers,status  in
      LoadingOverlay.shared.hideOverlayView()
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error,response,status  in
      LoadingOverlay.shared.hideOverlayView()
      failure(error)
    })
  }
  class func resetPass(_ email:String,success: @escaping () -> Void, failure: @escaping (_ error: String) -> Void) {
     let url = "/api/account/reset-password/init"
    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    APIClient.requestStringParam(.post, url: url, params: email, success: { response, headers, status in
      LoadingOverlay.shared.hideOverlayView()
      success()
    }, failure: { error,response , statusCode in
      LoadingOverlay.shared.hideOverlayView()
      if statusCode == 200 {
        failure("")
      } else {
        if let errorResetPass = try? newJSONDecoder().decode(ErrorResetPass.self, from: response){
          if errorResetPass.title == "email_not_found" {
            failure("Không tìm thấy địa chỉ email này.")
          } else {
            failure(error.localizedDescription)
          }
        } else {
          failure(error.localizedDescription)
        }
      }
    })
  }
  class func signup(_ email: String, address: String, career: String, fullName:String, phone: String,companyName:String,mType:Int,contact:String,birthday:Int , success: @escaping () -> Void, failure: @escaping (_ error: String) -> Void) {
    let url = "/api/register"
    let parameters =  [
      "email": email,
      "address": address,
      "career": career,
      "fullName": fullName,
      "phone": phone,
      "os": "IOS",
      "companyName": companyName,
      "type": mType,
      "contact": contact,
      "birthday": birthday != 0 ? birthday : nil
      ] as [String : Any]
    LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
    APIClient.request(.post, url: url, params: parameters, success: { response, headers, status in
        LoadingOverlay.shared.hideOverlayView()
        success()
    }, failure: { error,response , statusCode in
      LoadingOverlay.shared.hideOverlayView()
      if let errorRegister = try? newJSONDecoder().decode(ErrorRegister.self, from: response){
        if let errorKey = errorRegister.errorKey {
          if errorKey == "userexists" {
            failure("Địa chỉ email này đã tồn tại trong hệ thống, vui lòng đăng ký e-mail khác")
          }
        }else {
          failure("Đã có lỗi xảy ra, vui lòng thử lại")
        }
      } else {
        failure(error.localizedDescription)
      }
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
    
    APIClient.request(.post, url: usersUrl, params: parameters, success: { response, headers,status  in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success(response)
    }, failure: { error,response,status in
      failure(error)
    })
  }
  
  class func getMyProfile(_ success: @escaping (_ user: GetMyProfile) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = collUrl + "/getProfiles"
    APIClient.request(.get, url: url, success: { response, _,status  in
      if let getMyProfile = try? JSONDecoder().decode(GetMyProfile.self, from: response){
        UserDataManager.currentUser = getMyProfile
        success(getMyProfile)
      }
    }, failure: { error, response, status in
      failure(error)
    })
  }
  class func getCusProfile(_ success: @escaping (_ user: ProfileCustomer) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = collCusUrl + "/getProfiles"
    UIApplication.showNetworkActivity()
    APIClient.request(.get, url: url, success: { response, _,status  in
      UIApplication.hideNetworkActivity()
      if let getCusProfile = try? JSONDecoder().decode(ProfileCustomer.self, from: response){
        CustomerDataManager.currentCustomer = getCusProfile
        success(getCusProfile)
      }
    }, failure: { error,response, status in
      UIApplication.hideNetworkActivity()
      failure(error)
    })
  }
  class func getAccount(_ success: @escaping (_ user: Account) -> Void, failure: @escaping (_ error: Error) -> Void){
    let url = "/api/account"
    APIClient.request(.get, url: url, success: { response, _,status in
      if let account = try? JSONDecoder().decode(Account.self, from: response){
        AccountManager.currentAccount = account
        success(account)
      }
    }, failure: { error,response,status in
      failure(error)
    })
  }
  class func saveMyProfile(fullName: String, phone: String, address: String, carrer: String, arrCarrerHunt: [CountryMyProfile]?,arrCity:[CityMyProfile]?,arrCountry: [CountryMyProfile]?,companyName:String,birthday:Int,contractDate:Int,_ success: @escaping (_ user: GetMyProfile) -> Void, failure: @escaping (_ error: Error) -> Void){
    let url = collUrl + "/saveProfile"
    var arrayList : [String: Any]
    var list = [[String: Any]]()
    if let mArrCarrerHunt = arrCarrerHunt {
      for i in 0..<mArrCarrerHunt.count {
        arrayList = [
          "id":mArrCarrerHunt[i].id!,
          "name":mArrCarrerHunt[i].name!,
        ]
        list.append(arrayList)
      }
    }
    
    var arrayListCity : [String: Any]
    var listCity = [[String: Any]]()
    if let mArrCity = arrCity {
      for i in 0..<mArrCity.count {
        arrayListCity = [
          "id":mArrCity[i].id!,
          "name":mArrCity[i].name!,
          "countryId":mArrCity[i].countryID!
        ]
        listCity.append(arrayListCity)
      }
    }
    
    var arrayListCountry : [String: Any]
    var listCountry = [[String: Any]]()
    if let mArrCountry = arrCountry {
      for i in 0..<mArrCountry.count {
        arrayListCountry = [
          "id":mArrCountry[i].id!,
          "name":mArrCountry[i].name!,
        ]
        listCountry.append(arrayListCountry)
      }
    }
    
    let parameters = [
      "addressColl": address,
      "careerColl": carrer,
      "fullNameColl": fullName,
      "phoneColl": phone,
      "desideratedCareer":list,
      "cities":listCity,
      "countries":listCountry,
      "companyName":companyName,
      "birthday":birthday == 0 ? nil : birthday,
      "contractDate":contractDate == 0 ? nil : contractDate
      ] as [String : Any]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers,status  in
      LoadingOverlay.shared.hideOverlayView()
      if let getMyProfile = try? JSONDecoder().decode(GetMyProfile.self, from: response){
        UserDataManager.currentUser = getMyProfile
        success(getMyProfile)
      }
    }, failure: { error,response,status in
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
    APIClient.request(.post, url: url, params: parameters, success: { response, headers,status in
      LoadingOverlay.shared.hideOverlayView()
      success()
    }, failure: { error,response, statusCode  in
      LoadingOverlay.shared.hideOverlayView()
      if statusCode == 200 {
        failure("Thay đổi mật khẩu thành công", statusCode)
      } else {
        if let errorResetPass = try? newJSONDecoder().decode(ErrorResetPass.self, from: response) {
          if errorResetPass.title == "incorrect_password" {
            failure("Mật khẩu không đúng, vui lòng thử lại", statusCode)
          } else {
            failure(errorResetPass.title!, statusCode)
          }
        }
      }
    })
  }
  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "facebook"
    let parameters = [
      "access_token": token
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers,status  in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error,response,status in
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
