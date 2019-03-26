//
//  FavoritesPresenter.swift
//  POP Flix
//
//  Created by Renê Xavier on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritesPresenter {
    // MARK: - Variables
    private var realm: Realm?
    
    init(_ movie: Movie? = nil) {
        realm = try! Realm()
    }
    
    var qtdCellFavoriteMovies: Int {
        get {
            let favorites = realm?.objects(FavoriteMovies.self)
            if favorites?.count == 0 { return 1 }
            return favorites?.count ?? 1
        }
    }
    
    func movieTitle(at row: Int) -> String? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            return ErrorMessages.noFavorites
        }
        return favorites[row].movie?.title
    }
    
    func movieTagline(at row: Int) -> String? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            return nil
        }
        return favorites[row].movie?.tagline
    }
    
    func moviePoster(at row: Int) -> Data? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            return UIImage(named: General.errorCellImage)?.pngData()
        }
        return realm?.objects(FavoriteMovies.self)[row].posterImage
    }
    
    func movieBackgroundColor(at row: Int) -> String? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            let index = row % Color.colorArray.count
            return Color.colorArray[index].toHexString
        }
        return realm?.objects(FavoriteMovies.self)[row].colorBackground
    }
    
    func movieTextColor(at row: Int) -> String? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            return Color.black
        }
        return realm?.objects(FavoriteMovies.self)[row].colorPrimary
    }
    
    func movie(at row: Int) -> Movie? {
        guard let favorites = realm?.objects(FavoriteMovies.self), favorites.count > 0 else {
            return nil
        }
        return realm?.objects(FavoriteMovies.self)[row].movie
    }
    
    func deleteFavoriteMovie(at row: Int) {
        do {
            guard let favoriteMovie: FavoriteMovies = realm?.objects(FavoriteMovies.self)[row],
                let realm = realm else {
                    return
            }
            try realm.write {
                realm.delete(favoriteMovie)
            }
        } catch {
            return
        }
    }
}
