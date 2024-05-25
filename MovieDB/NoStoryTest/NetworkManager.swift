//
//  NetworkManager.swift
//  NoStoryTest
//
//  Created by Sultan on 22.05.2024.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    
    let urlImage = "https://image.tmdb.org/t/p/w500"
    let apiKey = "f6d8e98766ad5d4d418edb2be8174863"
    
    lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "f6d8e98766ad5d4d418edb2be8174863")
        ]
        return component
    }()
    
    let session = URLSession(configuration: .default)
    
    func loadMovie(theme: String, complation: @escaping([Result]) -> Void) {
        var component = urlComponent
        component.path = "/3/movie/upcoming"
        guard let requestUrl = component.url else {return}
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else {return}
            if let movie = try? JSONDecoder().decode(Movie.self, from: data) {
                DispatchQueue.main.async {
                    complation(movie.results)
                }
            }
        }
        task.resume()
    }
}
