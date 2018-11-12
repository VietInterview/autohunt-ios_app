//
//  Session.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation

class Session: Codable {
  var accessToken: String?
  
  private enum CodingKeys: String, CodingKey {
    case accessToken = "id_token"
  }

  init(token: String? = nil) {
    self.accessToken = token
  }
  
  init?(headers: [String: Any]) {
    var loweredHeaders = headers
    loweredHeaders.lowercaseKeys()
    guard let stringHeaders = loweredHeaders as? [String: String] else {
      return nil
    }
    accessToken = stringHeaders[APIClient.HTTPHeader.token.rawValue]
  }
  
  //MARK: Codable
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(accessToken, forKey: .accessToken)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    accessToken = try container.decode(String.self, forKey: .accessToken)
  }
}
