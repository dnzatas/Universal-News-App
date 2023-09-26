//
//  NewsData.swift
//  UN
//
//  Created by deniz on 13.09.2023.
//

import Foundation

struct NewsData: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}



