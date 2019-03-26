//
//  MovieDetailPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import UIImageColors

protocol MovieDetailPresenterelegate: AnyObject {
    func movieFound(_ error: RequestErrors?)
    func similarMoviesFound(_ error: RequestErrors?)
}

class MovieDetailPresenter {
    // MARK: - Variables
    weak var delegate: MovieDetailPresenterelegate?
    private var maxMoviesMoreLikeThis = 8
    private var service = ServiceConnection()
    private var movie: Movie?
    private var moviePoster: Data?
    private var similarMovies: [Movie] = []
    private var realm: Realm?
    
    init(_ movie: Movie? = nil) {
        self.movie = movie
        realm = try! Realm()
    }
    
    // MARK: - Computed Variables
    public var movieTitle: String? {
        get { return movie?.title }
    }
    
    public var movieInfo: String? {
        get {
            guard let movie = movie else {
                return nil
            }
            return movie.voteAverageFull + movie.runtimeFull + movie.yearReleased
        }
    }
    
    public var movieTagline: String? {
        get { return movie?.tagline }
    }
    
    public var movieDescription: String? {
        get { return movie?.movieDescription }
    }
    
    public var movieGenres: String? {
        get { return movie?.genresFull }
    }
    
    public var numbersOfSimilarMovies: Int {
        get {
            return similarMovies.count <= maxMoviesMoreLikeThis ? similarMovies.count : maxMoviesMoreLikeThis
        }
    }
    
    // MARK: - Navigation
    public func movie(atIndex row: Int) -> Movie? {
        guard row < similarMovies.count else {
            return nil
        }
        return similarMovies[row]
    }
    
    // MARK: - Share Movie
    public var shareMessage: String? {
        get {
            guard let title = movie?.title else { return nil}
            return ShareMessages.movie + title
        }
    }
    
    var shareLink: URL? {
        get {
            guard let link = movie?.imdbId,
                let url = URL(string: "\(ShareMessages.movieUrl)\(link)") else { return nil }
            return url
        }
    }
    
    // MARK: - Save Favorite Movie
    public func deleteFavoriteMovie(onCompletion: (Bool) ->(Void)) {
        do {
            guard let favoriteMovie: FavoriteMovies = isMovieFavorite(),
                let realm = realm else {
                onCompletion(false)
                return
            }
            try realm.write {
                realm.delete(favoriteMovie)
            }
            onCompletion(true)
        } catch {
            onCompletion(false)
            return
        }
    }
    
    public func saveAsFavoriteMovie(onCompletion: (Bool) ->(Void)) {
        guard let movie = movie,
            let moviePoster = moviePoster,
            !isMovieFavorite() else {
                
                onCompletion(false)
                return
        }
        
        do {
            if let image = UIImage(data: moviePoster),
                let colors = image.getColors() {
                
                let favoriteMovie = FavoriteMovies(movie: movie, posterImage: moviePoster, colorPrimary: colors.primary.toHexString, colorSecondary: colors.secondary.toHexString, colorDetail: colors.detail.toHexString, colorBackground: colors.background.toHexString)
                try realm?.write {
                    realm?.add(favoriteMovie, update: true)
                }
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        } catch {
            onCompletion(false)
            return
        }
    }
    
    func isMovieFavorite() -> Bool {
        let movie: FavoriteMovies? = isMovieFavorite()
        return movie != nil
    }
    
    private func isMovieFavorite() -> FavoriteMovies? {
        let favorites = realm?.objects(FavoriteMovies.self)
        return favorites?.filter{ $0.id.value == self.movie?.id.value }.first
    }
    
    // MARK: - Image for poster
    public func getMoviePoster() -> Data? {
        guard let posterPath = movie?.posterPath else { return nil }
        if self.moviePoster != nil { return self.moviePoster }
        self.moviePoster = imageDataForPath(posterPath)
        return self.moviePoster
    }
    
    public func posterForCellAt(_ row: Int) -> Data? {
        guard row < similarMovies.count,
            let posterPath = similarMovies[row].posterPath else {
                return nil
        }
        return imageDataForPath(posterPath)
    }
    
    private func imageDataForPath(_ posterPath: String, size: ImageSize = ImageSize.poster) -> Data? {
        let urlString = TheMovieDBAPI.urlImages + size.rawValue + posterPath
        if let url = URL(string: urlString) {
            do {
                return try Data(contentsOf: url)
            } catch {}
        }
        return nil
    }
    
    // MARK: - Request
    func searchForMovie() {
        guard let id = movie?.id.value else { return }
        let favoriteMovie:FavoriteMovies? = isMovieFavorite()
        if let favoriteMovie = favoriteMovie {
            self.movie = favoriteMovie.movie
            self.delegate?.movieFound(nil)
            return
        }
        
        guard Connectivity.isConnectedToInternet() else {
            self.movie = nil
            delegate?.movieFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlMovie(id)
        service.makeHTTPGetRequest(url, Movie.self) { (movie, error) in
            self.movie = movie
            self.delegate?.movieFound(error)
        }
    }
    
    func searchForRelatedMovies() {
        guard let id = movie?.id.value else { return }
        guard Connectivity.isConnectedToInternet() else {
            self.movie = nil
            delegate?.similarMoviesFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlSimilarMovies(id)
        service.makeHTTPGetRequest(url, MovieList.self) { (similarMovies, error) in
            self.similarMovies = similarMovies?.list ?? []
            self.delegate?.similarMoviesFound(error)
        }
    }
}
