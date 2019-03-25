//
//  Movie.swift
//
//  Created by Renê Xavier on 24/03/19
//  Copyright (c) Renefx. All rights reserved.
//

import Foundation

public struct Movie: Codable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private enum CodingKeys: String, CodingKey {
    case budget = "budget"
    case backdropPath = "backdrop_path"
    case revenue = "revenue"
    case voteCount = "vote_count"
    case description = "overview"
    case voteAverage = "vote_average"
    case video = "video"
    case imdbId = "imdb_id"
    case id = "id"
    case title = "title"
    case homepage = "homepage"
    case posterPath = "poster_path"
    case adult = "adult"
    case genres = "genres"
    case status = "status"
    case runtime = "runtime"
    case originalTitle = "original_title"
    case releaseDate = "release_date"
    case originalLanguage = "original_language"
    case popularity = "popularity"
    case tagline = "tagline"
  }

  // MARK: Properties
  public var budget: Int?
  public var backdropPath: String?
  public var revenue: Int?
  public var voteCount: Int?
  public var description: String?
  public var voteAverage: Float?
  public var video: Bool? = false
  public var imdbId: String?
  public var id: Int?
  public var title: String?
  public var homepage: String?
  public var posterPath: String?
  public var adult: Bool? = false
  public var genres: String?
  public var status: String?
  public var runtime: Int?
  public var originalTitle: String?
  public var releaseDate: String?
  public var originalLanguage: String?
  public var popularity: Float?
  public var tagline: String?
    
    public var voteAverageFull: String {
        get {
            guard let voteAverage = voteAverage else { return General.dash + General.space }
            return "\(String(format: "%.1f", voteAverage))/10 "
        }
    }
    
    public var runtimeFull: String {
        get {
            guard let runtime = runtime else { return General.dash + General.space }
            return String(format: "%ih%02dm ", runtime/60, runtime%60)
        }
    }
    
    public var yearReleased: String {
        get {
            guard let releaseDate = releaseDate, releaseDate.matches(General.dateRegex) else { return General.dash }
            return String(releaseDate.split(separator: General.dashCharacter)[0])
        }
    }
    
    public var genresFull: String? {
        get {
            guard let genres = genres else { return nil }
            return General.genresText + genres
        }
    }


  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    
    self.voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
    self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
    self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    
    self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    
    if let genres = try container.decodeIfPresent([Genres].self, forKey: .genres) {
        let genresNames = genres.map{ $0.name }
        self.genres = genresNames.reduce("") { (subtotal, genre) in
            guard let subtotal = subtotal else { return genre }
            guard let genre = genre else { return subtotal }
            return subtotal + ", " + genre
        }
    }

    self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)

    self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
    self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
    self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
    self.imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
    self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
    
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
    self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
    self.popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
  }

}
