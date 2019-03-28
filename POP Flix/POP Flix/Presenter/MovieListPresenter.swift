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
    func latestMoviesFound(_ error: RequestErrors?)
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
    private var latestMovies: [Movie] = [] {
        didSet {
            latestMoviesBigPosters = latestMovies.map({
                guard let backdropPath = $0.backdropPath else {
                    return (nil, $0.title)
                }
                return (imageDataForPath(backdropPath, size: .poster_big), $0.title)
            })
            
            latestMoviesSmallPosters = latestMovies.map({
                guard let backdropPath = $0.posterPath else {
                    return (nil, $0.title)
                }
                return (imageDataForPath(backdropPath), $0.title)
            })
        }
    }
    var latestMoviesBigPosters:[(Data?, String?)] = []
    private var latestMoviesSmallPosters:[(Data?, String?)] = []
    private var sectionNames: [String] = ["Now Playing","Latest","Popular","Top Rated","Upcoming"]
    
    func titleForSection(_ row: Int) -> String {
        guard row < sectionNames.count else {
            return General.none
        }
        return sectionNames[row]
    }
    
    func numberOfCellForSection(_ section: Int) -> Int {
        guard section < sectionNames.count else { return 0 }
        switch section {
        case 0:
            return latestMovies.count
        default:
            return 0
        }
    }
    
    func posterForCellAt(_ row: Int) -> Data? {
        guard row < latestMovies.count,
            let posterPath = latestMovies[row].posterPath else {
                return nil
        }
        return imageDataForPath(posterPath)
    }
    
    func movieToHeader(atIndex row: Int) -> Movie? {
        guard row < latestMovies.count else {
                return nil
        }
        return latestMovies[row]
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
            if indexPathSelected.row >= latestMovies.count { return nil }
            return latestMovies[indexPathSelected.row]
        default:
            return nil
        }
    }
    
    func getImageDataFor(_ indexPath: IndexPath) -> Data? {
        switch indexPath.section {
        case SectionNames.latest.rawValue:
            return moviesPoster(latestMoviesSmallPosters, indexPath.row)
        default:
            return nil
        }
    }
    
    // MARK: - Latest Movies Collection
    func moviesPoster(_ array: [(Data?, String?)], _ row: Int) -> Data? {
        guard row < array.count else {
            return nil
        }
        return array[row].0
    }
    
    // MARK: - Request
    
    func shouldGetCache() -> Bool {
        let twoHoursAgo = Date().removeHour(numberOfHours: 2)
        guard let lastUpdate = UserDefaults.standard.string(forKey: UserDefaultKeys.lastUpdateLatestRelease),
            let lastDateUpdated = lastUpdate.toDateUserDefault,
            lastDateUpdated > twoHoursAgo else {
                return false
        }
        return true
    }
    
    func searchForLatestMovies(_ userStarted: Bool) {
        print(Date().toString("HH:mm:ss"))
        if !userStarted, shouldGetCache(),!self.latestMovies.isEmpty {
            delegate?.latestMoviesFound(nil)
            return
        }
    
        guard Connectivity.isConnectedToInternet() else {
            self.latestMovies = []
            delegate?.latestMoviesFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlLatestMovies()
        service.makeHTTPGetRequest(url, MovieList.self) { (latestMovies, error) in
            self.latestMovies = latestMovies?.list ?? []
            if error == nil {
                let now = Date().toString()
                UserDefaults.standard.set(now, forKey: UserDefaultKeys.lastUpdateLatestRelease)
            }
            self.latestMovies = latestMovies?.list ?? []
            print(Date().toString("HH:mm:ss"))
            self.delegate?.latestMoviesFound(error)
        }
    }
}

