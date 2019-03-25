//
//  Genres.swift
//
//  Created by Renê Xavier on 24/03/19
//  Copyright (c) Renefx. All rights reserved.
//

import Foundation

public struct Genres: Codable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
  }

  // MARK: Properties
  public var id: Int?
  public var name: String?
    
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(Int.self, forKey: .id)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
  }
}
