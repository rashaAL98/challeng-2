import SwiftUI

struct LearningGoalView: View {
    @ObservedObject var viewModel: LearningGoalViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            // Header with Back and Update Buttons
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.orange)
                }

                Spacer()

                Text("Learning goal")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss after updating the goal
                }) {
                    Text("Update")
                        .foregroundColor(.orange)
                        .bold()
                }
            }
            .padding()

            // Learning Subject Input
            VStack(alignment: .leading) {
                Text("I want to learn")
                    .foregroundColor(.white)
                    .fontWeight(.bold)

                TextField("Swift", text: $viewModel.goal.subject)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .foregroundColor(.white)

                Divider() // Gray line below the text field
                    .background(Color.gray)
                    .padding(.top, -8) // Adjust to align closely with the text field
//            }
            .padding(.horizontal)

            // Time Frame Selector with Left Alignment
//            VStack(alignment: .leading) {
                Text("I want to learn it in a")
                    .foregroundColor(.white)
                    .fontWeight(.bold)

                HStack(spacing: 10) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { timeframe in
                        Button(action: {
                            viewModel.updateTimeframe(timeframe)
                        }) {
                            Text(timeframe)
                                .frame(width: 80, height: 40)
                                .background(viewModel.selectedTimeFrame == timeframe ? Color.orange : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.selectedTimeFrame == timeframe ? .black : .orange)
                                .cornerRadius(10)
                                .font(.body) // Regular weight font for unselected state
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Black background
    }
}

#Preview {
    LearningGoalView(viewModel: LearningGoalViewModel())
}
