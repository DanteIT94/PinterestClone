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
    
    private var fetchProfileTask: URLSessionDataTask?
    private let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        ///Закрываем предыдущую таску если fetchProfileTask не nil
        fetchProfileTask?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(ProfileError.unauthorized))
                return
            }
            
            guard let data = data else {
                completion(.failure(ProfileError.invalidData))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                self.profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName)",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio)
                completion(.success(self.profile!))
            } catch {
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
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

///Определяем свойства структуры, которые соответствуют полям ответа сервера.
struct Profile {
    var  username: String
    var name: String
    var loginName: String
    var bio: String?
}
