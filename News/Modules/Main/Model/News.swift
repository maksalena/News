//
//  News.swift
//  News
//
//  Created by Алёна Максимова on 21.03.2025.
//

import UIKit

struct Wrapper: Decodable {
    let articles: [News]
}

struct News: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
}
