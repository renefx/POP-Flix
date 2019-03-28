//
//  ServiceTests.swift
//  POP FlixTests
//
//  Created by Renê Xavier on 28/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import XCTest
import Fakery
@testable import POP_Flix

class ServiceTests: XCTestCase {
    let faker = Faker()
    
    func testUrlSearch() {
        let search = "Deus é brasileiro"
        let result = ServiceConnection.urlSearchMovies(search)
        let url = "https://api.themoviedb.org/3/search/movie?api_key=6302949d7afd94f9edd948caf36b33c2&language=en-US&query=Deus%20%C3%A9%20brasileiro&page=1&include_adult=false"
        XCTAssertEqual(result, url)
        
        let search1 = "Brandão"
        let result1 = ServiceConnection.urlSearchMovies(search1)
        let url1 = "https://api.themoviedb.org/3/search/movie?api_key=6302949d7afd94f9edd948caf36b33c2&language=en-US&query=Brand%C3%A3o&page=1&include_adult=false"
        XCTAssertEqual(result1, url1)
    }
    
    func testUrlMovieId() {
        let movieId = faker.number.randomInt()
        let result = ServiceConnection.urlMovie(movieId)
        let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=6302949d7afd94f9edd948caf36b33c2&language=en-US"
        XCTAssertEqual(result, url)
    }
    
    func testUrlSimilarMovieId() {
        let movieId = faker.number.randomInt()
        let result = ServiceConnection.urlSimilarMovies(movieId)
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=6302949d7afd94f9edd948caf36b33c2&language=en-US&page=1"
        XCTAssertEqual(result, url)
    }

}
