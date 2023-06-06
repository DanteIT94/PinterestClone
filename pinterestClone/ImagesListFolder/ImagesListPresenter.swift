//
//  ImageListPresenter.swift
//  pinterestClone
//
//  Created by Денис on 01.06.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var photos: [Photo] {get}
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func fetchPhotosNextPage()
    func cancelImageDownloadTask(for url: URL)
    func likeButtonTapped(for indexPath: IndexPath, completion: @escaping (Bool) -> Void)
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Public Properties
    var view: ImagesListViewControllerProtocol?
    
    
    //MARK: - Private Properties
    private (set) var photos: [Photo] = []
    
    private var imagesListHelper: ImagesListHelperProtocol
    private let imagesListService: ImagesListServiceProtocol
    
    //MARK: -Initializer
    init(imagesListHelper: ImagesListHelperProtocol, imagesListServise: ImagesListServiceProtocol) {
        self.imagesListHelper = imagesListHelper
        self.imagesListService = imagesListServise
        
        NotificationCenter.default.addObserver(
            forName: imagesListServise.DidChangeNotification,
            object: nil,
            queue: .main) { [ weak self] _ in
                self?.updateTableView()
            }
    }
    
    
    
    //MARK: - Public Methods
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let date = photos[indexPath.row].createdAt else { return }
        let dateString = date.dateTimeString
        
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else {return}
        cell.setAnimatedGradient()
        cell.cellImage.kf.indicatorType = .activity
        
        imagesListHelper.fetchImagesListImage(url: url, options: nil) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let image):
                view?.configureCellElements(cell: cell, image: image, date: dateString, isLiked: photos[indexPath.row].likedByUser, imageURL: url)
            case .failure(_):
                guard let placeholderImage = UIImage(named: "image_placeholder") else { return }
                view?.configureCellElements(cell: cell, image: placeholderImage, date: "Error", isLiked: false, imageURL: url)
            }
            /// эффект нажатия на ячейку без серого выделения
            let selectedView = UIView()
            /// Устанавливаем цвет фона
            selectedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            cell.selectedBackgroundView = selectedView
        }
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        view?.updateTableViewAnimated(from: oldCount, to: newCount)
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func likeButtonTapped(for indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.likedByUser) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    completion(true)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func cancelImageDownloadTask(for url: URL) {
        imagesListHelper.cancelImageTasks(for: url)
    }
}
