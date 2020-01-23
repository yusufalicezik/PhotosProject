//
//  DetailViewModel.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 21.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    public let selectedPhoto: ReplaySubject<Photo> = ReplaySubject<Photo>.create(bufferSize: 1)
    public let comments: PublishSubject<[Comment]> = PublishSubject<[Comment]>()
    public let album: PublishSubject<Album> = PublishSubject<Album>()
    public let ownerUser = PublishSubject<User>()
    public let errorStatus: BehaviorSubject<String> = BehaviorSubject(value: "")
    public let showLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        selectedPhoto.asObservable() //PhotoListVC den photo tıklanıldığında navigation işlemi yapılırken onNext ile tetiklenir.
            .subscribe(onNext:{ [weak self] photo in
                self?.getPhotoComment(photo)
                self?.getPhotoAlbum(photo)
                .flatMap { album in
                        (self?.getUserDetail(id: album!.ownerUserId!))!
                }.subscribe(onNext: { user in
                    self!.ownerUser.onNext(user!)
                    print("user bilgileri.. \(user!.name!)")
                }).disposed(by: self!.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    
    private func getPhotoComment(_ photo: Photo) {
        showLoading.accept(false)
        APIConstants.photo_id = photo.id!
        ServiceManager.shared.loadData(url: APIConstants.PHOTO_COMMENTS, type: [Comment].self)
            .subscribe(onNext: { [weak self] response in
                self?.showLoading.accept(true)
                switch response {
                case .success(let commentList):
                    self?.comments.onNext(commentList)
                case .failure(let requestError):
                    self?.catchErrorMessage(requestError)
                }
            }).disposed(by: disposeBag)
    }
    
    private func getPhotoAlbum(_ photo: Photo) -> Observable<Album?> {
        APIConstants.album_id = photo.albumId!
        return ServiceManager.shared.loadData(url: APIConstants.ALBUM, type: Album.self)
            .map { data -> Album? in
                switch data {
                case .success(let album):
                    return album
                case .failure(let requestError):
                    self.catchErrorMessage(requestError)
                    return nil
                }
        }.asObservable()
    }
    
    private func getUserDetail(id:Int)->Observable<User?> {
        APIConstants.user_id = id
        return ServiceManager.shared.loadData(url: APIConstants.USER_DETAILS, type: User.self)
            .map { data -> User? in
                switch data {
                case .success(let user):
                    return user
                case .failure(let requestError):
                    self.catchErrorMessage(requestError)
                    return nil
                }
        }.asObservable()
    }
    
    private func catchErrorMessage(_ requestError: RequestError ) {
        switch requestError {
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
}
