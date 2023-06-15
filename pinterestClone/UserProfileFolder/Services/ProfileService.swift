//
//  ProfileService.swift
//  pinterestClone
//
//  Created by Денис on 05.05.2023.
//

import UIKit
import Foundation

protocol ProfileServiceProtocol: AnyObject {
    var profile: Profile? {get}
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    enum ProfileError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }
    //MARK: - Properties
    private(set) var profile: Profile?
    private var fetchProfileTask: URLSessionTask?
    private let urlSession = URLSession.shared
    
    //MARK: - Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        ///Закрываем предыдущую таску если fetchProfileTask не nil
        fetchProfileTask?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileTask = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName ?? "")",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure:
                completion(.failure(ProfileError.decodingFailed))
            }
        }
        if let profile {
            self.fetchProfileTask = nil
            completion(.success(profile))
        } else {
            fetchProfileTask?.resume()
        }
    }
}
