///**
/**
Created by: Hiep Nguyen Nghia on 11/21/18
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import Foundation
/// Logs the message to the console with extra information, e.g. file name, method name and line number
///
/// To make it work you must set the "DEBUG" symbol, set it in the "Swift Compiler - Custom Flags" section, "Other Swift Flags" line.
/// You add the DEBUG symbol with the -D DEBUG entry.
public func debugLog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    let className = (fileName as NSString).lastPathComponent
    print("<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n")
}
