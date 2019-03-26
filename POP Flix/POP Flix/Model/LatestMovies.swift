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
    let movies = List<Movie>()
}
