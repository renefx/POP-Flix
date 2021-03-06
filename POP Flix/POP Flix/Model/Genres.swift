//
//  Genres.swift
//
//  Created by Renê Xavier on 24/03/19
//  Copyright (c) Renefx. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class Genres: Object, Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    // MARK: Properties
    public let id = RealmOptional<Int>()
    @objc dynamic var name: String? = nil
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    //    public var id: Int?
    //    public var name: String?
    
    required init() {
        super.init()
    }
    
    convenience init(id: Int?, name: String?) {
        self.init()
        self.id.value = id
        self.name = name
    }
    
    convenience required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        
        self.init(id: id, name: name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.value, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
