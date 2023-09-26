//
//  Constants.swift
//  UN
//
//  Created by deniz on 12.09.2023.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        static let login = "Login"
        static let detail = "Detail"
        static let news = "News"
        static let onboardingViewController = "OnboardingViewController"
    }
    
    struct ViewControllers {
        static let onboardingViewController = "OnboardingViewController"
        static let detailViewController = "DetailViewController"
        static let loginViewController = "LoginViewController"
        static let signUpViewController = "SignUpViewController"
    }
    
    struct TabBarControllers {
        static let newsTabBar = "newsTabBar"
    }
    
    struct CollectionViewCells {
        static let allNewsCollectionViewCell = "AllNewsCollectionViewCell"
        static let savedNewsCollectionViewCell = "SavedNewsCollectionViewCell"
    }
    
    struct TableViewCells {
        static let sideMenuTableViewCell = "SideMenuTableViewCell"
    }
    
    struct Urls {
        static let apiKey = "5975ea4953124b7fb59e29d6bf602ba9"
        static let topHeadlinesurl = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")
        
        static func categoryUrl(for category: String) -> URL? {
            let categoryQueryParam = category
            let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=\(categoryQueryParam)&apiKey=\(apiKey)"
            return URL(string: urlString)
        }
    }
}
