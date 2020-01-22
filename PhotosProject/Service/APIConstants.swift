//
//  APIConstant.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

struct APIConstants{
    
    private static let BASE_URL = "https://jsonplaceholder.typicode.com/"
    private static let PHOTOS = "photos/"
    private static let ALBUMS = "albums/"
    private static let USERS = "users/"
    private static let COMMENTS = "comments"
    
    static var user_id: Int!
    static var album_id: Int!
    static var photo_id: Int!
    
    static var PHOTOS_LIST: String {
        return BASE_URL + PHOTOS
    }
    
    static var ALBUM: String {
        return BASE_URL + ALBUMS + String(album_id)
    }
    
    static var USER_DETAILS: String {
        return BASE_URL + USERS + String(user_id)
    }

    static var PHOTO_COMMENTS: String {
        return BASE_URL + PHOTOS + String(photo_id) + "/" + COMMENTS + "?postId=\(photo_id!)"
    }
}
