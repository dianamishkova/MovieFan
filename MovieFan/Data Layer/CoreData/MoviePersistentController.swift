//
//  MoviePersistentController.swift
//  MovieFan
//
//  Created by Диана Мишкова on 15.01.24.
//

import Foundation
import CoreData

class MoviePersistentController: ObservableObject {
    var persistentContainer = NSPersistentContainer(name: "MovieFan")
    private var moviesFetchRequest = MovieCD.fetchRequest()
    private var ratingsFetchRequest = MovieRatingCD.fetchRequest()

    init() {
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("error: \(error)")
            }
        }
    }
    
    func updateAndAddServerDataToCoreData(moviesFromBackend: [Movie]?) {
        var moviesIdDict: [Int: Movie] = [:]
        var moviesIdList: [Int] = []
        
        guard let movies = moviesFromBackend,
              !movies.isEmpty else {
            return
        }
        for movie in movies {
            moviesIdDict[movie.id] = movie
        }
        moviesIdList = movies.map { $0.id }
        
        
        moviesFetchRequest.predicate = NSPredicate(format: "id IN %@", moviesIdList)
        
        let managedObjectContext = persistentContainer.viewContext
        
        let moviesCD = try? managedObjectContext.fetch(moviesFetchRequest)
        
        guard let moviesCD = moviesCD else {
            return
        }
        
        
        for movieCD in moviesCD {
            managedObjectContext.delete(movieCD)
        }
        
        for movie in movies {
            let genreCD = GenreCD(context: managedObjectContext)
            genreCD.id = 1
            genreCD.title = "Drama"
            let movieCD = MovieCD(context: managedObjectContext)
            movieCD.id = Int64(movie.id)
            movieCD.title = movie.title
            movieCD.overview = movie.overview
            movieCD.imageURLSuffix = movie.imageURLSuffix
            movieCD.releaseDate = movie.releaseDate
            movieCD.genre = genreCD
        }
        try? managedObjectContext.save()
    }
    
    func fetchMoviesFromCoreData() -> [Movie]{
        let movieTitleSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        let movieReleaseDateSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
        moviesFetchRequest.sortDescriptors = [movieReleaseDateSortDescriptor]
        
        let moviesCD = try? persistentContainer.viewContext.fetch(moviesFetchRequest)
      
        guard let moviesCD = moviesCD else {
            return []
        }
        var convertedMovies: [Movie] = []
        for movieCD in moviesCD {
            let movie = Movie(id: Int(movieCD.id),
                              title: movieCD.title ?? "",
                              overview: movieCD.overview ?? "",
                              imageURLSuffix: movieCD.imageURLSuffix ?? "",
                              releaseDate: movieCD.releaseDate ?? "")
            convertedMovies.append(movie)
        }
        return convertedMovies
    }
    
    func updateAndAddServerRatingsDataToCoreData(ratingsFromBackend: [MovieRating]?) {
        var ratingsIdDict: [Int: MovieRating] = [:]
        var ratingsIdList: [Int] = []
        
        guard let ratings = ratingsFromBackend,
              !ratings.isEmpty else {
            return
        }
        
        for rating in ratings {
            ratingsIdDict[rating.id] = rating
        }
        
        ratingsIdList = ratings.map { $0.id }
        
        ratingsFetchRequest.predicate = NSPredicate(format: "id IN %@", ratingsIdList)
        let managedObjectContext = persistentContainer.viewContext
        let ratingsCD = try? managedObjectContext.fetch(ratingsFetchRequest)
        
        guard let ratingsCD = ratingsCD else {
            return
        }
        
        for ratingCD in ratingsCD {
            managedObjectContext.delete(ratingCD)
        }
        
        for rating in ratings {
            let ratingCD = MovieRatingCD(context: managedObjectContext)
            ratingCD.id = Int64(rating.id)
            ratingCD.popularity = rating.popularity
            ratingCD.title = rating.title
            ratingCD.voteAverage = rating.voteAverage
            ratingCD.voteCount = Int64(rating.voteCount)
        }
        try? managedObjectContext.save()
    }
    
    func fetchRatingsFromCoreData() -> [MovieRating] {
        let ratingsCD = try? persistentContainer.viewContext.fetch(ratingsFetchRequest)
        
        guard let ratingsCD = ratingsCD else {
            return []
        }
        
        var convertedRatings: [MovieRating] = []
        
        for ratingCD in ratingsCD {
            let rating = MovieRating(id: Int(ratingCD.id),
                                     title: ratingCD.title ?? "",
                                     popularity: ratingCD.popularity,
                                     voteCount: Int(ratingCD.voteCount),
                                     voteAverage: ratingCD.voteAverage)
            convertedRatings.append(rating)
        }
        return convertedRatings
    }
}
