//
//  HomeHeaderView.swift
//  transeatluv
//

import SwiftUI

struct HomeHeaderView: View {
    let expectedDueDate: String

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Halo, Mama!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                Text("Hari Perkiraan Lahir: \(expectedDueDate)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.hexPalette.darkgray)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(Color.hexPalette.cherry500)
        }
        .padding(20)
    }
}

#Preview {
    HomeHeaderView(expectedDueDate: "12/04/2027")
}
