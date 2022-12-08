//
//  URLSession.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 08/12/2022.
//

import Foundation

extension URLSession{
    func getTopStories(completion: @escaping (Model.News) -> ()){
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e044288166284415a2cb2c843dd372a4") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let news = try? JSONDecoder().decode(Model.News.self, from: data)
            {
                completion(news)
            }
            else{
                print("Could not get any content")
            }
            
        }
        
        task.resume()
    }
}

enum Model{
    struct News: Decodable{
        let status: String
        let totalResults: Int
        let articles: [Article]
    }
    
    struct Article: Decodable{
        let source: Source
        let author: String?
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
        let content: String?
    }
    
    struct Source: Decodable {
        let id: String?
        let name: String
    }
}


