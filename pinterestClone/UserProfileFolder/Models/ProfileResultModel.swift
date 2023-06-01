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
    
}

