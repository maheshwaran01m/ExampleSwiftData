//
//  SwiftDataExtension.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 28/04/24.
//

import Foundation
import SwiftData

extension ModelContext {
  
  // MARK: - Save
  
  func saveContext() {
    try? save()
  }
  
  // MARK: - Delete
  
  func deleteAndSave<T: PersistentModel>(_ model: T) {
    delete(model)
    saveContext()
  }
  
  func insert<T: PersistentModel>(contentOf values: [T]) {
    values.forEach { insert($0) }
  }
}

// MARK: - Fetch

extension PersistentModel {
  
  static func fetchObjects(predicate: Predicate<Self>? = nil,
                           sort: [SortDescriptor<Self>] = [],
                           context: ModelContext = .defaultContext) -> [Self] {
    let fetch = FetchDescriptor(predicate: predicate, sortBy: sort)
    
    return (try? context.fetch(fetch)) ?? []
  }
  
  static func fetchFirstObject(predicate: Predicate<Self>? = nil, sort: [SortDescriptor<Self>] = []) -> Self? {
    fetchObjects(predicate: predicate, sort: sort).first
  }
}

// MARK: - Preview ModelContainer

extension ModelContainer {
  
  /// This method mostly used in Preview to display list of items
  ///
  ///  Example Usage:
  ///
  ///       #Preview {
  ///          ContentView()
  ///           .modelContainer(.preview(for: [User(title: "Hello")] ))
  ///        }
  ///
  ///      (or)
  ///
  ///        #Preview {
  ///            let container = ModelContainer.preview(for: [User(title: "Hello")])
  ///
  ///           return DetailView(user: User(title: "Hello"))
  ///                   .modelContainer(container)
  ///         }
  ///
  ///
  /// - Parameter values: Gets a list of persitentModel items
  /// - Returns: Returns a Model Container
  ///
  static func preview<T: PersistentModel>(for values: @autoclosure @escaping () -> [T]) -> ModelContainer {
    
    let schema = Schema([T.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: schema, configurations: [config])
    
    Task { @MainActor in
      container.mainContext.insert(contentOf: values())
    }
    return container
  }
}
