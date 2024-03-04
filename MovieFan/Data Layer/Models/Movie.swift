//
//  Movie.swift
//  MovieFan
//
//  Created by Диана Мишкова on 11.01.24.
//

import Foundation

struct MovieRootResult: Codable {
    let page: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

struct Movie: Codable, Identifiable {
    private struct Constants {
        static let baseImageURL = "https://image.tmdb.org/t/p/"
        static let logoSize = "w45"
        static let largeLogoSize = "w500"
    }
    
    var id: Int
    var title: String
    var overview: String
    var imageURLSuffix: String
    var releaseDate: String
    
    func getLogoURL() -> String {
        return "\(Constants.baseImageURL)\(Constants.logoSize)\(imageURLSuffix)"
    }
    
    func getLargeImageURL() -> String {
        return "\(Constants.baseImageURL)\(Constants.largeLogoSize)\(imageURLSuffix)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case imageURLSuffix = "poster_path"
        case releaseDate = "release_date"
    }
}
