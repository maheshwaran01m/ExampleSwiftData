//
//  DatabaseMigrationPlan.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 01/05/24.
//

import Foundation
import SwiftData

enum DatabaseMigrationPlan: SchemaMigrationPlan {
  
  static var schemas: [any VersionedSchema.Type] {
    [DatabaseVersion1.self]
  }
  
  static var stages: [MigrationStage] {
    [migrateV1ToV2]
  }
  
  static let migrateV1ToV2 = MigrationStage.custom(
    fromVersion: DatabaseVersion1.self,
    toVersion: DatabaseVersion1.self) { context in
      
      let users = try context.fetch(FetchDescriptor<User>())
      
      users
        .filter { $0.title.isEmpty }
        .forEach { context.delete($0) }
      
      context.saveContext()
      
    } didMigrate: { context in
      
      context.saveContext()
    }
}
