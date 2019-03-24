//
//  Constants.swift
//  POP Flix
//
//  Created by Renê Xavier on 23/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation

struct General {
    static let none = ""
    static let dash = "-"
    static let noWifiImage = "no-wifi"
}

struct Font {
    static let fontMedium = "Montserrat-Medium"
    static let fontLight = "Montserrat-Light"
    static let fontSemibold = "Montserrat-Semibold"
}

struct ErrorMessages {
    static let noInternet = "Check your Internet connection\nPull to refresh"
    static let unexpectedError = "No data available\nPull to refresh"
    static let noInternetShort = "Check your Internet connection"
    static let unexpectedErrorShort = "No data available"
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
}

struct CellIdentifier {
    static let movieList = "cellMovieListIdentifier"
    static let poster = "posterCellIdentifier"
    static let posterDetail = "posterDetailIdentifier"
}

struct OpenWeatherAPI {
    static let urlCurrentWeather = "https://api.openweathermap.org/data/2.5/weather?"
    static let urlForecast = "https://api.openweathermap.org/data/2.5/forecast?"
    static let apiKey = "b496cbb102e3b82b4e47438315bd449f"
}

struct UserDefaultKeys {
}

