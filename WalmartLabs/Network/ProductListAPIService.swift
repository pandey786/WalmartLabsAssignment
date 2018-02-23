//
//  ProductListAPIService.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 29/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ProductListAPIService {
    
    static func fetchProductList(_ productId: String, _ completionHandler: @escaping (_ productResult: ProductResultModel?, _ isError: Bool, _ error: String?) -> ()) {
        
        let productURL = API.productListUrl + "\(productId).json"
        Alamofire.request(productURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseString(completionHandler: { (responseString) in
                print(responseString.value ?? "Could not get proper response")
            })
            .responseObject { (response: DataResponse<ProductResultModel>) in
                
                switch response.result {
                case .success(let productResult):
                    
                    //Response received successfully
                    completionHandler(productResult, false, nil)
                    break
                case .failure(let error):
                    
                    //There was an error
                    completionHandler(nil, true, error.localizedDescription)
                    break
                }
        }
    }
    
}
