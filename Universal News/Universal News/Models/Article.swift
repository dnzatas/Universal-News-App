//
//  Article.swift
//  UN
//
//  Created by deniz on 13.09.2023.
//

import Foundation


// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, MMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: publishedAt)
    }
    
    var formattedContent: String? {
        var modifiedContent = content ?? ""
        modifiedContent = modifiedContent.replacingOccurrences(of: "\\[\\+\\d+ chars\\]$", with: "", options: .regularExpression)
        return modifiedContent.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

extension Article: Identifiable {
    var id: String {url}
}

extension Article {
    func encodeToData() -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            return encoded
        }
        return nil
    }
}


// MARK: - Source
struct Source: Codable {
    let name: String
}
