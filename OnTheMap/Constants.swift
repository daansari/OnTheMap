//
//  Constants.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation

struct Constants {
    // MARK: Udacity
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPathForSession = "/api/session"
        static let APIPathForUsers = "/api/users"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
//        "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1503178984134000&usg=AFQjCNF1aNfsX2eiy5gK4rqmiGIyrwpwsw"
    }
    
    // MARK: Udacity Account
    struct UdacityAccountKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
    }
    
    // MARK: Udacity Session
    struct UdacitySessionKeys {
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        static let XSRFTOKEN = "XSRF-TOKEN"
        static let XXSRFTOKEN = "X-XSRF-TOKEN"
    }
    
    // MARK: Udacity Header Keys
    struct UdacityHeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    // MARK: Udacity Header Values
    struct UdacityHeaderValues {
        static let Accept = "application/json"
        static let ContentType = "application/json"
    }
    
    // MARK: Parse
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
    }
    
    // MARK: Parse Header Keys
    struct ParseHeaderKeys {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    // MARK: Parse Header Values
    struct ParseHeaderValues {
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
    }
    
    // MARK: Parse Parameter Keys
    struct ParseParameterKeys {
        static let Limit = "limit" // limit=100
        static let Skip = "skip" // limit=200&skip=400
        static let Order = "order" // order=-updatedAt - Prefixing a key name with a negative sign reverses the order (default order is ascending)
        static let Where = "where"
    }
    
    // MARK: Parse Response Keys
    struct ParseResponseKeys {
        static let Results = "results"
        static let ObjectId = "objectId"
        static let CreatedAt = "createdAt"
    }
}
