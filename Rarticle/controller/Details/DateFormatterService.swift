//
//  DateFormatterService.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 20/07/2022.
//

import Foundation

class DateFormatterService {
    func dateFormatter(date: String) -> String {
        let regexPattern = try! NSRegularExpression(pattern: Constants.regexPatternAZ)
        let range = NSMakeRange(0, date.count)
        let newDate = regexPattern.stringByReplacingMatches(in: date, range: range, withTemplate: " ")
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.beforeDateFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constants.afterDateFormat
        
        let showDate = inputFormatter.date(from: newDate)
        return outputFormatter.string(from: showDate!)
    }
}
