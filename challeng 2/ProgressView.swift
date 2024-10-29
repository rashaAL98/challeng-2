import SwiftUI

struct ProgressView: View {
    @ObservedObject var viewModel: LearningGoalViewModel
    
    // State variables for ProgressView-specific logic
    @State private var currentDayLogged = false
    @State private var dayFreezed = false
    @State private var freezeCount = 2
    @State private var streakCount = 10
    @State private var currentDate = Date()
    @State private var learningStartDate = Date()
    @State private var dayStates: [Int: String] = [:]
    
    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 20) {
            // Header Section with Date and Subject
            HStack {
                VStack(alignment: .leading) {
                    Text(formattedFullDate(date: currentDate))
                        .foregroundColor(.gray)
                        .font(.subheadline)

                    Text("Learning \(viewModel.goal.subject)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()

                NavigationLink(destination: LearningGoalView(viewModel: viewModel)) {
                    Text("🔥").font(.system(size: 40))
                }
            }
            .padding(.horizontal)
            
            // Calendar and Counters Section
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.7))
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding([.leading, .bottom, .trailing])
                
                VStack {
                    // Month and Day Navigation Arrows
                    HStack {
                        Button(action: { navigateMonth(by: -1) }) {
                            Image(systemName: "chevron.left").foregroundColor(.orange)
                        }
                        
                        Text(formattedMonthAndYear(date: learningStartDate))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Button(action: { navigateMonth(by: 1) }) {
                            Image(systemName: "chevron.right").foregroundColor(.orange)
                        }
                        
                        Button(action: { navigateDay(by: -1) }) {
                            Image(systemName: "chevron.left").foregroundColor(.orange)
                        }
                        
                        Button(action: { navigateDay(by: 1) }) {
                            Image(systemName: "chevron.right").foregroundColor(.orange)
                        }
                    }
                    .font(.title2)
                    .padding(.bottom, 5)
                    
                    // Weekday Headers
                    HStack {
                        Text("SUN")
                        Text("MON")
                        Text("TUE")
                        Text("WED")
                        Text("THU")
                        Text("FRI")
                        Text("SAT")
                    }
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.bottom, 5)

                    // Days of the Learning Week with States
                    HStack(spacing: 5) {
                        ForEach(0..<7, id: \.self) { offset in
                            let dayDate = calendar.date(byAdding: .day, value: offset, to: learningStartDate) ?? Date()
                            calendarDayView(date: dayDate)
                        }
                    }

                    Divider()
                        .background(Color.gray)
                        .padding(.vertical)

                    // Streak and Freeze Counters
                    HStack {
                        VStack {
                            HStack {
                                Text("\(streakCount)")
                                Text("🔥")
                            }
                            .foregroundColor(.orange)
                            Text("Day streak")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding(.trailing)

                        Divider()
                            .frame(width: 1, height: 50)
                            .background(Color.gray)

                        VStack {
                            HStack {
                                Text("\(freezeCount)")
                                Text("🧊")
                            }
                            .foregroundColor(.blue)
                            Text("Day freezed")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding()
            }

            // "Log today as Learned" and "Freeze day" Buttons
            if !dayFreezed {
                Button(action: { logDayLearned() }) {
                    Circle()
                        .fill(currentDayLogged ? Color.brown : Color.orange)
                        .frame(width: 290, height: 290)
                        .overlay(
                            Text(currentDayLogged ? "Learned Today" : "Log today as Learned")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                }
            } else {
                Button(action: { resetDay() }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 290, height: 290)
                        .overlay(
                            Text("Day Freezed")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                }
            }

            // Freeze Day Button with Gray Background when Disabled
            Button(action: {
                if freezeCount < viewModel.totalFreezesAllowed {
                    freezeCount += 1
                    dayFreezed = true
                    dayStates[calendar.component(.day, from: currentDate)] = "Day Freezed"
                }
            }) {
                Text("Freeze day")
                    .foregroundColor((dayFreezed || freezeCount >= viewModel.totalFreezesAllowed || currentDayLogged) ? Color.gray : Color.blue)
                    .font(.title2)
                    .padding()
                    .frame(width: 220, height: 70)
                    .background((dayFreezed || freezeCount >= viewModel.totalFreezesAllowed || currentDayLogged) ? Color.gray.opacity(0.5) : Color(red: 0.8, green: 0.9, blue: 1.0))
                    .cornerRadius(10)
            }
            .disabled(dayFreezed || freezeCount >= viewModel.totalFreezesAllowed || currentDayLogged)
            
            Text("\(freezeCount) out of \(viewModel.totalFreezesAllowed) freezes used")
                .foregroundColor(.gray)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Helper Functions for ProgressView
    
    func navigateMonth(by months: Int) {
        learningStartDate = calendar.date(byAdding: .month, value: months, to: learningStartDate) ?? learningStartDate
    }

    func navigateDay(by days: Int) {
        currentDate = calendar.date(byAdding: .day, value: days, to: currentDate) ?? currentDate
    }

    func logDayLearned() {
        currentDayLogged.toggle()
        if currentDayLogged {
            streakCount += 1
            dayStates[calendar.component(.day, from: currentDate)] = "Learned Today"
        } else {
            dayStates[calendar.component(.day, from: currentDate)] = "Log today as Learned"
        }
    }
    
    func resetDay() {
        dayFreezed = false
        currentDayLogged = false
        dayStates[calendar.component(.day, from: currentDate)] = "Log today as Learned"
    }
    
    func getColors(for state: String) -> (foreground: Color, background: Color) {
        switch state {
        case "Log today as Learned":
            return (.white, .orange)
        case "Learned Today":
            return (.white, .brown)
        case "Day Freezed":
            return (.white, .blue)
        default:
            return (.gray, .clear)
        }
    }
    
    func formattedFullDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    func formattedMonthAndYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func calendarDayView(date: Date) -> some View {
        let dayNum = calendar.component(.day, from: date)
        let state = dayStates[dayNum] ?? "Unmarked"
        let (textColor, backgroundColor) = getColors(for: state)
        
        return Text("\(dayNum)")
            .foregroundColor(textColor)
            .font(.title2)
            .frame(width: 40, height: 40)
            .background(Circle().fill(backgroundColor))
    }
}

#Preview {
    ProgressView(viewModel: LearningGoalViewModel())
}
