//
//  ColorStack.swift
//  PalettePro
//
//  Created by Will Kitay on 5/22/23.
//

import Foundation

class ColorStack {
  
  private var array: [[(String, Bool)]] = []
  private(set) var currentIndex = 0
  
  var minIndex: Int { 0 }
  var maxIndex: Int { array.count - 1 }
  
  var currentColors: [(String, Bool)] { array[currentIndex] }
  
  var canIncrement: Bool { currentIndex < array.count - 1 }
  var canDecrement: Bool { currentIndex > 0 }
  
  func increment() { currentIndex += 1 }
  func decrement() { currentIndex -= 1 }
  
  func moveToTop() {
    currentIndex = array.count - 1
  }
  
  func push(_ element: [(String, Bool)]) {
    array.append(element)
  }
  
  func addColor(_ element: [(String, Bool)]) {
    array[currentIndex].append(contentsOf: element)
  }
  
  func removeColor(at index: Int) {
    array[currentIndex].remove(at: index)
  }
  
  func set(hex: String, at index: Int) {
    array[currentIndex][index].0 = hex
  }
  
  func set(lockState: Bool, at index: Int) {
    array[currentIndex][index].1 = lockState
  }
  
}
