//
//  DateExtension.swift
//  POP Flix
//
//  Created by Rene X on 26/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import Foundation

extension Date {
    var dayOfWeek: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).uppercased()
        }
    }
    
    var hourMinutes: String? {
        get {
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: self)
            if let hour = comp.hour, let minute = comp.minute {
                return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
            } else if let hour = comp.hour {
                return "\(String(format: "%02d", hour)):\(00)"
            }
            return nil
        }
    }
    
    func toString(format: String = General.dateUserDefaultFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func removeHour(numberOfHours: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .hour, value: -numberOfHours, to: self)
        return endDate ?? Date()
    }
}
