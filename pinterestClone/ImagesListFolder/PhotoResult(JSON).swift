//
//  PhotoResult(JSON).swift
//  pinterestClone
//
//  Created by Денис on 17.05.2023.
//

import Foundation

struct UrlsResult: Codable {
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date?
    let updatedAt: Date?
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let urls: UrlsResult
}


