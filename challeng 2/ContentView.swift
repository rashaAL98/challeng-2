import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LearningGoalViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Centered flame icon with gray circle background
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                    Text("🔥")
                        .font(.system(size: 60))
                }
                .padding(.top, 50)

                // Greeting Text
                Text("Hello Learner!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("This app will help you learn everyday")
                    .foregroundColor(.gray)

                // Learning Input with gray line below
                VStack(alignment: .leading) {
                    Text("I want to learn")
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    TextField("Swift", text: $viewModel.goal.subject)
                        .padding(.vertical, 8)
                        .background(Color.clear)
                        .foregroundColor(.white)

                    Divider() // Gray line below the text field
                        .background(Color.gray)
                        .padding(.top, -8) // Adjust to align closely with the text field
//                }
                .padding(.horizontal)

                // Time Frame Selector with Left Alignment
//                VStack(alignment: .leading) {
                    Text("I want to learn it in a")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 8)

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
                                    .font(.body)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Start Button with arrow
                NavigationLink(destination: ProgressView(viewModel: viewModel)) {
                    HStack {
                        Text("Start")
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    ContentView()
}
