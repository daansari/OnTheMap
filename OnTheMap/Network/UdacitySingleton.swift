//
//  UdacitySingleton.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation

typealias UdacityServiceResponse = (_ error: String?) -> Void
class UdacitySingleton {
    static let sharedInstance = UdacitySingleton()
    var studentLocationSingleton: StudentLocationSingleton = StudentLocationSingleton.sharedInstance
    
    private init() {
        
    }
    
    func postLoginSessionForStudent(methodParameters: [String: AnyObject], onCompletion: @escaping UdacityServiceResponse) -> Void {
        let session = URLSession.shared
        let urlString = Constants.Udacity.APIScheme + "://" + Constants.Udacity.APIHost + Constants.Udacity.APIPathForSession
        let url = URL(string: urlString)!
            if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        var request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Constants.UdacityHeaderValues.Accept, forHTTPHeaderField: Constants.UdacityHeaderKeys.Accept)
        request.addValue(Constants.UdacityHeaderValues.ContentType, forHTTPHeaderField: Constants.UdacityHeaderKeys.ContentType)
        request.httpBody = "{\"udacity\": {\"username\": \"\(methodParameters["username"] as! String)\", \"password\": \"\(methodParameters["password"] as! String)\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func displayError(error: String) {
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("error: \(error)")
                    print("url at the time of error: \(url)")
                }
                onCompletion(error)
            }
            
            /* GUARD: Was there any error returned? */
            guard (error == nil) else {
                displayError(error: "There was an error in your request - \((error?.localizedDescription)!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(error: "No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get successful 2XX reponse */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError(error: "Your request sent a status code other than 2XX!")
                return
            }
            
            do {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let account = parsedResult[Constants.UdacityAccountKeys.Account] as? [String: AnyObject], let session = parsedResult[Constants.UdacitySessionKeys.Session] as? [String: AnyObject] else {
                    displayError(error: "Cannot find keys - \(Constants.UdacityAccountKeys.Account), \(Constants.UdacitySessionKeys.Session) in \(parsedResult)")
                    return
                }
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("account - \(account)")
                    print("session - \(session)")
                }
                
                // Add values to UserDefaults for use while checking session on app launches
                UserDefaults.standard.set(account[Constants.UdacityAccountKeys.Registered], forKey: Constants.UdacityAccountKeys.Registered)
                UserDefaults.standard.set(account[Constants.UdacityAccountKeys.Key], forKey: Constants.UdacityAccountKeys.Key)                
                UserDefaults.standard.set(account[Constants.UdacitySessionKeys.Id], forKey: Constants.UdacitySessionKeys.Id)
                UserDefaults.standard.set(account[Constants.UdacitySessionKeys.Expiration], forKey: Constants.UdacitySessionKeys.Expiration)
                UserDefaults.standard.synchronize()
                
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                onCompletion("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    func deleteLoginSessionForStudent(methodParameters: [String: AnyObject], onCompletion: @escaping UdacityServiceResponse) -> Void {
        let urlString = Constants.Udacity.APIScheme + "://" + Constants.Udacity.APIHost + Constants.Udacity.APIPathForSession
        let url = URL(string: urlString)!
        
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("error: \(error)")
                    print("url at the time of error: \(url)")
                }
                onCompletion(error)
            }
            
            /* GUARD: Was there any error returned? */
            guard (error == nil) else {
                displayError(error: "There was an error in your request - \((error?.localizedDescription)!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(error: "No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get successful 2XX reponse */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError(error: "Your request sent a status code other than 2XX!")
                return
            }
            
            do {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let session = parsedResult[Constants.UdacitySessionKeys.Session] as? [String: AnyObject] else {
                    displayError(error: "Cannot find keys - \(Constants.UdacitySessionKeys.Session) in \(parsedResult)")
                    return
                }
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("session - \(session)")
                }
                
                // Remove objects from UserDefaults
                UserDefaults.standard.removeObject(forKey: Constants.UdacityAccountKeys.Registered)
                UserDefaults.standard.removeObject(forKey: Constants.UdacityAccountKeys.Key)
                UserDefaults.standard.removeObject(forKey: Constants.UdacitySessionKeys.Id)
                UserDefaults.standard.removeObject(forKey: Constants.UdacitySessionKeys.Expiration)
                UserDefaults.standard.removeObject(forKey: Constants.Udacity.FirstName)
                UserDefaults.standard.removeObject(forKey: Constants.Udacity.LastName)
                UserDefaults.standard.synchronize()
                
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                onCompletion("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    func getInfoFromUdacityForUser(methodParameters: [String: AnyObject], onCompletion: @escaping UdacityServiceResponse) -> Void {
        let urlString = Constants.Udacity.APIScheme + "://" + Constants.Udacity.APIHost +  Constants.Udacity.APIPathForUsers + "/" + UserDefaults.standard.string(forKey: Constants.UdacityAccountKeys.Key)!
        let url = URL(string: urlString)!
        
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("error: \(error)")
                    print("url at the time of error: \(url)")
                }
                onCompletion(error)
            }
            
            /* GUARD: Was there any error returned? */
            guard (error == nil) else {
                displayError(error: "There was an error in your request - \((error?.localizedDescription)!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(error: "No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get successful 2XX reponse */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError(error: "Your request sent a status code other than 2XX!")
                return
            }
            
            do {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String : AnyObject]
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult as Any)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let user = parsedResult!["user"] as? [String: AnyObject] else {
                    displayError(error: "Cannot find keys - \(Constants.UdacitySessionKeys.Session) in \(parsedResult!)")
                    return
                }
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("user - \(user)")
                }
                
                guard let firstName = user[Constants.Udacity.FirstName] as? String, let lastName = user[Constants.Udacity.LastName] as? String else {
                    displayError(error: "Cannot find keys - \(Constants.Udacity.FirstName), \(Constants.Udacity.LastName) in \(parsedResult!)")
                    return
                }
                
                // Set first and last name to UserDefaults for using during Add Pin Functionatlity
                UserDefaults.standard.set(firstName, forKey: Constants.Udacity.FirstName)
                UserDefaults.standard.set(lastName, forKey: Constants.Udacity.LastName)
                UserDefaults.standard.synchronize()
                
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                onCompletion("Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func parseURLFromParameters(parameters: [String: AnyObject], path: String?) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = Constants.Udacity.APIScheme
        components.host = Constants.Udacity.APIHost
        if path != nil {
            components.path = path!
        }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components
    }
}
