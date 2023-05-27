//
//  OAuth2TokenStorage.swift
//  pinterestClone
//
//  Created by Денис on 22.04.2023.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: "token")
        }
        set {
            if let newToken = newValue {
                keychainWrapper.set(newToken, forKey: "token")
            } else {
                keychainWrapper.removeObject(forKey: "token")
            }
        }
    }
    
    func deleteToken() {
        keychainWrapper.remove(forKey: "token")
    }
}

