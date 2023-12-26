//
//  GridSection.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import Foundation

struct GridSection: Identifiable {
    let id: String
    let entries: [GridEntry]
    let title: String?
}

extension GridSection {
    static func gridEntriesSectionedByDate(_ entries: [GridEntry]) -> [GridSection] {
        let calendar = Calendar.current
        let groupedEntries = Dictionary(grouping: entries) { entry -> Date in
            calendar.startOfDay(for: entry.job.enqueueDate)
        }
        return groupedEntries.map { (date, entries) in
            let formattedDate = date.formattedDateForGrid()
            return GridSection(
                id: String(format: "%.0f", date.timeIntervalSince1970),
                entries: entries,
                title: formattedDate
            )
        }.sorted {
            TimeInterval($0.id)! > TimeInterval($1.id)!
        }
    }
}

extension Date {
    func formattedDateForGrid() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: self)

        if startOfDay == today {
            return "Today"
        } else if startOfDay == calendar.date(byAdding: .day, value: -1, to: today) {
            return "Yesterday"
        } else if let daysAgo = calendar.dateComponents([.day], from: startOfDay, to: today).day, daysAgo <= 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        } else {
            return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
        }
    }
}
