//
//  Constants.swift
//  ios-base
//
//  Created by German Lopez on 3/29/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation

//Add global constants here

struct App {
    static let domain = Bundle.main.bundleIdentifier!
    var env = Env.init()
    static var baseUrl = Env.isProduction() ? "https://api.getbee.vn" : "https://api.dev.getbee.vn"
    static var imgUrl = Env.isProduction() ? "https://getbee.vn/" : "https://dev.getbee.vn/"
    static func error(domain: ErrorDomain = .generic, code: Int? = nil, localizedDescription: String = "") -> NSError {
        return NSError(domain: App.domain + "." + domain.rawValue, code: code ?? 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    static func setBaseUrlDev() -> Void {
        self.baseUrl = "https://api.dev.getbee.vn"
        self.imgUrl = "https://dev.getbee.vn/"
    }
    static func setBaseUrl() -> Void {
        self.baseUrl = "https://api.getbee.vn"
        self.imgUrl = "https://getbee.vn/"
    }
}

enum ErrorDomain: String {
    case generic = "GenericError"
    case parsing = "ParsingError"
}
