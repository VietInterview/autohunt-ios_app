///**
/**
Created by: Hiep Nguyen Nghia on 1/23/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
import Alamofire

open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
    
    // Override this function in order to trust any self-signed https
    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return ServerTrustPolicy.disableEvaluation
    }
    
}
