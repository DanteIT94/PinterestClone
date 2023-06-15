//
//  ImagesListHelper.swift
//  pinterestClone
//
//  Created by Денис on 03.06.2023.
//

import UIKit
import Kingfisher

protocol ImagesListHelperProtocol {
    func fetchImagesListImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelImageTasks(for url: URL)
}

final class ImagesListHelper: ImagesListHelperProtocol {
    
    var fetchTasks = [URL: UIImageView]()
    //    ✅
    func fetchImagesListImage(url: URL, options: Kingfisher.KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageView = UIImageView()
        fetchTasks[url] = imageView
        imageView.kf.setImage(with: url, options: options) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                guard let image = self.fetchTasks[url]?.image else { return }
                self.fetchTasks[url] = nil
                completion(.success(image))
            case .failure(let error):
                self.fetchTasks[url] = nil
                completion(.failure(error))
            }
        }
    }
    
    //    ✅
    func cancelImageTasks(for url: URL) {
        fetchTasks[url]?.kf.cancelDownloadTask()
        fetchTasks[url] = nil
    }
    
}
