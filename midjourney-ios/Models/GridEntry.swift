//
//  GridEntry.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/25/23.
//

import Foundation

import Midjourney

struct GridEntry: Identifiable {
    var id: String {
        return image.id
    }
    let job: Midjourney.Job
    let image: Midjourney.Job.Image
}

extension GridEntry {
    static func entriesForJobs(_ jobs: [Midjourney.Job]) -> [GridEntry] {
        return jobs.flatMap { job in
            job.images.compactMap { image in
                GridEntry(job: job, image: image)
            }
        }
    }
}
