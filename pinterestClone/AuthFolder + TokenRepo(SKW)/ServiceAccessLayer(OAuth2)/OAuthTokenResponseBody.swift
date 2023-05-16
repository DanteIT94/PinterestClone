//
//  OAuthTokenResponseBody.swift
//  pinterestClone
//
//  Created by Денис on 14.05.2023.
//

import Foundation

///Определяем структуру OAuthTokenResponseBody, которая будет использоваться для декодирования ответа сервера.
struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    ///Определяем свойства структуры, которые соответствуют полям ответа сервера.
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
