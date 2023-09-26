//
//  DetailViewModel.swift
//  UN
//
//  Created by deniz on 20.09.2023.
//


import UIKit

class DetailViewModel {
    private var article: Article
    
    var formattedDate: String {
        return article.formattedDate
    }
    
    var title: String {
        return article.title
    }
    
    var author: String? {
        return article.author
    }
    
    var description: String? {
        return article.description
    }
    
    var formattedContent: String? {
        return article.formattedContent
    }
    
    var imageURL: URL? {
        return URL(string: article.urlToImage ?? "")
    }
    
    var isBookmarked: Bool {
        return UserDefaults.standard.object(forKey: article.id) != nil
    }
    
    init(article: Article) {
        self.article = article
    }
    
    func toggleBookmark() {
        if isBookmarked {
            UserDefaults.standard.removeObject(forKey: article.id)
        } else {
            Utilities.saveArticleToUserDefaults(article: article)
        }
    }
}
