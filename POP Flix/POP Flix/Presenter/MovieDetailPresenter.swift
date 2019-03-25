//
//  MovieDetailPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire

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
    private var similarMovies:[Movie]?
    
    init(_ movie: Movie? = nil) {
        self.movie = movie
    }
    
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
        get { return movie?.description }
    }
    
    public var movieGenres: String? {
        get { return movie?.genresFull }
    }
    
    public var moviePoster: Data? {
        get {
            guard let posterPath = movie?.posterPath else { return nil }
            return imageDataForPath(posterPath)
        }
    }
    
    var numbersOfSimilarMovies: Int {
        get {
            guard let similarMovies = similarMovies else { return 0 }
            return similarMovies.count <= maxMoviesMoreLikeThis ? similarMovies.count : maxMoviesMoreLikeThis
        }
    }
    
    func posterForCellAt(_ row: Int) -> Data? {
        guard let similarMovies = similarMovies,
            row < similarMovies.count,
            let posterPath = similarMovies[row].posterPath else {
                return nil
        }
        return imageDataForPath(posterPath)
    }
    
    func movie(atIndex row: Int) -> Movie? {
        guard let similarMovies = similarMovies,
            row < similarMovies.count else {
                return nil
        }
        return similarMovies[row]
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
        guard let id = movie?.id else { return }
        guard Connectivity.isConnectedToInternet() else {
            self.movie = nil
            delegate?.movieFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlMovie(id)
        service.makeHTTPGetRequest(url, Movie.self) { movie in
            self.movie = movie
            let response: RequestErrors? = movie != nil ? nil : .unexpectedError
            self.delegate?.movieFound(response)
        }
    }
    
    func searchForRelatedMovies() {
        guard let id = movie?.id else { return }
        guard Connectivity.isConnectedToInternet() else {
            self.movie = nil
            delegate?.similarMoviesFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlSimilarMovies(id)
        service.makeHTTPGetRequest(url, MovieList.self) { similarMovies in
            self.similarMovies = similarMovies?.list
            let response: RequestErrors? = similarMovies != nil ? nil : .unexpectedError
            self.delegate?.similarMoviesFound(response)
        }
    }
}
