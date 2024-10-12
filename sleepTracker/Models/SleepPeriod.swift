//
//  SleepPeriod.swift
//  sleepTracker
//
//  Created by Zhdanov Konstantin on 10.10.2024.
//

import Foundation
import SwiftData

@Model
class SleepRecord {
    var id: UUID = UUID()
    var startTime: Date
    var endTime: Date?
    
    init(startTime: Date, endTime: Date? = nil) {
        self.startTime = startTime
        self.endTime = endTime
    }
}
