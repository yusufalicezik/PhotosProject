//
//  Photo.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
}
