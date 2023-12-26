//
//  JobsColumn.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import Foundation

import Midjourney

struct JobsColumn: Identifiable {
    let id: String = UUID().uuidString
    let jobs: [Midjourney.Job]
}

extension JobsColumn {
    static func columnsForJobs(_ jobs: [Midjourney.Job], columnCount: Int) -> [JobsColumn] {
        var distributedArrays = Array(repeating: [Midjourney.Job](), count: columnCount)
        var heights = Array(repeating: CGFloat(0), count: columnCount)
        for job in jobs {
            // Find the index of the array with the smallest total height
            if let minHeightIndex = heights.firstIndex(of: heights.min() ?? 0) {
                distributedArrays[minHeightIndex].append(job)
                heights[minHeightIndex] += (CGFloat(job.height) / CGFloat(job.width))
            }
        }
        return distributedArrays.compactMap { jobs in
            return JobsColumn(jobs: jobs)
        }
    }
}
