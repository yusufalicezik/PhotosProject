//
//  CommentViewModel.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 23.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation

struct CommentViewModel {
    private var comment: Comment
    
    init(_ comment: Comment){
        self.comment = comment
    }
}

extension CommentViewModel {
    
    var username: String {
        return self.comment.name!
    }
    
    var email: String {
        return self.comment.email!
    }
    
    var commentText: String {
        return self.comment.body!
    }
}
