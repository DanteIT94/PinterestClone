//
//  ImagesListService.swift
//  pinterestClone
//
//  Created by Денис on 17.05.2023.
//

import Foundation

class ImagesListService {
    //MARK: - Public Propeties
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    let tokenStorage = OAuth2TokenStorage()
    //MARK: - Private Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()

//MARK: - Methods
    func fetchPhotosNextPage() {
        guard task == nil else {return}
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com")
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
        URLQueryItem(name: "page", value: "\(nextPage)")
        ]

        guard let url = urlComponents?.url else { return }
  
        var request = URLRequest(url: url)
        guard let token = tokenStorage.token else {return}
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult],Error>) in
            guard let self = self else { return }
            print(result)
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    for photoResult in photoResults {
                        self.photos.append(self.convertPhoto(photoResult))
                    }
                    ///Оповещаем об изменении массива фотографий
                    NotificationCenter.default.post(
                                                    name: ImagesListService.DidChangeNotification,
                                                    object: nil)
                    self.lastLoadedPage = nextPage
                    self.task = nil
                }
            case .failure(let error):
                print("Failed to fetch photos:", error)
                task = nil
                return
            }
        }
        task = dataTask
        task?.resume()
    }
    
    private func convertPhoto(_ photoResult: PhotoResult) -> Photo {
        let createdAt = photoResult.createdAt ?? ""
        
        let photo = Photo(id: photoResult.id,
                          size: CGSize(width: photoResult.width, height: photoResult.height),
                          createdAt: dateFormatter.date(from: createdAt),
                          welcomeDescription: photoResult.description,
                          thumbImageURL: photoResult.urls.thumb,
                          largeImageURL: photoResult.urls.full,
                          isLiked: true
        )
        return photo
    }
}
