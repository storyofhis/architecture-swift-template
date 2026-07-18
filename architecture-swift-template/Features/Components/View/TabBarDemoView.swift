//
//  TabBarDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct TabBarDemoView: View {

    private enum DemoTab: Hashable {
        case inbox, activity, search
    }

    @State private var selection: DemoTab = .inbox
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $selection) {
            Tab("Inbox", systemImage: "tray", value: DemoTab.inbox) {
                placeholder(title: "Inbox", systemImage: "tray")
            }
            .badge(3)

            Tab("Activity", systemImage: "bell", value: DemoTab.activity) {
                placeholder(title: "Activity", systemImage: "bell")
            }

            Tab(value: DemoTab.search, role: .search) {
                NavigationStack {
                    placeholder(title: "Search", systemImage: "magnifyingglass")
                        .searchable(text: $searchText)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .navigationTitle("Tab Bar")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func placeholder(title: String, systemImage: String) -> some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text("Embedded TabView demo — switch tabs to see the iOS 26 minimize behavior."))
    }
}

#Preview {
    NavigationStack {
        TabBarDemoView()
    }
}
