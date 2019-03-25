//
//  ServiceConnection.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire

class ServiceConnection {
    let jsonDecoder = JSONDecoder()
    static let language = Language.english
    
    // MARK: - URL with parameters
    static func urlMovie(_ id: Int) -> String {
        let url = TheMovieDBAPI.urlMovie +
            "/\(id)" +
            "?api_key=\(TheMovieDBAPI.apiKey)" +
            "&language=\(language)"
        return url
    }
    
    static func urlSimilarMovies(_ id: Int) -> String {
        let url = TheMovieDBAPI.urlMovie +
            "/\(id)" +
            "/similar" +
            "?api_key=\(TheMovieDBAPI.apiKey)" +
            "&language=\(language)"  +
            "&page=1"
        return url
    }
    
    static func urlLatestMovies() -> String {
        let url = TheMovieDBAPI.urlMovie +
            "/now_playing" +
            "?api_key=\(TheMovieDBAPI.apiKey)" +
            "&language=\(language)"  +
//            "&region=BR" +
            "&page=1"
        return url
    }
    
    // MARK: - Custom Requests (Get - Post - Authentication)
    func makeHTTPGetRequest<T:Codable>(_ url: String,_ type: T.Type, onCompletion: @escaping (T?) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let object = try self.jsonDecoder.decode(type, from: data)
                    onCompletion(object)
                    return
                } catch {
                    onCompletion(nil)
                }
            }
        }
    }
}