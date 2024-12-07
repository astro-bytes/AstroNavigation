//
//  ContentView.swift
//  SampleApp
//
//  Created by Porter McGary on 12/7/24.
//

import SwiftUI
import AstroNavigation

struct ContentView: View {
    @State private var navigator: AppNavigator = .init()
    
    var body: some View {
        Text("selection \(navigator.tabSelection)")
        Text("root \(navigator.root)")
        
        TabView(selection: $navigator.tabSelection) {
            ForEach(AppNavigator.Tab.allCases) { tab in
                Tab(tab.name, systemImage: tab.systemImage, value: tab) {
                    Text("Hello from \(tab.name)")
                }
            }
        }
        .syncTabs(for: navigator)
        .navigationSheet($navigator) { destination in
            switch destination {
            case .helloWorld:
                Text("Hello World")
            default:
                EmptyView()
            }
        }
        .navigationFullScreenCover($navigator) { destination in
            switch destination {
            case .goodbyeWorld:
                Text("Goodbye World")
            default:
                EmptyView()
            }
        }
        .environment(navigator)
    }
}

#Preview {
    ContentView()
}
