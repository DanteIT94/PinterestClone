//
//  OAuth2TokenStorage.swift
//  pinterestClone
//
//  Created by Денис on 22.04.2023.
//

import UIKit

final class OAuth2TokenStorage {
    
   private let tokenKey = "OAuth2TokenStorage.token"
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            return userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
