//
//  SavedNewsViewModel.swift
//  UN
//
//  Created by deniz on 21.09.2023.
//

import Foundation

class SavedNewsViewModel {
    var savedArticles: [Article] = []
    var noNewsLabelHidden: ((Bool) -> Void)?
    
    func fetchSavedArticles() {
        let userDefaults = UserDefaults.standard
        let savedArticleKeys = userDefaults.dictionaryRepresentation().keys
        
        savedArticles.removeAll()
        for key in savedArticleKeys {
            if let articleData = userDefaults.data(forKey: key),
               let article = try? JSONDecoder().decode(Article.self, from: articleData) {
                savedArticles.append(article)
            }
        }
        
        noNewsLabelHidden?(savedArticles.isEmpty)
    }
    
    func deleteAllSavedArticles() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        fetchSavedArticles()
    }
}
