//
//  LatestMovies.swift
//  POP Flix
//
//  Created by Rene X on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class LatestMovies: Object {
    
    // MARK: Properties
    @objc dynamic var id = 0
    let movies = List<Movie>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
