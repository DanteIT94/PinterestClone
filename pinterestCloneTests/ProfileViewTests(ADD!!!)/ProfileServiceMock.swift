//
//  ProfileServiceMock.swift
//  ProfileViewTests
//
//  Created by Денис on 01.06.2023.
//

@testable
import pinterestClone
import Foundation

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: pinterestClone.Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<pinterestClone.Profile, Error>) -> Void) {}
    
    
}
