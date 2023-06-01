//
//  ProfileImageService.swift
//  pinterestClone
//
//  Created by Денис on 06.05.2023.
//

import UIKit

protocol ProfileImageServiceProtocol: AnyObject {
    var DidChangeNotfication: Notification.Name {get}
    var avatarURL: String? {get}
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService:  ProfileImageServiceProtocol {
    enum ProfileImageError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }
    //MARK: -Properties
    private(set) var DidChangeNotfication = Notification.Name(rawValue: "ProfileImageProviderDidChange")
//    static var shared = ProfileImageService()
//    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage()
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
            guard let self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                if self.avatarURL != nil {
                    completion(.success(userResult.profileImage.small))
                    NotificationCenter.default.post(
                                                    name: self.DidChangeNotfication,
                                                    object: self,
                                                    userInfo:  ["URL": userResult.profileImage.small])
                } else {
                    completion(.failure(ProfileImageError.invalidData))
                }
                self.task = nil
            case .failure(_):
                completion(.failure(ProfileImageError.decodingFailed))
                self.task = nil
            }
        }
        task = dataTask
        task?.resume()
    }
}

//MARK: -Structs
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
    }
}


