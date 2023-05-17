//
//  ImagesListService.swift
//  pinterestClone
//
//  Created by Денис on 17.05.2023.
//

import UIKit

class ImagesListService {
    //MARK: - Public Propeties
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    let tokenStorage = OAuth2TokenStorage()
    
    //MARK: - Private Properties
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
//    private var isFetchingNextPage = false
    
    func fetchPhotosNextPage() {
        guard let token = tokenStorage.token else {return}
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        let perPage = 10 //Количество фотографий на странице
        
        //ЖДУ ИНФОРМАЦИИ
        let urlString = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL:", urlString)
            return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult],Error>) in
            guard let self = self else { return }
            defer {
                self.task = nil
            }
            
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    let newPhotos = photoResults.map { photoResults -> Photo? in
                         let regularURLString = photoResults.urls.regular
                              let regularURL = URL(string: regularURLString)
                        
                        guard let imageData = try? Data(contentsOf: regularURL!),
                              let image = UIImage(data: imageData) else {
                            return nil
                        }
                        let photo = Photo(
                            id: photoResults.id,
                            size: image.size,
                            createdAt: photoResults.createdAt,
                            welcomeDescription: photoResults.description,
                            thumbImageURL: photoResults.urls.thumb,
                            largeImageURL: photoResults.urls.full,
                            isLiked: false
                        )
                        return photo
                    }.compactMap { $0 }
                    self.photos.append(contentsOf: newPhotos)
                    
                    ///Оповещаем об изменении массива фотографий
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                }
            case .failure(let error):
                print("Failed to fetch photos:", error)
            }
        }
    }
}
