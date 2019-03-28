//
//  SearchMoviesPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import UIImageColors

protocol SearchMoviesPresenterDelegate: AnyObject {
    func movieFound(_ error: RequestErrors?)
}

class SearchMoviesPresenter {
    private var searchedMovies: [Movie] = []
    private var colorMovies: [UIImageColors?] = []
    private var moviesPosters: [UIImage?] = []
    weak var delegate: SearchMoviesPresenterDelegate?
    private var service = ServiceConnection()
    private var hadError: RequestErrors?
    
    var hasMovies: Bool {
        get {
            return searchedMovies.count == 0
        }
    }
    
    var qtdCellSearchedMovies: Int {
        get {
            return searchedMovies.count
        }
    }
    
    func movieTitle(at row: Int) -> String? {
        guard hadError == nil else {
            if let hadError = hadError, hadError == .noInternet {
                return ErrorMessages.noInternet
            }
            return ErrorMessages.noMovie
        }
        guard searchedMovies.count > row else {
            return nil
        }
        return searchedMovies[row].title
    }
    
    func movieTagline(at row: Int) -> String? {
        guard searchedMovies.count > row else {
            return nil
        }
        return searchedMovies[row].tagline
    }
    
    func backgroundColor(at row: Int) -> UIColor {
        guard colorMovies.count > row,
            let color = colorMovies[row] else {
            return .white
        }
        return color.background
    }
    
    func textColor(at row: Int) -> UIColor {
        guard colorMovies.count > row,
            let color = colorMovies[row] else {
            return .black
        }
        return color.primary
    }
    
    // MARK: - Image for poster
    
    public func posterForCellAt(_ row: Int) -> UIImage? {
        guard row < moviesPosters.count else {
                return UIImage(named: General.errorCellImage)
        }
        return moviesPosters[row] ?? UIImage(named: General.errorCellImage)
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
    
    
    func movie(at row: Int) -> Movie? {
        guard searchedMovies.count > row else {
            return nil
        }
        return searchedMovies[row]
    }
    
    // MARK: - Request
    func searchForMovie(_ name: String?) {
        
        guard Connectivity.isConnectedToInternet(), let name = name else {
            self.searchedMovies = []
            self.hadError = .noInternet
            delegate?.movieFound(.noInternet)
            return
        }
        
        let url = ServiceConnection.urlSearchMovies(name)
        service.makeHTTPGetRequest(url, MovieList.self) { (movieList, error) in
            guard let movieResults = movieList?.list else {
                self.searchedMovies = []
                self.delegate?.movieFound(error)
                return
            }
            self.searchedMovies = movieResults
            self.colorMovies = []
            self.moviesPosters = []
            for movie in movieResults {
                if let path = movie.posterPath,
                    let posterData = self.imageDataForPath(path),
                    let image = UIImage(data: posterData) {
                    self.moviesPosters.append(image)
                    self.colorMovies.append(image.getColors())
                } else {
                    self.moviesPosters.append(UIImage(named: "errorCellImage"))
                    self.colorMovies.append(nil)
                }
            }
            self.hadError = error == nil ? nil : .unexpectedError
            self.delegate?.movieFound(error)
        }
    }
}
