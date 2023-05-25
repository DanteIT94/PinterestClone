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
}
