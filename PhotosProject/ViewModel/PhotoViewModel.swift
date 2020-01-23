//
//  PhotoViewModel.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 23.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

//MARK:- SinglePhotoVM

struct PhotoViewModel {
    private var photo: Photo
    
    init(_ photo: Photo) {
        self.photo = photo
    }
}

extension PhotoViewModel {
    
    var imageUrl: URL {
        return URL(string: photo.url!)!
    }
    
    var imageTitle: String {
        return photo.title!
    }
}
