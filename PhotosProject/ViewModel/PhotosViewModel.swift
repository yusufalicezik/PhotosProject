//
//  AlbumViewModel.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 21.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PhotosViewModel {
    
    private let disposeBag = DisposeBag()
    
    public let photos: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
    public let errorStatus: BehaviorSubject<String> = BehaviorSubject(value: "")
    public let favoritePhotos: BehaviorRelay<[Photo]> = BehaviorRelay(value: [])
    
    init() {
        self.getAllPhotos()
    }
    
    public func getAllPhotos() {
        ServiceManager.shared.loadData(url: APIConstants.PHOTOS_LIST, type: [Photo].self)
            .subscribe(onNext: { response in
                switch response {
                case .success(let photoList):
                    self.photos.onNext(photoList)
                case .failure(let responseError):
                    switch responseError {
                    case .connectionError:
                        self.errorStatus.onNext("Bağlantı Sorunu, internet bağlantınızı kontrol edin.")
                    case .invalidRequest:
                        self.errorStatus.onNext("Geçersiz servis çağrısı")
                    case .notFound:
                        self.errorStatus.onNext("Hata! Bir şey bulunamadı.")
                    case .serverError:
                        self.errorStatus.onNext("Hata! Sunucu şuanda cevap veremiyor.")
                    default:
                        self.errorStatus.onNext("Hata!")
                    }
                }
            }).disposed(by: disposeBag)
    }
}

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
