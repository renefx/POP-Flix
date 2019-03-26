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
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Properties
    @objc dynamic var movie: Movie?
    @objc dynamic var posterImage: Data? = nil
    let id = RealmOptional<Int>()
    
    required init() {
        super.init()
    }
    
    convenience init(movie: Movie?, posterImage: Data?) {
        self.init()
        self.movie = movie
        self.id.value = movie?.id.value
        self.posterImage = posterImage
    }
    
    convenience required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let movie = try container.decodeIfPresent(Movie.self, forKey: .movie)
        let posterImage = try container.decodeIfPresent(Data.self, forKey: .posterImage)
        
        self.init(movie: movie, posterImage: posterImage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.value, forKey: .id)
        try container.encode(movie, forKey: .movie)
        try container.encode(posterImage, forKey: .posterImage)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
