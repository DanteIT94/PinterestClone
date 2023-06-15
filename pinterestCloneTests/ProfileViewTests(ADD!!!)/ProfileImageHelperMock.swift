//
//  ProfileImageHelperMock.swift
//  ProfileViewTests
//
//  Created by Денис on 01.06.2023.
//

@testable
import pinterestClone
import Kingfisher
import UIKit

final class ProfileImageHelperMock: ProfileImageHelperProtocol {
    func retrieveImage(url: URL, options: Kingfisher.KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if url == ImageURLMock.successURL {
            completion(.success(ImagesMock.successImage))
        } else if url == ImageURLMock.failureURL {
            completion(.failure(KingfisherError.requestError(reason: .emptyRequest)))
        }
    }
    
}
