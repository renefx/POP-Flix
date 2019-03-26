//
//  Constants.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation

struct General {
    static let appName = "POP Flix"
    static let none = ""
    static let dash = "-"
    static let dashCharacter: Character = "-"
    static let space = " "
    static let noWifiImage = "no-wifi"
    static let reloadImage = "reload"
    static let errorCellImage = "errorCell"
    static let dateRegex = "^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$"
    static let genresText = "Genres: "
    static let movieText = "Movie"
    static let queueName = "com.renefx"
}

struct ShareMessages {
    static let movie = "Hey check out this movie: "
    static let movieUrl = "https://www.imdb.com/title/"
}

struct Font {
    static let fontThin = "Montserrat-Thin"
    static let fontExtraLight = "Montserrat-ExtraLight"
    static let fontLight = "Montserrat-Light"
    static let fontRegular = "Montserrat-Regular"
    static let fontMedium = "Montserrat-Medium"
    static let fontSemibold = "Montserrat-Semibold"
    static let fontBold = "Montserrat-Bold"
    static let fontBlack = "Montserrat-Black"
}

struct ErrorMessages {
    static let noInternet = "Check your Internet connection 🤷‍♂️"
    static let noMovie = "No movie found 🕵️‍♂️"
    static let unexpectedError = "No data available\nPull to refresh"
    static let noInternetShort = "Check your Internet connection"
    static let unexpectedErrorShort = "No data available"
    static let noFavorites = "You don't have any movie saved 🧐"
    
}

enum RequestErrors: String {
    case noInternet
    case unexpectedError
    
    var message: String {
        switch self {
        case .noInternet:
            return "Check your Internet connection\nPull to refresh"
        case .unexpectedError:
            return "No data available\nPull to refresh"
        }
    }
}

struct AlertNoInternet {
    static let title = "Cellular Data is Turned Off"
    static let message = "Turn on cellular data or use Wi-Fi to access data."
    static let settings = "Settings"
    static let ok = "OK"
}

struct SegueIdentifier {
    static let containerMoviePage = "containerMoviePageSegueIdentifier"
}

struct StoryboardID {
    static let storyboardName = "Main"
    static let bigPoster = "bigPosterViewControllerID"
    static let launcher = "LauncherViewControllerID"
    static let movieDetail = "MovieDetailTableViewControllerID"
    
}

struct CellIdentifier {
    static let movieList = "cellMovieListIdentifier"
    static let poster = "posterCellIdentifier"
    static let posterDetail = "posterDetailIdentifier"
    static let favorites = "favoritesCell"
    
}

enum ImageSize: String {
    case poster_big = "original"
    case poster = "w185"
}

struct TheMovieDBAPI {
    static let urlImages = "https://image.tmdb.org/t/p/"
    static let urlMovie = "https://api.themoviedb.org/3/movie"
    static let urlSearch = "https://api.themoviedb.org/3/search/movie"
    static let apiKey = "6302949d7afd94f9edd948caf36b33c2"
}

struct Language {
    static let english = "en-US"
    static let portugues = "pt-BR"
}

struct UserDefaultKeys {
    static let lastUpdateLatestRelease = "lastUpdateLatestRelease"
}

