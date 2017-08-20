//
//  ParseDataSingleton.swift
//  OnTheMap
//
//  Created by Danish Ahmed Ansari on 8/20/17.
//  Copyright © 2017 Danish Ansari. All rights reserved.
//

import Foundation

typealias ParseDataServiceResponse = (_ error: String?) -> Void
class ParseDataSingleton {
    static let sharedInstance = ParseDataSingleton()
    var studentLocations: [StudentLocation]! = []
    
    private init() {
        
    }
    
    func getStudentLocationData(methodParameters: [String: AnyObject], onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let urlComponent = parseURLFromParameters(parameters: methodParameters, path: Constants.Parse.APIPath)
        let url = urlComponent.url!
        
        print(url)
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                print("error: \(error)")
                print("url at the time of error: \(url)")
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                print(parsedResult)
                
                /* GUARD: Was there any photos and photo returned? */
                guard let studentLocations = parsedResult[Constants.ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.Results) \(parsedResult)")
                    return
                }
                
                print("studentLocations - \(studentLocations)")
                //                self.randomPage = Int(arc4random_uniform(UInt32(self.pages)))
                //                print("randomPageIndex - \(self.randomPage)")
                
                for studentLocation in studentLocations {
                    let studentLocationObj = StudentLocation(dictionary: studentLocation)
                    if self.searchStudentLocationsForExisting(student: studentLocationObj) == false {
                        self.studentLocations.append(studentLocationObj)
                    }
                }
                
                print("\nself.studentLocations - \(self.studentLocations)")
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    func postStudentLocationData(methodParameters: [String: AnyObject], onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let urlComponent = parseURLFromParameters(parameters: methodParameters, path: Constants.Parse.APIPath)
        let url = urlComponent.url!
        
        print(url)
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        request.addValue(Constants.ParseHeaderValues.ContentType, forHTTPHeaderField: Constants.ParseHeaderKeys.ContentType)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                print("error: \(error)")
                print("url at the time of error: \(url)")
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                print(parsedResult)
                
                /* GUARD: Was there any photos and photo returned? */
                guard let objectId = parsedResult[Constants.ParseResponseKeys.ObjectId] as? String, let createdAt = parsedResult[Constants.ParseResponseKeys.CreatedAt] as? String else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.ObjectId), \(Constants.ParseResponseKeys.CreatedAt) in \(parsedResult)")
                    return
                }
                
                print("ObjectId: \(objectId), \nCreatedAt: \(createdAt)")
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    func putStudentLocationData(methodParameters: [String: AnyObject], studentLocation: StudentLocation, onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let objectIDPath = studentLocation.objectId!
        let urlComponent = parseURLFromParameters(parameters: methodParameters, path: Constants.Parse.APIPath + "/" + objectIDPath)
        let url = urlComponent.url!
        
        print(url)
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        request.addValue(Constants.ParseHeaderValues.ContentType, forHTTPHeaderField: Constants.ParseHeaderKeys.ContentType)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(error: String) {
                print("error: \(error)")
                print("url at the time of error: \(url)")
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                print(parsedResult)
                
                /* GUARD: Was there any photos and photo returned? */
                guard let objectId = parsedResult[Constants.ParseResponseKeys.ObjectId] as? String, let createdAt = parsedResult[Constants.ParseResponseKeys.CreatedAt] as? String else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.ObjectId), \(Constants.ParseResponseKeys.CreatedAt) in \(parsedResult)")
                    return
                }
                
                print("ObjectId: \(objectId), \nCreatedAt: \(createdAt)")
                
                if self.findStudentFor(objectId: objectId, createdAt: createdAt) != nil {
                    print("existing student found")
                }
                
                onCompletion(nil)
            }
            catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func parseURLFromParameters(parameters: [String: AnyObject], path: String?) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.APIScheme
        components.host = Constants.Parse.APIHost
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
    
    // MARK: Helper to check for existing students in StudentLocation that will be used while adding new pins
    func searchStudentLocationsForExisting(student: StudentLocation) -> Bool {
        let result = self.studentLocations.first(where: { (studentLocation) -> Bool in
            if (studentLocation.objectId == student.objectId) && (studentLocation.createdAt == student.createdAt) && (studentLocation.updatedAt == student.updatedAt) {
                return true
            }
            else {
                return false
            }
        })
        
        if result == nil {
            return false
        }
        return true
    }
    
    func findStudentFor(objectId: String, createdAt: String) -> StudentLocation? {
        let result = self.studentLocations.first(where: { (studentLocation) -> Bool in
            if (studentLocation.objectId == objectId) && (studentLocation.createdAt == createdAt) {
                return true
            }
            else {
                return false
            }
        })
        
        if result != nil {
            return result
        }
        return nil
    }
}

