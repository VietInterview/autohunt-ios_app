///**
/**
Created by: Hiep Nguyen Nghia on 12/7/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
struct Env {
    
    private static var production : Bool = {
        #if DEBUG
        print("DEBUG")
        return false
        #elseif ADHOC
        print("ADHOC")
        return false
        #else
        print("PRODUCTION")
        return true
        #endif
    }()
    
    static func isProduction () -> Bool {
        return self.production
    }
    static func setProductionFalse() -> Void {
        self.production = false
    }
    static func setProductionTrue() -> Void {
        self.production = true
    }
}
