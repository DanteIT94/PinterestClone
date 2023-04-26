//
//  OAuth2TokenStorage.swift
//  pinterestClone
//
//  Created by Денис on 22.04.2023.
//

import UIKit

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String?
    {
        get {
            return userDefaults.string(forKey: "token")
        }
        set {
            return userDefaults.set(newValue, forKey: "token")
        }
    }
}
