//
//  Stack.swift
//  PalettePro
//
//  Created by Will Kitay on 5/22/23.
//

import Foundation

struct Stack {
  
  var array: [[(String, Bool)]] = []
  var currentIndex = 0
  
  mutating func push(_ element: [(String, Bool)]) {
    array.append(element)
  }
  
  mutating func updateColorCount(_ element: [(String, Bool)]) {
    array[currentIndex].append(contentsOf: element)
  }
  
  func currentColors() -> [(String, Bool)] {
    return array[currentIndex]
  }
  
  mutating func decrement() {
    if currentIndex > 0 {
      currentIndex -= 1
    }
  }
  
  mutating func increment() {
    if currentIndex < array.count - 1 {
      self.currentIndex += 1
    }
  }
}
