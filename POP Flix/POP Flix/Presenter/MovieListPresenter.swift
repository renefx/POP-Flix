//
//  MovieListPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire

protocol MovieListPresenterDelegate: AnyObject {
    func movieFound(_ error: RequestErrors?)
    func latestMoviesFound(_ error: RequestErrors?,_ shouldReloadData: Bool)
}

enum SectionNames: Int {
    case latest
    case now
    case popular
    case top
    case upcoming
}

class MovieListPresenter {
    // MARK: - Variables
    weak var delegate: MovieListPresenterDelegate?
    private var service = ServiceConnection()
    private var latestMovies:[Movie]?
    private var latestMoviesImages:[(Data?, String?)] = []
    private var headerConnectionOpen = 0
    private var connectionsOpen = 0
    private var sectionNames = ["Latest","Now Playing","Popular","Top Rated","Upcoming"]
    
    public var isSearchingHeader: Bool {
        get { return headerConnectionOpen == 0 }
    }
//    var movieID: Int?
//    private var maxMoviesMoreLikeThis = 8
//    private var movie: Movie?
    
//    public var movieTitle: String? {
//        get { return movie?.title }
//    }
//
//    public var movieInfo: String? {
//        get {
//            guard let movie = movie else {
//                return nil
//            }
//            return movie.voteAverageFull + movie.runtimeFull + movie.yearReleased
//        }
//    }
//
//    public var movieTagline: String? {
//        get { return movie?.tagline }
//    }
//
//    public var movieDescription: String? {
//        get { return movie?.description }
//    }
//
//    public var movieGenres: String? {
//        get { return movie?.genresFull }
//    }
//
//    public var moviePoster: Data? {
//        get {
//            guard let posterPath = movie?.posterPath else { return nil }
//            return imageDataForPath(posterPath)
//        }
//    }
//
//    var numbersOfSimilarMovies: Int {
//        get {
//            guard let similarMovies = latestMovies else { return 0 }
//            return similarMovies.count <= maxMoviesMoreLikeThis ? similarMovies.count : maxMoviesMoreLikeThis
//        }
//    }
    
    func titleForSection(_ row: Int) -> String {
        guard row < sectionNames.count else {
            return sectionNames[0]
        }
        return sectionNames[row]
    }
    
    func numberOfCellForSection(_ section: Int) -> Int {
        guard section < sectionNames.count else {
            return 0
        }
        switch section {
        case 0:
            return latestMovies?.count ?? 0
        default:
            return 0
        }
    }
    
    func posterForCellAt(_ row: Int) -> Data? {
        guard let similarMovies = latestMovies,
            row < similarMovies.count,
            let posterPath = similarMovies[row].posterPath else {
                return nil
        }
        return imageDataForPath(posterPath)
    }
    
    func movieToHeader(atIndex row: Int) -> Movie? {
        guard let latestMovies = latestMovies,
            row < latestMovies.count else {
                return nil
        }
        return latestMovies[row]
    }
    
    func moviesToHeader() -> [(Data?, String?)] {
        guard let latestMovies = latestMovies else { return [] }
        return latestMovies.map({
            guard let backdropPath = $0.backdropPath else {
                return (nil, $0.title)
            }
            return (imageDataForPath(backdropPath, size: .poster_big), $0.title)
        })
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
    
    func getMovieSelectedFor(_ indexPathSelected: IndexPath) -> Movie? {
        switch indexPathSelected.section {
        case SectionNames.latest.rawValue:
            return latestMovies?[indexPathSelected.row]
        case SectionNames.now.rawValue:
            
            break
        case SectionNames.popular.rawValue:
            
            break
        case SectionNames.top.rawValue:
            
            break
        case SectionNames.upcoming.rawValue:
            
            break
        default:
            return nil
        }
        return nil
    }
    
    func getImageDataFor(_ indexPath: IndexPath) -> Data? {
        switch indexPath.section {
        case SectionNames.latest.rawValue:
            return moviesPoster(latestMoviesImages, indexPath.row)
        case SectionNames.now.rawValue:
            
            break
        case SectionNames.popular.rawValue:
            
            break
        case SectionNames.top.rawValue:
            
            break
        case SectionNames.upcoming.rawValue:
            
            break
        default:
            return nil
        }
        return nil
    }
    
    // MARK: - Latest Movies Collection
    func getLatestMoviesSmallPosters() -> [(Data?, String?)] {
        guard let latestMovies = latestMovies else { return [] }
        self.latestMoviesImages = latestMovies.map({
            guard let backdropPath = $0.posterPath else {
                return (nil, $0.title)
            }
            return (imageDataForPath(backdropPath), $0.title)
        })
        return self.latestMoviesImages
    }
    
    func moviesPoster(_ array: [(Data?, String?)], _ row: Int) -> Data? {
        guard row < array.count else {
            return nil
        }
        return array[row].0
    }
    
    // MARK: - Request
    
    func searchForLatestMovies() {
        self.headerConnectionOpen += 1
        self.connectionsOpen += 1
        guard Connectivity.isConnectedToInternet() else {
            headerConnectionOpen -= 1
            connectionsOpen -= 1
            self.latestMovies = nil
            delegate?.latestMoviesFound(.noInternet, connectionsOpen == 0)
            return
        }
        
        let url = ServiceConnection.urlLatestMovies()
        service.makeHTTPGetRequest(url, MovieList.self) { latestMovies in
            self.headerConnectionOpen -= 1
            self.connectionsOpen -= 1
            self.latestMovies = latestMovies?.list
            let response: RequestErrors? = latestMovies != nil ? nil : .unexpectedError
            self.delegate?.latestMoviesFound(response, self.headerConnectionOpen == 0)
        }
    }
}

