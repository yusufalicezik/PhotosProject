//
//  SectionOfPhoto.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 22.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfPhoto {
    var header: String //Favs, all photos
    var items: [Photo]
}

extension SectionOfPhoto: SectionModelType {
  typealias Item = Photo

   init(original: SectionOfPhoto, items: [Item]) {
    self = original
    self.items = items
  }
}
