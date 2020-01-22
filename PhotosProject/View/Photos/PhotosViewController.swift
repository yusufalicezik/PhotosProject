//
//  ViewController.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 20.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfPhoto>!
    
    let photosViewModel = PhotosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 135
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden  = true
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.9311670661, green: 0.2990694046, blue: 0.3270647526, alpha: 1)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Photos List (Fav ve tüm fotolar)
    private func setupBindings(){
        photosViewModel.photos
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] photos in
                self?.setTableViewDataSource()
            }).disposed(by: disposeBag)
        
        photosViewModel.favoritePhotos
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] photos in
            self?.setTableViewDataSource()
        }).disposed(by: disposeBag)
        
//        tableView.rx.itemSelected.subscribe(onNext: { [weak self] in
//                self?.goToDetailsVC(indexPath: $0)
//            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Photo.self)
        .asDriver()
            .drive(onNext: { [unowned self] photo in
                self.goToDetailsVC(photo: photo)
            }).disposed(by: disposeBag)
    }
    
    func setTableViewDataSource() {
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        dataSource = RxTableViewSectionedReloadDataSource<SectionOfPhoto>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoCell
                cell!.photoVM = PhotoViewModel(item)
                return cell!
            })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        let sections = [
            SectionOfPhoto(header: "Favoriler", items: photosViewModel.favoritePhotos.value),
            SectionOfPhoto(header: "Tüm Fotoğraflar", items: try! photosViewModel.photos.value())
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
  }
    
    private func goToDetailsVC(photo: Photo) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsVC") as? PhotoDetailViewCotroller
        vc?.detailViewModel.selectedPhoto.onNext(photo)
        vc?.photosViewModel = self.photosViewModel
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//        _ = photosViewModel.photos.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PhotoCell.self)){_,photo,cell in
//            cell.photoVM = PhotoViewModel(photo)
//        }
