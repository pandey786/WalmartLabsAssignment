//
//  ProductList.swift
//  WalmartLabs
//
//  Created by Durgesh Pandey on 30/01/18.
//  Copyright © 2018 Durgesh Pandey. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProductResultModel: Mappable {
    
    var records: [ProductListModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        records       <- map["records"]
    }
}

struct ProductListModel: Mappable {
    
    var numRecords: Int?
    var Brand: String?
    var records: [ProductModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        numRecords       <- map["numRecords"]
        Brand       <- map["attributes.Brand"]
        records       <- map["attributes.records"]
    }
}


struct ProductModel: Mappable {
    
    var productId: String?
    var productCategoryId: String?
    var productImageUrl: String?
    var skuDisplayName: String?
    var productDisplayName: String?
    var productDescription: String?
    var skuFinalPrice: String?
    var skuLastPrice: String?
    var maxQuantity: String?
    var priceStrikeOff: String?
    var inventoryTotal: String?
    var productOfferBuy: Int?
    var productOfferFree: Int?
    var inventoryUsed: String?
    var productTag: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        //Need to manually Parse as it is not proper JSON Format parsable by ObjectMapper
        let currentDict = map.JSON
        productId = currentDict["product.id"] as? String
        productCategoryId = currentDict["product/category/id"] as? String
        productImageUrl = currentDict["product.image.url"] as? String
        skuDisplayName = currentDict["sku.displayName"] as? String
        productDisplayName = currentDict["product.displayName"] as? String
        productDescription  = currentDict["product.description"] as? String
        skuFinalPrice   = currentDict["sku.finalPrice"] as? String
        skuLastPrice   = currentDict["sku.lastPrice"] as? String
        maxQuantity     =  currentDict["maxQuantity"] as? String
        priceStrikeOff     = currentDict["priceStrikeOff"] as? String
        inventoryTotal      = currentDict["inventoryTotal"] as? String
        
        //parse product offer
        if let productOffer: [String: Any] = currentDict["product.offer"] as? [String : Any] {
            productOfferBuy = productOffer["buy"] as? Int
            productOfferFree = productOffer["free"] as? Int
        }
        
        productTag      = currentDict["product.tag"] as? String
        inventoryUsed     =  currentDict["inventoryUsed"] as? String
        
    }
}
