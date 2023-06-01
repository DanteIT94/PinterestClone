//
//  imageHelper.swift
//  pinterestClone
//
//  Created by Денис on 01.06.2023.
//

import Foundation
import Kingfisher
import UIKit

protocol ProfileImageHelperProtocol {
    func retrieveImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ProfileImageHelper: ProfileImageHelperProtocol {
    
    //    ✅
    func retrieveImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url, options: options) { result in
            switch result {
            case .success(let avatarResult):
                completion(.success(avatarResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
