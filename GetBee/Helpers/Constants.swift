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
    //Server dev
    static let baseUrl = "https://api.dev.getbee.vn"
    static let imgUrl = "https://dev.getbee.vn/"
    //Server real
//    static let baseUrl = "https://api.getbee.vn"
//    static let imgUrl = "https://getbee.vn/"
    static func error(domain: ErrorDomain = .generic, code: Int? = nil, localizedDescription: String = "") -> NSError {
        return NSError(domain: App.domain + "." + domain.rawValue,
                       code: code ?? 0,
                       userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

enum ErrorDomain: String {
    case generic = "GenericError"
    case parsing = "ParsingError"
}
