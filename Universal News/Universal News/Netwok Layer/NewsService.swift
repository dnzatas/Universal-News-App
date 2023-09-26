//
//  NewsService.swift
//  UN
//
//  Created by deniz on 13.09.2023.
//

import Foundation

class NewsService {
    
    static let shared = NewsService()
    
    func getTopHeadlines(url: URL, completion: @escaping (Result<[Article], Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let result: NewsData = try decoder.decode(NewsData.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


