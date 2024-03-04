//
//  MovieViewModel.swift
//  MovieFan
//
//  Created by Диана Мишкова on 11.01.24.
//

import Foundation
import Combine
import Network
import CoreData

class MovieViewModel: ObservableObject {
    private var networkConnectivity = NWPathMonitor()
    private var persistentController = MoviePersistentController()
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: DataError? = nil
    @Published private(set) var movieRatings: [MovieRating] = []
    
    let apiService: MovieAPILogic
    
    init(apiService: MovieAPILogic = MovieAPI(),
         persistentController: MoviePersistentController = MoviePersistentController()) {
        self.apiService = apiService
        self.persistentController = persistentController
        networkConnectivity.start(queue: DispatchQueue.global(qos: .userInitiated))
    }
    
    
    func getMovies() {
        switch networkConnectivity.currentPath.status {
        case .satisfied:
            apiService.getMovies() { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies ?? []
                    
                    self?.persistentController.updateAndAddServerDataToCoreData(moviesFromBackend: movies)

                    
                case .failure(let error):
                    self?.error = error
                }
            }
        default:
            movies = persistentController.fetchMoviesFromCoreData()
        }
        
    }
    
    func getMovieRating() {
        switch networkConnectivity.currentPath.status {
        case .satisfied:
            apiService.getMovieRating { [weak self] result in
                switch result {
                case .success(let movieRatings):
                    self?.movieRatings = movieRatings ?? []
                    
                    self?.persistentController.updateAndAddServerRatingsDataToCoreData(ratingsFromBackend: movieRatings)
                    
                case .failure(let error):
                    self?.error = error
                }
            }
        default:
            movieRatings = persistentController.fetchRatingsFromCoreData()
        }
        
    }
    
    func getMovieRatingVoteAverage() -> Double {
        let voteAverages = movieRatings.prefix(10).map { $0.voteAverage }
        let sum = voteAverages.reduce(0, +)
        return sum / 10.0
    }
}
