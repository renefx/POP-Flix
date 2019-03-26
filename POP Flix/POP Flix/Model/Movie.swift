//
//  Movie.swift
//
//  Created by Renê Xavier on 24/03/19
//  Copyright (c) Renefx. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class Movie: Object, Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private enum CodingKeys: String, CodingKey {
        case budget = "budget"
        case backdropPath = "backdrop_path"
        case revenue = "revenue"
        case voteCount = "vote_count"
        case movieDescription = "overview"
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
    public let budget = RealmOptional<Int>()
    @objc dynamic var backdropPath: String? = nil
    public let revenue = RealmOptional<Int>()
    public let voteCount = RealmOptional<Int>()
    @objc dynamic var movieDescription: String? = nil
    public let voteAverage = RealmOptional<Float>()
    public let video = RealmOptional<Bool>()
    @objc dynamic var imdbId: String? = nil
    public let id = RealmOptional<Int>()
    @objc dynamic var title: String? = nil
    @objc dynamic var homepage: String? = nil
    @objc dynamic var posterPath: String? = nil
    public let adult = RealmOptional<Bool>()
    @objc dynamic var genres: String? = nil
    @objc dynamic var status: String? = nil
    public let runtime = RealmOptional<Int>()
    @objc dynamic var originalTitle: String? = nil
    @objc dynamic var releaseDate: String? = nil
    @objc dynamic var originalLanguage: String? = nil
    public let popularity = RealmOptional<Float>()
    @objc dynamic var tagline: String? = nil
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public var voteAverageFull: String {
        get {
            guard let voteAverage = voteAverage.value else { return "-" + " " }
            return "\(String(format: "%.1f", voteAverage))/10 "
        }
    }
    
    public var runtimeFull: String {
        get {
            guard let runtime = runtime.value else { return "-" + " " }
            return String(format: "%ih%02dm ", runtime/60, runtime%60)
        }
    }
    
    public var yearReleased: String {
        get {
            let dateRegex = "^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$"
            guard let releaseDate = self.releaseDate, releaseDate.matches(dateRegex) else { return "-" }
            return String(releaseDate.split(separator: "-")[0])
        }
    }
    
    public var genresFull: String? {
        get {
            guard let genres = genres else { return nil }
            return "Genres: " + genres
        }
    }
    
    required init() {
        super.init()
    }
    
    convenience init(_ budget: Int?,
                     _ backdropPath: String?,
                     _ revenue: Int?,
                     _ voteCount: Int?,
                     _ movieDescription: String?,
                     _ voteAverage: Float?,
                     _ video: Bool?,
                     _ imdbId: String?,
                     _ id: Int?,
                     _ title: String?,
                     _ homepage: String?,
                     _ posterPath: String?,
                     _ adult: Bool?,
                     _ genres: String?,
                     _ status: String?,
                     _ runtime: Int?,
                     _ originalTitle: String?,
                     _ releaseDate: String?,
                     _ originalLanguage: String?,
                     _ popularity: Float?,
                     _ tagline: String?) {
        self.init()
        self.budget.value = budget
        self.backdropPath = backdropPath
        self.revenue.value = revenue
        self.voteCount.value = voteCount
        self.movieDescription = description
        self.voteAverage.value = voteAverage
        self.video.value = video
        self.imdbId = imdbId
        self.id.value = id
        self.title = title
        self.homepage = homepage
        self.posterPath = posterPath
        self.adult.value = adult
        self.genres = genres
        self.status = status
        self.runtime.value = runtime
        self.originalTitle = originalTitle
        self.releaseDate = releaseDate
        self.originalLanguage = originalLanguage
        self.popularity.value = popularity
        self.tagline = tagline
    }
    
    
    convenience required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        
        let voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
        let runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        let releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        
        let tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        let movieDescription = try container.decodeIfPresent(String.self, forKey: .movieDescription)
        
        var genres: String?
        if let genresDecoded = try container.decodeIfPresent([Genres].self, forKey: .genres) {
            let genresNames = genresDecoded.map{ $0.name }
            genres = genresNames.reduce("") { (subtotal, genre) in
                guard let subtotal = subtotal else { return genre }
                guard let genre = genre else { return subtotal }
                return subtotal + ", " + genre
            }
        }
        
        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        
        let budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        let revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        let voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        let video = try container.decodeIfPresent(Bool.self, forKey: .video)
        let imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        let adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        
        let status = try container.decodeIfPresent(String.self, forKey: .status)
        let originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        let originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        let popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
        self.init(budget, backdropPath, revenue, voteCount, movieDescription, voteAverage, video, imdbId, id, title, homepage, posterPath, adult, genres, status, runtime, originalTitle, releaseDate, originalLanguage, popularity, tagline)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(budget.value, forKey: .budget)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(revenue.value, forKey: .revenue)
        try container.encode(voteCount.value, forKey: .voteCount)
        try container.encode(movieDescription, forKey: .movieDescription)
        try container.encode(voteAverage.value, forKey: .voteAverage)
        try container.encode(video.value, forKey: .video)
        try container.encode(imdbId, forKey: .imdbId)
        try container.encode(id.value, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(homepage, forKey: .homepage)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(adult.value, forKey: .adult)
        try container.encode(genres, forKey: .genres)
        try container.encode(status, forKey: .status)
        try container.encode(runtime.value, forKey: .runtime)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(popularity.value, forKey: .popularity)
        try container.encode(tagline, forKey: .tagline)
    }
    
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
