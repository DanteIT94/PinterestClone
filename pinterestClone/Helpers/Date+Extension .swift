//
//  Date+Extension .swift
//  pinterestClone
//
//  Created by Денис on 25.05.2023.
//

import Foundation

private  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
} ()

extension Date {
    var dateTimeString: String {
            var dateString = dateFormatter.string(from: self)
            dateString = dateString.replacingOccurrences(of: "г.", with: "")
            return dateString
        }
}
