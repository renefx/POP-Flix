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
    private var similarMovies: [Movie] = []
    
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
    
    public var numbersOfSimilarMovies: Int {
        get {
            return similarMovies.count <= maxMoviesMoreLikeThis ? similarMovies.count : maxMoviesMoreLikeThis
        }
    }
    
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
    
    public func posterForCellAt(_ row: Int) -> Data? {
        guard row < similarMovies.count,
            let posterPath = similarMovies[row].posterPath else {
                return nil
        }
        return imageDataForPath(posterPath)
    }
    
    public func movie(atIndex row: Int) -> Movie? {
        guard row < similarMovies.count else {
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
        guard let id = movie?.id.value else { return }
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
