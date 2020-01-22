//
//  User.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var website: String?
    var address:Address?
}

struct Address: Decodable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?
}

struct Geo: Decodable {
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

