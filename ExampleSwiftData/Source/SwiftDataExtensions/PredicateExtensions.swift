//
//  PredicateExtensions.swift
//  ExampleSwiftData
//
//  Created by MAHESHWARAN on 28/04/24.
//

import Foundation
import SwiftData

/// `Predicate Extensions`
///
///  Example Usage:
///
///       @Model
///       class User {
///
///        var title: String
///
///         init(title: String) {
///           self.title = title
///         }
///       }
///
///      let abc = \User.title == ""
///
/// - Returns: Returns a Predicate<T>

// MARK: - Comparison operators

public func == <T: Equatable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Equal(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs))
  }
}

public func != <T: Equatable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_NotEqual(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs))
  }
}

public func < <T: Comparable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Comparison(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs),
      op: .lessThan)
  }
}

public func <= <T: Comparable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Comparison(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs),
      op: .lessThanOrEqual)
  }
}

public func > <T: Comparable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Comparison(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs),
      op: .greaterThan)
  }
}

public func >= <T: Comparable, E>(lhs: KeyPath<E, T>, rhs: T) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Comparison(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs),
      op: .greaterThanOrEqual)
  }
}

// MARK: Optional

public func == <T: Equatable, E>(lhs: KeyPath<E, T?>, rhs: T?) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_Equal(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs))
  }
}

public func != <T: Equatable, E>(lhs: KeyPath<E, T?>, rhs: T?) -> Predicate<E> where T: Codable {
  Predicate<E> {
    PredicateExpressions.build_NotEqual(
      lhs: PredicateExpressions.build_KeyPath(root: PredicateExpressions.build_Arg($0), keyPath: lhs),
      rhs: PredicateExpressions.build_Arg(rhs))
  }
}



// MARK: - Compound operators

public prefix func ! <T: PersistentModel>(value: KeyPath<T, Bool>) -> Predicate<T> {
  value == false
}

public func && <T>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> where T: Codable {
  
//  if #available(iOS 17.4, macOS 14.4, *) {
//    
//    return #Predicate<T> { lhs.evaluate($0) && rhs.evaluate($0) }
//  } else {
    
    func conjuction(lhs: some StandardPredicateExpression<Bool>,
                    rhs: some StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> {
      PredicateExpressions.build_Conjunction(lhs: lhs, rhs: rhs)
    }
    
    return Predicate<T> { variable in
      
      let expression = [lhs, rhs].map {
        VariableExpression(predicate: $0, variable: variable)
      }
      guard let first = expression.first else { return PredicateExpressions.Value(true) }
      
      let closure = { (lhs: any StandardPredicateExpression<Bool>,
                       rhs: any StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> in
        
        conjuction(lhs: lhs, rhs: rhs)
      }
      return expression.dropFirst().reduce(first, closure)
    }
//  }
}

public func || <T: PersistentModel>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> where T: Codable {
  
//  if #available(iOS 17.4, macOS 14.4, *) {
//    return #Predicate<T> { lhs.evaluate($0) || rhs.evaluate($0) }
//    
//  } else {
    
    func disjunction(lhs: some StandardPredicateExpression<Bool>,
                     rhs: some StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> {
      PredicateExpressions.build_Conjunction(lhs: lhs, rhs: rhs)
    }
    return Predicate<T> { variable in
      
      let expression = [lhs, rhs].map {
        VariableExpression(predicate: $0, variable: variable)
      }
      guard let first = expression.first else { return PredicateExpressions.Value(true) }
      
      let closure = { (lhs: any StandardPredicateExpression<Bool>,
                       rhs: any StandardPredicateExpression<Bool>) -> any StandardPredicateExpression<Bool> in
        disjunction(lhs: lhs, rhs: rhs)
      }
      return expression.dropFirst().reduce(first, closure)
    }
//  }
}

// MARK: - Internal

fileprivate struct VariableExpression<T>: StandardPredicateExpression {
  
  let predicate: Predicate<T>
  
  let variable: PredicateExpressions.Variable<T>
  
  public func evaluate(_ bindings: PredicateBindings) throws -> Bool {
    
    let value = try variable.evaluate(bindings)
    
    let variable = predicate.variable
    
    let newBindings = bindings.binding(variable, to: value)
    
    return try predicate.expression.evaluate(newBindings)
  }
}
