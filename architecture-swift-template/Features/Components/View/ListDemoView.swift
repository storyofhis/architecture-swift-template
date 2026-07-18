//
//  ListDemoView.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

struct ListDemoView: View {

    private struct Task: Identifiable, Hashable {
        let id = UUID()
        var title: String
        var isDone: Bool = false
    }

    @State private var tasks: [Task] = [
        Task(title: "Design onboarding flow"),
        Task(title: "Review pull requests"),
        Task(title: "Write release notes"),
        Task(title: "Update dependencies"),
        Task(title: "Plan sprint retro")
    ]
    @State private var selection = Set<Task.ID>()
    @State private var editMode: EditMode = .inactive

    var body: some View {
        List(selection: $selection) {
            Section("Tasks") {
                ForEach(tasks) { task in
                    Label {
                        Text(task.title)
                            .strikethrough(task.isDone)
                            .foregroundStyle(task.isDone ? .secondary : .primary)
                    } icon: {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isDone ? .green : .secondary)
                    }
                    .swipeActions(edge: .leading) {
                        Button(task.isDone ? "Undo" : "Done", systemImage: "checkmark") {
                            toggle(task)
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            delete(task)
                        }
                    }
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
                .onMove { source, destination in
                    tasks.move(fromOffsets: source, toOffset: destination)
                }
            }
        }
        .environment(\.editMode, $editMode)
        .navigationTitle("List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
    }

    private func toggle(_ task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
    }

    private func delete(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}

#Preview {
    NavigationStack {
        ListDemoView()
    }
}
