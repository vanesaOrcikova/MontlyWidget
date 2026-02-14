//
//  ContentView.swift
//  Montly
//
//  Created by Vanesa Orcikova on 08/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            CalendarView()
                .navigationTitle("Kalendár")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
