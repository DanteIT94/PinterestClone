//
//  ProfileImageService.swift
//  pinterestClone
//
//  Created by Денис on 06.05.2023.
//

import UIKit

final class ProfileImageService {
    enum ProfileImageError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }
    //MARK: -Properties
    static let DidChangeNotfication = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static var shared = ProfileImageService()
    private init() {}
    
    let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    
//MARK: - Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = tokenStorage.token else {return}
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else { return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.small
                if let avatarURL = self?.avatarURL {
                    completion(.success(userResult.profileImage.small))
                    NotificationCenter.default.post(name: ProfileImageService.DidChangeNotfication,
                                                    object: self,
                                                    userInfo:  ["URL": userResult.profileImage.small])
                } else {
                    completion(.failure(ProfileImageError.invalidData))
                }
                self?.task = nil
            case .failure(_):
                completion(.failure(ProfileImageError.decodingFailed))
            }
        }
        task = dataTask
        task?.resume()
    }
}

//MARK: -Structs
struct UserResult: Codable {
    let profileImage: ProfileImage
    
//    enum CodingKeys: String, CodingKey {
//        case profileImage =  "profile_image"
//    }
    
    struct ProfileImage: Codable {
        let small: String
    }
}


