//
//  PlistTests.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/19/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Quick
import Nimble
@testable import TodoList

class PlistTests: QuickSpec {
    override func spec() {
        let validKey = "baseUrl"
        let invalidKey = "foo"
        let invalidPlist = "bar"
        
        describe("plist tests") {
            
            it("throws a no list error for an invalid file path or missing file") {
             
                expect { try PlistValue<String>(key: validKey, inPlist: invalidPlist) }
                    .to(throwError(PlistValueError.noListAtPath))
                
            }
            
            it("throws no value at key error for an invalid key") {
                expect { try PlistValue<String>(key: invalidKey) }
                    .to(throwError(PlistValueError.noValueAtKey))

            }
            
            it("throws a wrong type error for an invalid type") {
                expect { try PlistValue<Int>(key: validKey) }
                    .to(throwError(PlistValueError.incorrectType))

            }
            
        }
    }
}

/*
func testValidPlist() {
    do {
        let apiBase = try PlistValue<String>(key: "baseUrl")
        
        assert(apiBase.value != nil, "Api url does not exist")
        
    } catch {
        XCTFail("Plist could not be found")
    }
}

func testInvalidKey() {
    do {
        let shouldFail = try PlistValue<String>(key: "invalidKey")
        
        XCTFail("key should not exist")
        
    } catch {
        
    }
}

func testInvalidPath() {
    do {
        let noPath = try PlistValue<String>(key: "baseUrl", inPlist: "notAPlist")
    } catch let error {
        guard let plistError = error as? PlistValueError else {
            XCTFail("incorrect error returned")
            return
        }
        
        guard case .incorrectFormat = plistError else {
            XCTFail("incorrect error returned")
            return
        }
        
    }
}

*/
