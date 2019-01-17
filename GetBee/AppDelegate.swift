//
//  AppDelegate.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // -Facebook
    //    FBSDKSettings.setAppID(ConfigurationManager.getValue(for: "FacebookKey"))
    //    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    let BarButtonItemAppearance = UIBarButtonItem.appearance()
    BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
    IQKeyboardManager.shared.enable = true
    if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
      statusBar.backgroundColor = StringUtils.shared.hexStringToUIColor(hex: "#042E51")
    }
    UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    if SessionManager.validSession {
      let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController")
      self.window?.rootViewController = vc
    }
    
    return true
  }
  
  //  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
  //    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  //  }
  
  func unexpectedLogout() {
    UserDataManager.deleteUser()
    SessionManager.deleteSession()
    //Clear any local data if needed
    //Take user to onboarding if needed, do NOT redirect the user if is already in the landing
    // to avoid losing the current VC stack state.
    if window?.rootViewController is ViewController {
      window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when 
    // the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
  }
  var onlineVersion:String?
  func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
    guard let info = Bundle.main.infoDictionary,
      let currentVersion = info["CFBundleShortVersionString"] as? String,
      let identifier = info["CFBundleIdentifier"] as? String,
      let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
        throw VersionError.invalidBundleInfo
    }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      do {
        if let error = error { throw error }
        guard let data = data else { throw VersionError.invalidResponse }
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
        guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
          throw VersionError.invalidResponse
        }
        self.onlineVersion = version
        debugLog(object: "\(version)-\(currentVersion)")
        if(Float(version)! > Float(currentVersion)!) {
          completion(true, nil)
        }else {
          completion(false, nil)
        }
      } catch {
        completion(nil, error)
      }
    }
    task.resume()
    return task
  }
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    _ = try? isUpdateAvailable { (update, error) in
      if let error = error {
        debugLog(object: error)
      } else if let update = update {
        debugLog(object: update)
        if update {
          let alert = UIAlertController(title:"Thông báo", message: "Getbee đã có phiên bản mới nhất \(self.onlineVersion != nil ? self.onlineVersion! : ""). Vui lòng cập nhật để được sử dụng các tính năng ưu việt!", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
            let urlStr = "itms://itunes.apple.com/us/app/getbee/id1445847756?ls=1&mt=8"
            if #available(iOS 10.0, *) {
              UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            } else {
              UIApplication.shared.openURL(URL(string: urlStr)!)
            }
          }))
          self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
      }
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}
