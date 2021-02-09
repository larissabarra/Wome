//
//  ContentView.swift
//  Wome
//
//  Created by Larissa Barra Conde on 08/02/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "thermometer")
                }
                .tag(0)
         
            Text("Chart Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Label("Chart", systemImage: "calendar")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
