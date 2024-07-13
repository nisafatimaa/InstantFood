//
//  CountryModel.swift
//  InstantFood
//
//  Created by Macbook Pro on 09/07/2024.
//

import Foundation

//custon typealias for protocols
typealias MyJSONModel = Codable & Equatable

struct Country : MyJSONModel {
    var code : String
    var name : String
    
    // Equatable conformance for checking selected countries duplicate
       static func ==(lhs: Country, rhs: Country) -> Bool {
           return lhs.code == rhs.code && lhs.name == rhs.name
       }
}
