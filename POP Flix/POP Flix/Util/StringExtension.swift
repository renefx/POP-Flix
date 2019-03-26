//
//  StringExtension.swift
//  POP Flix
//
//  Created by Renê Xavier on 24/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation

extension String {
    var toDateUserDefault: Date? {
        get {
            guard self.matches(General.dateUserDefaultRegex) else { return nil }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = General.dateUserDefaultFormat
            return dateFormatter.date(from: self)
        }
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
