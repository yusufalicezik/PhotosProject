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
import Reachability

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfPhoto>!
    private let reachability = try! Reachability()
    
    
    public let photosListViewModel = PhotosListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        try! reachability.startNotifier()
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
    private func setupBindings() {
        photosListViewModel.photos
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] photos in
                self?.setTableViewDataSource()
            }).disposed(by: disposeBag)
        
        photosListViewModel.favoritePhotos
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] photos in
                self?.setTableViewDataSource()
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Photo.self)
            .asDriver()
            .drive(onNext: { [unowned self] photo in
                self.goToDetailsVC(photo: photo)
            }).disposed(by: disposeBag)
        
        photosListViewModel.showLoading
            .observeOn(MainScheduler.instance)
            .bind(to: loadingIndicator.rx.isHidden).disposed(by: disposeBag)
        
        photosListViewModel.errorStatus.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
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
            SectionOfPhoto(header: "Favoriler", items: photosListViewModel.favoritePhotos.value),
            SectionOfPhoto(header: "Tüm Fotoğraflar", items: try! photosListViewModel.photos.value())
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func goToDetailsVC(photo: Photo) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? PhotoDetailViewCotroller
        vc?.detailViewModel.selectedPhoto.onNext(photo)
        vc?.photosListViewModel = self.photosListViewModel
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        default:
            showAlert(message: "İnternet Erişimi yok")
        }
    }
}


//        _ = photosViewModel.photos.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PhotoCell.self)){_,photo,cell in
//            cell.photoVM = PhotoViewModel(photo)
//        }
