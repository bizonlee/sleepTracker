
import Foundation
import SwiftData

@Model
class Day {
    var id: UUID = UUID()
    var date: Date
    var sleepRecords: [SleepRecord]
    
    init(date: Date) {
        self.date = date
        self.sleepRecords = []
    }
}
