//
//  Category.swift
//  UN
//
//  Created by deniz on 19.09.2023.
//

import Foundation

enum Categories: CaseIterable {
    case General
    case Business
    case Entertainment
    case Health
    case Science
    case Sports
    case Technology

    var displayName: String {
        switch self {
        case .General: return "General"
        case .Business: return "Business"
        case .Entertainment: return "Entertainment"
        case .Health: return "Health"
        case .Science: return "Science"
        case .Sports: return "Sports"
        case .Technology: return "Technology"
        }
    }

    var category: String {
        switch self {
        case .General: return "general"
        case .Business: return "business"
        case .Entertainment: return "entertainment"
        case .Health: return "health"
        case .Science: return "science"
        case .Sports: return "sports"
        case .Technology: return "technology"
        }
    }
}




