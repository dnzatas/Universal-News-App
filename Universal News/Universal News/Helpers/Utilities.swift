//
//  Utilities.swift
//  UN
//
//  Created by deniz on 12.09.2023.
//

import Foundation
import UIKit


class Utilities {
    
    static func setBookmarkFilled(_ button: UIButton, _ filled: Bool) {
        let imageName = filled ? "bookmark.fill" : "bookmark"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    static func saveArticleToUserDefaults(article: Article) {
        if let articleData = article.encodeToData() {
            UserDefaults.standard.set(articleData, forKey: article.id)
        }
    }
}
