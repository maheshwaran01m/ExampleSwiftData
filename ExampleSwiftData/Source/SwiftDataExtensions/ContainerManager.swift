//
//  ContainerManager.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 01/05/24.
//

import Foundation
import SwiftData

final class ContainerManager {
  
  static let shared = ContainerManager()
  
  private(set) public var container: ModelContainer
  
  private init() {
    
    do {
      let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
      let config = ModelConfiguration(url: storeURL)
      
      container = try ModelContainer(for: User.self, configurations: config)
    } catch {
      fatalError("Failed to configure SwiftData container.")
    }
  }
  
  // MARK: - Schema
  
  private var defaultContainer: ModelContainer {
    
    let schema = Schema([User.self])
    do {
      return try ModelContainer(for: schema, configurations: [])
    } catch {
      fatalError("Failed to configure Model Container!")
    }
  }
  
  // MARK: - Migration
  
  private var defaultMigrationPlan: ModelContainer {
    let schema = Schema([User.self])
    do {
      return try ModelContainer(for: schema, migrationPlan: DatabaseMigrationPlan.self, configurations: [])
    } catch {
      fatalError("Failed to configure Model Container!")
    }
  }
}

// MARK: - ModelContext

extension ModelContext {
  
  static var defaultContext: ModelContext {
    ModelContext(ContainerManager.shared.container)
  }
}
