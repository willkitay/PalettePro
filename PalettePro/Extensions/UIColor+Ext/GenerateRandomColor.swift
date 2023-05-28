//
//  GenerateRandomColor.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIColor {
  static func generateRandomColor() -> UIColor {
    return UIColor(
      red: CGFloat.random(in: 0...1),
      green: CGFloat.random(in: 0...1),
      blue: CGFloat.random(in: 0...1),
      alpha: 1.0)
  }
}
