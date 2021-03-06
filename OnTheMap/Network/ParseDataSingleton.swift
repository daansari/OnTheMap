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
    var studentLocationSingleton: StudentLocationSingleton = StudentLocationSingleton.sharedInstance
    
    private init() {
        
    }
    
    func getStudentLocationData(methodParameters: [String: AnyObject], onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let urlComponent = parseURLFromParameters(parameters: methodParameters, path: Constants.Parse.APIPath)
        let url = urlComponent.url!
        
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let studentLocations = parsedResult[Constants.ParseResponseKeys.Results] as? [[String: AnyObject]] else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.Results) \(parsedResult)")
                    return
                }
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("studentLocations - \(studentLocations)")
                }

                for studentLocation in studentLocations {
                    let studentLocationObj = StudentLocation(dictionary: studentLocation)
                    if self.searchStudentLocationsForExisting(student: studentLocationObj) == false {
                        self.studentLocationSingleton.studentLocations.append(studentLocationObj)
                    }
                }
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("\nself.studentLocations - \(self.studentLocationSingleton.studentLocations)")
                }
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
    
    func postStudentLocationData(methodParameters: [String: AnyObject], onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let urlComponent = Constants.Parse.APIScheme + "://" + Constants.Parse.APIHost + Constants.Parse.APIPath
        let url = URL(string: urlComponent)!
        
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        request.addValue(Constants.ParseHeaderValues.ContentType, forHTTPHeaderField: Constants.ParseHeaderKeys.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(UserDefaults.standard.string(forKey: Constants.UdacityAccountKeys.Key)!)\", \"firstName\": \"\(UserDefaults.standard.string(forKey: Constants.Udacity.FirstName)!)\", \"lastName\": \"\(UserDefaults.standard.string(forKey: Constants.Udacity.LastName)!)\",\"mapString\": \"\(methodParameters["mapString"] as! String)\", \"mediaURL\": \"\(methodParameters["mediaURL"] as! String)\",\"latitude\": \(methodParameters["latitude"] as! Double), \"longitude\": \(methodParameters["longitude"] as! Double)}".data(using: String.Encoding.utf8)
        
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let objectId = parsedResult[Constants.ParseResponseKeys.ObjectId] as? String, let createdAt = parsedResult[Constants.ParseResponseKeys.CreatedAt] as? String else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.ObjectId), \(Constants.ParseResponseKeys.CreatedAt) in \(parsedResult)")
                    return
                }

                let studentLocationDict = [
                    "objectId": objectId,
                    "uniqueKey": UserDefaults.standard.string(forKey: Constants.UdacityAccountKeys.Key)!,
                    "firstName": UserDefaults.standard.string(forKey: Constants.Udacity.FirstName)!,
                    "lastName": UserDefaults.standard.string(forKey: Constants.Udacity.LastName)!,
                    "mapString": methodParameters["mapString"] as! String,
                    "mediaURL": methodParameters["mediaURL"] as! String,
                    "latitude": methodParameters["latitude"] as! Double,
                    "longitude": methodParameters["longitude"] as! Double,
                    "createdAt": createdAt,
                    "updatedAt": createdAt
                ] as [String : Any]
                
                let studentLocation = StudentLocation.init(dictionary: studentLocationDict)
                self.studentLocationSingleton.studentLocations.insert(studentLocation, at: 0)
                
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("ObjectId: \(objectId), \nCreatedAt: \(createdAt)")
                }
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
    
    func putStudentLocationData(methodParameters: [String: AnyObject], studentLocation: StudentLocation, onCompletion: @escaping ParseDataServiceResponse) -> Void {
        let objectIDPath = studentLocation.objectId!
        let urlComponent = Constants.Parse.APIScheme + "://" + Constants.Parse.APIHost + Constants.Parse.APIPath + "/" + objectIDPath
        let url = URL(string: urlComponent)!
        
        if Constants.ModeKey.Environment == Constants.ModeValue.Development {
            print(url)
        }
        
        // TODO: Make request to Flickr!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(Constants.ParseHeaderValues.ParseApplicationID, forHTTPHeaderField: Constants.ParseHeaderKeys.ParseApplicationID)
        request.addValue(Constants.ParseHeaderValues.RestAPIKey, forHTTPHeaderField: Constants.ParseHeaderKeys.RestAPIKey)
        request.addValue(Constants.ParseHeaderValues.ContentType, forHTTPHeaderField: Constants.ParseHeaderKeys.ContentType)
        request.httpBody = "{\"uniqueKey\": \"\(UserDefaults.standard.string(forKey: Constants.UdacityAccountKeys.Key)!)\", \"firstName\": \"\(UserDefaults.standard.string(forKey: Constants.Udacity.FirstName)!)\", \"lastName\": \"\(UserDefaults.standard.string(forKey: Constants.Udacity.LastName)!)\",\"mapString\": \"\(methodParameters["mapString"] as! String)\", \"mediaURL\": \"\(methodParameters["mediaURL"] as! String)\",\"latitude\": \(methodParameters["latitude"] as! Double), \"longitude\": \(methodParameters["longitude"] as! Double)}".data(using: String.Encoding.utf8)

        
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
                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print(parsedResult)
                }
                
                /* GUARD: Was there any photos and photo returned? */
                guard let objectId = parsedResult[Constants.ParseResponseKeys.ObjectId] as? String, let createdAt = parsedResult[Constants.ParseResponseKeys.CreatedAt] as? String else {
                    displayError(error: "Cannot find keys - \(Constants.ParseResponseKeys.ObjectId), \(Constants.ParseResponseKeys.CreatedAt) in \(parsedResult)")
                    return
                }
               
                if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                    print("ObjectId: \(objectId), \nCreatedAt: \(createdAt)")
                }
                
                if self.findStudentFor(objectId: objectId, createdAt: createdAt) != nil {
                    if Constants.ModeKey.Environment == Constants.ModeValue.Development {
                        print("existing student found")
                    }
                }
                var studentLocation = studentLocation
                studentLocation.mapString = methodParameters["mapString"] as? String
                studentLocation.mediaURL = methodParameters["mediaURL"] as? String
                studentLocation.latitude = methodParameters["latitude"] as? Double
                studentLocation.longitude = methodParameters["longitude"] as? Double
                studentLocation.updatedAt = methodParameters["updatedAt"] as? String
                
                
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
        let result = self.studentLocationSingleton.studentLocations.first(where: { (studentLocation) -> Bool in
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
        let result = self.studentLocationSingleton.studentLocations.first(where: { (studentLocation) -> Bool in
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

