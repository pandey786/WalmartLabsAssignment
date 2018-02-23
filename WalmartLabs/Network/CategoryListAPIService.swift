//
//  WeatherDetailAPIService.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class CategoryListAPIService {
    
    static func fetchCategoryList( _ completionHandler: @escaping (_ categoryResult: CategoryResultModel?, _ isError: Bool, _ error: String?) -> ()) {
        
        Alamofire.request(API.categoryListUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseString(completionHandler: { (responseString) in
                print(responseString.value ?? "Could not get proper response")
            })
            .responseObject { (response: DataResponse<CategoryResultModel>) in
                
                switch response.result {
                case .success(let categoryResult):
                    
                    //Response received successfully
                    completionHandler(categoryResult, false, nil)
                    break
                case .failure(let error):
                    
                    //There was an error
                    completionHandler(nil, true, error.localizedDescription)
                    break
                }
        }
    }
 
}
