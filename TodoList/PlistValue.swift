//
//  PlistValue.swift
//  TodoHomemade
//
//  Created by Joseph Spadafora on 7/4/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation


/// This class is a convenient way to access information stored in a plist
/// without having to worry about the details of the filesystem
///
/// Simply just create a new PlistValue like this:
///
/// let apiUrlBase = try! PlistValue<String>(key: "ApiBaseUrlKey")
///
/// Then you can use that string just by using apiUrlBase.value to use the
/// data retrieved from a plist
///
/// The try can also be wrapped in a do - catch and will return a PlistValueError
struct PlistValue<T>{
    let value: T
    
    init(key: String, inPlist: String = "Keys") throws {
        guard let path = Bundle.main.path(forResource: inPlist,
                                          ofType: "plist"),
            let keyDict = NSDictionary(contentsOfFile: path) else {
                
            throw PlistValueError.noListAtPath
        }
        
        guard keyDict[key] != nil else {
            throw PlistValueError.noValueAtKey
        }
        
        guard let value = keyDict[key] as? T else {
            throw PlistValueError.incorrectType
        }
        
        self.value = value
    }
}

enum PlistValueError: Error {
    case noListAtPath
    case incorrectType
    case noValueAtKey
}



