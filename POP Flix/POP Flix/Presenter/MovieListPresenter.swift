//
//  MovieListPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

protocol MovieListPresenterDelegate: AnyObject {
    func movieFound(_ error: RequestErrors?)
    func reloadTableView(row: Int)
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
    private var latestMovies: [Movie] = []
    private var moviesDownloaded:[[Movie]?] = []
    private var latestMoviesImages:[(Data?, String?)] = []
    private var sectionNames: [String] = []
    private var connectionErrors: [Bool] = [false,false,false,false,false]
    private var isOnConnection: [Bool] = [false,false,false,false,false]
    private var realm: Realm?
    
    init() {
        realm = try! Realm()
        sectionNames = ["Latest","Now Playing","Popular","Top Rated","Upcoming"]
    }
    
    func titleForSection(_ row: Int) -> String {
        guard row < sectionNames.count else {
            return General.none
        }
        return sectionNames[row]
    }
    
    func numberOfCellForSection(_ section: Int) -> Int {
        if connectionErrors[section] { return 1 }
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
    
    func moviesToHeader() -> [(Data?, String?)] {
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
            if indexPathSelected.row >= latestMovies.count { return nil }
            return latestMovies[indexPathSelected.row]
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
        if connectionErrors[indexPath.section] {
            return UIImage(named: General.errorCellImage)?.pngData()
        }
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
    
    func isOnConnection(row: Int) -> Bool {
        guard row < isOnConnection.count else {
            return false
        }
        return isOnConnection[row]
    }
    
    // MARK: - Latest Movies Collection
    func getLatestMoviesSmallPosters() -> [(Data?, String?)] {
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
        isOnConnection[0] = true
        delegate?.reloadTableView(row: 0)
        if let lastUpadte = UserDefaults.standard.string(forKey: UserDefaultKeys.lastUpdateLatestRelease){
            let lessTwoHours = Date().removeHour(numberOfHours: 2)
            let lessOneDay = Date().removeHour(numberOfHours: 24)
            
            if let lastDateUpdated = lastUpadte.toDateUserDefault,
                lastDateUpdated <= lessTwoHours {
                isOnConnection[0] = true
                delegate?.latestMoviesFound(nil)
                return
            } else if let lastDateUpdated = lastUpadte.toDateUserDefault,
                lastDateUpdated <= lessOneDay,
                let latestMoviesCache = realm?.objects(LatestMovies.self).first?.movies {
                    self.latestMovies = []
                    self.latestMovies.append(contentsOf: latestMoviesCache)
                    isOnConnection[0] = false
                    delegate?.latestMoviesFound(nil)
                    return
            }
        }
    
        guard Connectivity.isConnectedToInternet() else {
            self.latestMovies = []
            connectionErrors[SectionNames.latest.rawValue] = true
            isOnConnection[0] = false
            delegate?.latestMoviesFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlLatestMovies()
        service.makeHTTPGetRequest(url, MovieList.self) { (latestMovie, error) in
            self.latestMovies = latestMovie?.list ?? []
            self.connectionErrors[SectionNames.latest.rawValue] = error != nil
            if error == nil {
                let now = Date().toString()
                UserDefaults.standard.set(now, forKey: UserDefaultKeys.lastUpdateLatestRelease)
                let latestCache = LatestMovies()
                latestCache.movies.append(objectsIn: self.latestMovies)
                do {
                    try self.realm?.write {
                        self.realm?.add(latestCache, update: true)
                    }
                } catch {}
            }
            self.isOnConnection[0] = false
            self.delegate?.latestMoviesFound(error)
        }
        
    }
}

