//
//  SimilarMovies.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation

public struct MovieList: Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case list = "results"
    }
    
    // MARK: Properties
    public var page: Int?
    public var list: [Movie]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page)
        self.list = try container.decodeIfPresent([Movie].self, forKey: .list)
    }
}
