//
//  ProfileService.swift
//  pinterestClone
//
//  Created by Денис on 05.05.2023.
//

import UIKit
import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    enum ProfileError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }
    
    private var fetchProfileTask: URLSessionTask?
    private let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        ///Закрываем предыдущую таску если fetchProfileTask не nil
        fetchProfileTask?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileTask = urlSession.objectTask(for: request) {[weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName)",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio
                )
                self?.profile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(ProfileError.decodingFailed))
            }
        }
        fetchProfileTask?.resume()
    }
}

///Определяем структуру ProfileResult, которая будет использоваться для декодирования ответа сервера.
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    ///Определяем свойства структуры, которые соответствуют полям ответа сервера.
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

///Структура для "переформатирования" полученных данных под модель профиля
struct Profile: Codable {
    var  username: String
    var name: String
    var loginName: String
    var bio: String?
}
