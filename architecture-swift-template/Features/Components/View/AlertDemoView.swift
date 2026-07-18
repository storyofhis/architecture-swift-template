//
//  AlertDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct AlertDemoView: View {

    @State private var showSimpleAlert = false
    @State private var showDestructiveAlert = false
    @State private var showInputAlert = false
    @State private var enteredName = ""
    @State private var lastSubmittedName = ""

    var body: some View {
        List {
            Section("Alerts") {
                Button("Simple Alert") { showSimpleAlert = true }

                Button("Destructive Alert", role: .destructive) { showDestructiveAlert = true }

                Button("Alert with Text Field") { showInputAlert = true }
            }

            if !lastSubmittedName.isEmpty {
                Section("Last Input") {
                    Text(lastSubmittedName)
                }
            }
        }
        .navigationTitle("Alert")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Update Available", isPresented: $showSimpleAlert) {
            Button("OK") {}
        } message: {
            Text("A new version of this app is ready to install.")
        }
        .alert("Delete Item", isPresented: $showDestructiveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Enter Your Name", isPresented: $showInputAlert) {
            TextField("Name", text: $enteredName)
            Button("Cancel", role: .cancel) { enteredName = "" }
            Button("Save") {
                lastSubmittedName = enteredName
                enteredName = ""
            }
        } message: {
            Text("Used to prefill your profile.")
        }
    }
}

#Preview {
    NavigationStack {
        AlertDemoView()
    }
}
