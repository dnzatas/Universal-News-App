//
//  OnboardingSlide.swift
//  UN
//
//  Created by deniz on 10.09.2023.
//

import UIKit


struct OnboardingSlide {
    var title: String
    var description: String
    var image: UIImage
    
    
    static var slides: [OnboardingSlide] = [
                OnboardingSlide(title: "Welcome to UN", description: "Stay informed with the latest news from around the world", image: #imageLiteral(resourceName: "onboarding1")),
                OnboardingSlide(title: "Your Source for Breaking News", description: "Get instant access to breaking news, top stories, and more", image: #imageLiteral(resourceName: "onboarding2")),
                OnboardingSlide(title: "Explore Diverse News Categories", description: "Discover news in categories like business, technology, sports, and more", image: #imageLiteral(resourceName: "onboarding3"))
            ]
}
