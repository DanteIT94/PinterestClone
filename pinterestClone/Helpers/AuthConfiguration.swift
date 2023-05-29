//
//  Constants.swift
//  pinterestClone
//
//  Created by Денис on 15.04.2023.
//

import Foundation

let AccessKey = "LVXwpOYrkGhabPrOmsrVyvf66U76nIfOFANebMMo2q0"
let SecretKey = "2Oo83r2dKo3aNiJl4QFH00t-Xu45rCER6Z1aaHk89V4"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let tokenURL = "https://unsplash.com/oauth/token"
let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!
let UnsplashAuthorizedURLString = "https://unsplash.com/oauth/authorize"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = secretKey
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizedURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
