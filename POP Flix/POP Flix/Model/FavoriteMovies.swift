//
//  FavoriteMovies.swift
//  POP Flix
//
//  Created by Renê Xavier on 25/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class FavoriteMovies: Object, Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private enum CodingKeys: String, CodingKey {
        case movie
        case posterImage
        case id
        case colorPrimary
        case colorSecondary
        case colorDetail
        case colorBackground
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Properties
    @objc dynamic var movie: Movie?
    @objc dynamic var posterImage: Data? = nil
    let id = RealmOptional<Int>()
    @objc dynamic var colorPrimary: String? = nil
    @objc dynamic var colorSecondary: String? = nil
    @objc dynamic var colorDetail: String? = nil
    @objc dynamic var colorBackground: String? = nil
    
    required init() {
        super.init()
    }
    
    convenience init(movie: Movie?, posterImage: Data?, colorPrimary: String?, colorSecondary: String?, colorDetail: String?, colorBackground: String?) {
        self.init()
        self.movie = movie
        self.id.value = movie?.id.value
        self.posterImage = posterImage
        self.colorPrimary = colorPrimary
        self.colorSecondary = colorSecondary
        self.colorDetail = colorDetail
        self.colorBackground = colorBackground
    }
    
    convenience required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let movie = try container.decodeIfPresent(Movie.self, forKey: .movie)
        let posterImage = try container.decodeIfPresent(Data.self, forKey: .posterImage)
        let colorPrimary = try container.decodeIfPresent(String.self, forKey: .colorPrimary)
        let colorSecondary = try container.decodeIfPresent(String.self, forKey: .colorSecondary)
        let colorDetail = try container.decodeIfPresent(String.self, forKey: .colorDetail)
        let colorBackground = try container.decodeIfPresent(String.self, forKey: .colorBackground)
        
        self.init(movie: movie, posterImage: posterImage, colorPrimary: colorPrimary, colorSecondary: colorSecondary, colorDetail: colorDetail, colorBackground: colorBackground)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.value, forKey: .id)
        try container.encode(movie, forKey: .movie)
        try container.encode(posterImage, forKey: .posterImage)
        try container.encode(colorPrimary, forKey: .colorPrimary)
        try container.encode(colorSecondary, forKey: .colorSecondary)
        try container.encode(colorDetail, forKey: .colorDetail)
        try container.encode(colorBackground, forKey: .colorBackground)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
