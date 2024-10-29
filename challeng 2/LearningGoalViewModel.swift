import Foundation
import Combine

class LearningGoalViewModel: ObservableObject {
    @Published var goal: LearningGoal
    @Published var selectedTimeFrame: String
    @Published private(set) var totalFreezesAllowed: Int
    
    init(subject: String = "Swift", timeframe: String = "Month") {
        self.goal = LearningGoal(subject: subject, timeframe: timeframe)
        self.selectedTimeFrame = timeframe
        self.totalFreezesAllowed = Self.calculateFreezes(for: timeframe)
    }

    func updateTimeframe(_ timeframe: String) {
        selectedTimeFrame = timeframe
        goal.timeframe = timeframe
        totalFreezesAllowed = Self.calculateFreezes(for: timeframe)
    }
    
    func updateLearningGoal(subject: String) {
        goal.subject = subject
    }
    
    private static func calculateFreezes(for timeframe: String) -> Int {
        switch timeframe {
        case "Week":
            return 2
        case "Month":
            return 6
        case "Year":
            return 12
        default:
            return 6
        }
    }
    
    var formattedMonthAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    var formattedFullDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
}
