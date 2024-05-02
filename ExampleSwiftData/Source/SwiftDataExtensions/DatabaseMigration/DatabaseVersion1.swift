//
//  DatabaseVersion1.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 01/05/24.
//

import Foundation
import SwiftData

// MARK: - VersionedSchema

enum DatabaseVersion1: VersionedSchema {
  
  static var versionIdentifier: Schema.Version = .init(1, 0, 1)
  
  static var models: [any PersistentModel.Type] {
    [User.self]
  }
}

// MARK: - User

@Model
class User {
  
  var title: String
  
  init(title: String) {
    self.title = title
  }
}
