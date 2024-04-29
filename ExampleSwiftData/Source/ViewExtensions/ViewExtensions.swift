//
//  ViewExtensions.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 28/04/24.
//

import SwiftUI

extension View {
  
  @ViewBuilder
  func isEnabled<Content: View>(_ show: Bool = true, @ViewBuilder _ content: (Self) -> Content) -> some View {
    if show {
      content(self)
    } else {
      self
    }
  }
}
