//
//  Album.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

struct Album: Decodable {
    var ownerUserId: Int?
    var id: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case ownerUserId = "userId"
        case id, title
    }
}
