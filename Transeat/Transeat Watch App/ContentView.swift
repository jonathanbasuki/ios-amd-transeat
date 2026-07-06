import SwiftUI

struct ContentView: View {
    @StateObject private var flow = AppFlowViewModel()
     
    @ViewBuilder
    var body: some View {
        switch flow.currentScreen {
        case .welcome:
            WelcomeView()
 
        case .locating:
            LocatingView()
 
        case .confirmSeat:
            ConfirmSeatView(
                onConfirm: { flow.seatCheckConfirmed(hasSeat: true) },
                onNotYet: { flow.seatCheckConfirmed(hasSeat: false) }
            )
 
        case .changeTrain:
            ChangeTrainView(
                onConfirm: { flow.changeTrainAnswered(isChanging: true) },
                onLastTrain: { flow.changeTrainAnswered(isChanging: false) }
            )
 
        case .countdownSeated:
            CountdownSeatedView(countdown: flow.countdown)
 
        case .countdownNotSeated:
            CountdownNotSeatedView(countdown: flow.countdown)
 
        case .enjoyTrip:
            EnjoyTripView()
        }
    }
}

#Preview {
    ContentView()
}
