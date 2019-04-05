//
//  APIManager.swift
//  Assginment
//
//  Created by ndot on 04/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import Foundation

struct APIResponse {
    
    let data:Data?
    
}

enum ApiType:String {
    
    case GET = "GET"
    
    case POST = "POST"
}


class APICalling: NSObject {
    
    func getMethodAPICalling(baseURL: String,apiType:String, completion: @escaping (_ resultData:Data) -> ()) {
        
        // Encoding the URL
        let encodedUrl : String! = baseURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        // Creating a request
        var request = URLRequest.init(url:URL(string:encodedUrl)!, cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 120)
        
        request.httpMethod = apiType
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = TimeInterval(30)
        
        configuration.timeoutIntervalForResource = TimeInterval(30)
        
        
        let session = URLSession(configuration: configuration)
        
        //API Call using URLSession
        let getMethodTask = session.dataTask(with: request, completionHandler: { (data,response,error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if error != nil {
                    
                    WarningBar().show(message: "Data not available")
                    
                } else {
                    
                    if data != nil {
                        
                        do {
                            
                            let responseStrInISOLatin = String(data: data!, encoding: String.Encoding.isoLatin1)
                            
                            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                                
                                WarningBar().show(message: "could not convert data to UTF-8 format")
                                
                                return
                            }
                            
                            completion( modifiedDataInUTF8Format)
                            
                        }
                    }
                }
            })
        })
        getMethodTask.resume()
    }
    
}


