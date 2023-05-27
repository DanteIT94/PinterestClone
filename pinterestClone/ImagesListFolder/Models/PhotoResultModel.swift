//
//  PhotoResult(JSON).swift
//  pinterestClone
//
//  Created by Денис on 17.05.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case width
//        case height
//        case description
//        case urls
//        case isLiked = "liked_by_user"
//    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
