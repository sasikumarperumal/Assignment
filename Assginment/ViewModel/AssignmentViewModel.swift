//
//  AssignmentViewModel.swift
//  Assginment
//
//  Created by ndot on 04/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import Foundation

class AssignmentViewModel: NSObject {
    
    var urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    var errorHandler = {(error:Error) -> () in }
    
    func apiCalling( completion: @escaping (_ result:[Rows]?) -> ()) {

        APICalling().getMethodAPICalling(baseURL: urlString , apiType: ApiType.GET.rawValue) { (data) in

            do {

                let decoder = JSONDecoder()

                let getValues = try decoder.decode(Json_Base.self, from: data)

                completion(getValues.rows)

            } catch let error {
                
                self.errorHandler(error)

            }
        }
    }
}
