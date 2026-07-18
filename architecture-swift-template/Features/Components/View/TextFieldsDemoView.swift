//
//  TextFieldsDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct TextFieldsDemoView: View {

    @State private var username = ""
    @State private var password = ""
    @State private var bio = ""

    private var usernameIsValid: Bool {
        username.isEmpty || username.count >= 3
    }

    var body: some View {
        Form {
            Section("Standard") {
                TextField("Username", text: $username, prompt: Text("At least 3 characters"))
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if !usernameIsValid {
                    Label("Username is too short", systemImage: "exclamationmark.triangle")
                        .typography(.caption)
                        .foregroundStyle(.red)
                }
            }

            Section("Secure") {
                SecureField("Password", text: $password, prompt: Text("Required"))
                    .textContentType(.newPassword)
            }

            Section("Multiline") {
                TextEditor(text: $bio)
                    .frame(minHeight: 120)
                    .overlay(alignment: .topLeading) {
                        if bio.isEmpty {
                            Text("Tell us about yourself…")
                                .foregroundStyle(.tertiary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                                .allowsHitTesting(false)
                        }
                    }
            }
        }
        .navigationTitle("Text Fields")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TextFieldsDemoView()
    }
}
