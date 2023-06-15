//
//  ImageListPresenter.swift
//  pinterestClone
//
//  Created by Денис on 01.06.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var photos: [Photo] {get}
//    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
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
