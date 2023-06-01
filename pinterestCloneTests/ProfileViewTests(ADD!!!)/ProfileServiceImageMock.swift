//
//  ProfileServiceImageMock.swift
//  ProfileViewTests
//
//  Created by Денис on 01.06.2023.
//
@testable
import pinterestClone
import UIKit

struct ImageURLMock {
    static let successURL = URL(string: "https://success.com")
    static let failureURL = URL(string: "https://failure.com")
}

struct ImagesMock {
    static let successImage = UIImage(systemName: "book")!
    static let failedImage = UIImage(systemName: "book.fill")!
}

final class ProfileServiceImageMock: ProfileImageServiceProtocol {
    var DidChangeNotfication: Notification.Name = Notification.Name("ProfileImageProviderDidChange")
    
    var avatarURL: String?
    
    var isFetchProfileImageURLCalled = false
    var fetchProfileImageURLUsername: String?
    var fetchProfileImageURLCompletion: ((Result<String, Error>) -> Void)?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        isFetchProfileImageURLCalled = true
        fetchProfileImageURLUsername = username
        fetchProfileImageURLCompletion = completion
    }
    
}
