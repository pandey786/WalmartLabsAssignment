//
//  WeatherDetailModel.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 30/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//


import Foundation
import ObjectMapper

struct CategoryResultModel: Mappable {
    
    var displayName: String?
    var type: String?
    var contents: [CategoryListModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        displayName       <- map["displayName"]
        type       <- map["@type"]
        contents       <- map["contents"]
    }
}

struct CategoryListModel: Mappable {
    
    var displayName: String?
    var id: Int?
    var active: Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        displayName       <- map["displayName"]
        id       <- map["id"]
        active       <- map["active"]
    }
}
