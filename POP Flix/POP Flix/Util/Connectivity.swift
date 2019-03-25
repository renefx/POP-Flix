//
//  Connectivity.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        guard let networkReachabilityManager = NetworkReachabilityManager() else {
            return false
        }
        return networkReachabilityManager.isReachable
    }
}
