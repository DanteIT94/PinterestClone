//
//  ProfileImageService.swift
//  pinterestClone
//
//  Created by Денис on 06.05.2023.
//

import UIKit

final class ProfileImageService {
    
    static let DidChangeNotfication = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static var shared = ProfileImageService()
    let tokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    private (set) var avatarURL: String?
    
    enum ProfileImageError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {return}
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else { return}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task?.cancel()
        
        task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.smallImage
                completion(.success(userResult.profileImage.smallImage))
            case .failure(_):
                completion(.failure(ProfileImageError.decodingFailed))
            }
        }
        task?.resume()
//        NotificationCenter.default
//            .post(name: ProfileImageService.DidChangeNotfication,
//                  object: self,
//                  userInfo:  ["URL": profileImageURL])
    }
}


struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage =  "profile_image"
    }
    
    struct ProfileImage: Codable {
        let smallImage: String
    }
}


