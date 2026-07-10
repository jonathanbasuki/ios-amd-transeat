import SwiftUI

struct ContentView: View {
    @StateObject private var flow = AppFlowViewModel()
     
    @ViewBuilder
    var body: some View {
        switch flow.currentScreen {
            case .home:
                WelcomeView()
     
            case .locating:
                LocatingView()
     
            case .beaconFound:
                FoundView()
                
            case .beaconNotFound:
                NotFoundView()
                
            case .askSeated:
                AskSeatedView(
                    onConfirm: { flow.seatCheckConfirmed(hasSeat: true) },
                    onNotYet: { flow.seatCheckConfirmed(hasSeat: false) }
                )
     
            case .changeTrain:
                ChangeTrainView(
                    onConfirm: { flow.changeTrainAnswered(isChanging: true) },
                    onLastTrain: { flow.changeTrainAnswered(isChanging: false) }
                )
                
            case .seatConfirmed:
                SeatConfirmedView()
            
            case .seatNotConfirmed:
                NotSeatedView()
     
            case .enjoyTrip:
                EnjoyTripView()
        }
    }
}

#Preview {
    ContentView()
}
