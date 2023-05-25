//
//  ProfileResultModel.swift
//  pinterestClone
//
//  Created by Денис on 25.05.2023.
//

import Foundation

///Определяем структуру ProfileResult, которая будет использоваться для декодирования ответа сервера.
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    ///Определяем свойства структуры, которые соответствуют полям ответа сервера.
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

