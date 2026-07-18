//
//  KeyboardDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct KeyboardDemoView: View {

    private enum Field: Hashable {
        case email
        case amount
        case notes
    }

    @State private var email = ""
    @State private var amount = ""
    @State private var notes = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        Form {
            Section("Email Keyboard + Submit") {
                TextField("Email", text: $email, prompt: Text("name@example.com"))
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit { focusedField = .amount }
            }

            Section("Number Pad") {
                TextField("Amount", text: $amount, prompt: Text("0.00"))
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .amount)
                    .onSubmit { focusedField = .notes }
            }

            Section("Keyboard Accessory Toolbar") {
                TextField("Notes", text: $notes, prompt: Text("Type something…"))
                    .focused($focusedField, equals: .notes)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Keyboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }
}

#Preview {
    NavigationStack {
        KeyboardDemoView()
    }
}
