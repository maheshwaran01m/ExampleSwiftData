//
//  ExampleSwiftDataApp.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 28/04/24.
//

import SwiftUI
import SwiftData

@main
struct ExampleSwiftDataApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear { print("Path: \(URL.documentsDirectory.path())")}
    }
    .modelContainer(ContainerManager.shared.container)
  }
}
