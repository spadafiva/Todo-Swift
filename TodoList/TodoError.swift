//
//  TodoError.swift
//  TodoHomemade
//
//  Created by Joseph Spadafora on 7/4/17.
//  Copyright © 2017 self. All rights reserved.
//

import Moya


/// Possible errors when attempting to do something with the api / a todo
enum TodoError: Swift.Error {
    case miscellaneous
    case invalidOrEmptyData(Swift.Error?)
    case badStatusCode(Int)
    case moyaError(MoyaError)
}
