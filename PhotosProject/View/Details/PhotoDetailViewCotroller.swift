//
//  PhotoDetailViewCotroller.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 21.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class PhotoDetailViewCotroller: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameSurnameLabel: UILabel! //fullname
    @IBOutlet weak var usernameLabel: UILabel! //@
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let photoImageUrl = PublishSubject<String>()
    private var currentPhoto:Photo!
    private var isExist = BehaviorSubject<Bool>(value: false)
    private var favButtonAction: (()->Void)!
    
    public let detailViewModel = DetailViewModel()
    public var photosViewModel: PhotosViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        commentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        self.setupBindings()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButtonClicked(_ sender: Any) {
        self.favButtonAction()
    }
    
    private func addFavAction() {
        var photos = photosViewModel.favoritePhotos.value
        photos.append(currentPhoto)
        self.photosViewModel.favoritePhotos.accept(photos)
    }
    
    private func removeFavAction() {
            
        let oldPhotos = photosViewModel.favoritePhotos.value
        photosViewModel.favoritePhotos.accept(oldPhotos.filter( { $0.id! != currentPhoto.id!}))
        
//        self.photosViewModel.favoritePhotos
//            .observeOn(MainScheduler.instance)
//            .map { photoList -> Observable<[Photo]> in
//                return Observable.just(photoList.filter { $0.id! != self.currentPhoto.id! })  //remove currentPhoto
//        }.bind(to: photosViewModel.favoritePhotos)
//        .disposed(by: disposeBag)
    }
    
    //MARK:- Binding
    
    private func setupBindings() {
        
        isExist.subscribe(onNext: { [weak self] isExist in
            if isExist {
                DispatchQueue.main.async {
                    self!.favButton.setTitle("Favorilerden Çıkar", for: .normal)
                }
                self?.favButtonAction = self?.removeFavAction
            }else{
                DispatchQueue.main.async {
                    self!.favButton.setTitle("Favorilere Ekle", for: .normal)
                }
                self?.favButtonAction = self?.addFavAction
            }
            }).disposed(by: disposeBag)
        
        detailViewModel.ownerUser
            .observeOn(MainScheduler.instance)
            .map { user -> String in
                return user.name!
            }.bind(to: usernameSurnameLabel.rx.text)
            .disposed(by: disposeBag)
        
        detailViewModel.ownerUser
            .observeOn(MainScheduler.instance)
            .map { user -> String in
                return "@\(user.username!)"
            }.bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        detailViewModel.selectedPhoto
            .map { photo -> String in
                self.currentPhoto = photo
                return photo.title!
            }.bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        detailViewModel.selectedPhoto
            .subscribe(onNext: { [weak self] photo in
                DispatchQueue.main.async {
                    self?.photoImageView.sd_setImage(with: URL(string: photo.url!)!, completed: nil)
                }
            })
            .disposed(by: disposeBag)
        
        photosViewModel.favoritePhotos
            .map { photo -> Bool in
                return photo.contains { $0.id! == self.currentPhoto.id!}
            }.bind(to: self.isExist)
            .disposed(by: disposeBag)
        
        _ = detailViewModel.comments.bind(to: commentTableView.rx.items(cellIdentifier: "commentCell", cellType: CommentCell.self)){_,comment,cell in
            cell.commentVM = CommentViewModel(comment)
        }
    }
}
