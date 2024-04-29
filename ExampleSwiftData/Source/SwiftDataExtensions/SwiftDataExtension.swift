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
}

// MARK: - Fetch

extension PersistentModel {
  
  static func fetchObjects(predicate: Predicate<Self>? = nil,
                           sort: [SortDescriptor<Self>] = [],
                           context: ModelContext = fetchContext) -> [Self] {
    let fetch = FetchDescriptor(predicate: predicate, sortBy: sort)
    
    return (try? context.fetch(fetch)) ?? []
  }
  
  static func fetchFirstObject(predicate: Predicate<Self>? = nil, sort: [SortDescriptor<Self>] = []) -> Self? {
    fetchObjects(predicate: predicate, sort: sort).first
  }
}

// MARK: -

extension PersistentModel {
  
  static var fetchContext: ModelContext {
    ModelContext(ContainerManager.shared.container)
  }
}

@Model
class User {
  
  var title: String
  
  init(title: String) {
    self.title = title
  }
}

final class ContainerManager {
  
  static let shared = ContainerManager()
  
  var container: ModelContainer
  
  private init() {
    
    do {
      let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
      let config = ModelConfiguration(url: storeURL)
      
      container = try ModelContainer(for: User.self, configurations: config)
    } catch {
      fatalError("Failed to configure SwiftData container.")
    }
  }
}
