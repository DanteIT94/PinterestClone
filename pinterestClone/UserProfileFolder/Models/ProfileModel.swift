//
//  ProfileModel.swift
//  pinterestClone
//
//  Created by Денис on 25.05.2023.
//

import Foundation

///Структура для "переформатирования" полученных данных под модель профиля
struct Profile: Codable {
    var  username: String
    var name: String
    var loginName: String
    var bio: String?
    
    static func ==(lhs: Profile, rhs: Profile) -> Bool {
            return lhs.username == rhs.username &&
        lhs.name == rhs.name &&
        lhs.loginName == rhs.loginName &&
        lhs.bio == rhs.bio
        }
}
