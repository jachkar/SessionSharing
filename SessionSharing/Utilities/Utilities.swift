//
//  Utilities.swift
//  SessionSharing
//
//  Created by Noel Achkar on 7/24/19.
//  Copyright © 2019 Noel Achkar. All rights reserved.
//

import UIKit

let SocketServer = "http://18.203.234.135"
let SocketPort = "4000"

//struct Utilities {
//    struct Colors {
//        static let kAppBackgroundColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
//        static let kAppMykiGreenolor = UIColor(red:0.18, green:0.75, blue:0.56, alpha:1.0)
//        static let kAppBottomBackgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
//    }
//}

class Utilities : NSObject {
    class func getNextYear() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let somedateString = dateFormatter.string(from: nextYear!)
        return somedateString
    }
}

extension String {
    
    func encodeBase64() -> String {
        let utf8str = self.data(using: .utf8)
        
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0)) {
            return base64Encoded
        }
        
        return ""
    }
    
    mutating func validateUrl() -> String {
        if self.hasPrefix(".") {
           self.removeFirst()
        }
        
        if self.hasPrefix("www.") {
            self = "http://\(self)"
        } else {
            if !self.hasPrefix("http://") {
                self = "http://www.\(self)"
            }
        }
        
        return self
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArray() -> Array<Any> {
        if let data = self.data(using: .utf8) {
            do {
                return try (JSONSerialization.jsonObject(with: data, options: []) as? Array<Any>)!
            } catch {
                print(error.localizedDescription)
            }
        }
        return Array()
    }
    
    func isStringNull() -> Bool {
        if  self != "" && self != "(null)" && self != "<null>" && self != "0"  && self != "  " {
            return false
        }
        return true
    }
}

