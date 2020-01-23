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

struct PhotosListViewModel {
    
    private let disposeBag = DisposeBag()
    
    public let photos: BehaviorSubject<[Photo]> = BehaviorSubject(value: [])
    public let favoritePhotos: BehaviorRelay<[Photo]> = BehaviorRelay(value: [])
    public let errorStatus: PublishSubject<String> = PublishSubject<String>()
    public let showLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        self.getAllPhotos()
    }
    
    public func getAllPhotos() {
        showLoading.accept(false)
        ServiceManager.shared.loadData(url: APIConstants.PHOTOS_LIST, type: [Photo].self)
            .subscribe(onNext: { response in
                self.showLoading.accept(true)
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
