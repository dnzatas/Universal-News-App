//
//  AllNewsViewModel.swift
//  UN
//
//  Created by deniz on 21.09.2023.
//

import UIKit

class AllNewsViewModel {
    var articleList: [Article] = []
    var filteredArticles: [Article] = []
    var categories: [Categories] = Categories.allCases

    var filteredArticlesDidChange: (([Article]) -> Void)?

    init() {
        fetchTopHeadlines(url: Constants.Urls.topHeadlinesurl!)
    }

    func fetchTopHeadlines(url: URL) {
        NewsService.shared.getTopHeadlines(url: url) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articleList.removeAll()
                self?.articleList = articles.filter { article in
                    return article.title != "" && article.description != nil && article.urlToImage != nil
                }
                self?.filteredArticles = self?.articleList ?? []
                self?.filteredArticlesDidChange?(self?.filteredArticles ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
}



