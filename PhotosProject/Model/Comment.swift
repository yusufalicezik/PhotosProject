//
//  Comment.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

//https://jsonplaceholder.typicode.com/photos/1/comments?postId=1
import Foundation

struct Comment: Decodable {
    var postId: Int?
    var id: Int?
    var name: String?
    var body: String?
    var email: String?
}
