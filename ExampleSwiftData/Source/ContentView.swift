//
//  ContentView.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 28/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @SwiftUI.Environment(\.modelContext) private var modelContext
  
  @Query(sort: \User.title) private var records: [User]
  
  var body: some View {
    List(records) { user in
      Text("User \(user.title)")
        .swipeActions(edge: .trailing) { delete(user) }
    }
    .safeAreaInset(edge: .bottom, content: addButton)
  }
  
  private func addButton() -> some View {
    Button("Add") {
      let user = User(title: "New User \(Int.random(in: 0...20))")
      modelContext.insert(user)
      modelContext.saveContext()
    }
  }
  
  private func delete(_ user: User) -> some View {
    Button(role: .destructive) {
      modelContext.deleteAndSave(user)
    } label: {
      Image(systemName: "trash")
    }
  }
}

// MARK: - Preview

#Preview {
  ContentView()
//  .modelContainer(for: User.self, inMemory: true)
    .modelContainer(.preview(for: [User(title: "Hello")]))
}
