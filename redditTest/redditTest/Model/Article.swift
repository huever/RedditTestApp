//
//  Article.swift
//  redditTest
//
//  Created by luciano on 04/06/2018.
//  Copyright © 2018 huevo. All rights reserved.
//

import Foundation

struct RedditBase: Codable {
    let kind: String
    let data: ResposeData
}

struct ResposeData: Codable {
    let children: [Article]
    let after: String?
    let before: String?
}

struct Article: Codable {
    let kind: String
    let data: ArticleData
}

struct ArticleData: Codable {
    let preview: Preview?
    let id: String?
    let author: String?
    let url: String?
    let numComments: Int?
    let title: String
    let createdUTC: Int?
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let thumbnail: String?
    let name: String?
}

struct Preview: Codable {
    let images: [Image]
    let enabled: Bool
}

struct Image: Codable {
    let source: Source
    let resolutions: [Source]
    let id: String
}

struct Source: Codable {
    let url: String
    let width, height: Int
}
