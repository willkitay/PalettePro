//
//  Adjust.swift
//  PalettePro
//
//  Created by Will Kitay on 5/27/23.
//

import UIKit

extension UIColor {
  func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: abs(percentage) )
  }
  
  func darker(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: -1 * abs(percentage) )
  }
  
  func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
    guard let components = cgColor.components, components.count >= 3 else {
      return nil
    }
    
    var r = components[0]
    var g = components[1]
    var b = components[2]
    let a = components[3]
    
    // Calculate the adjusted color components
    r = min(max(r + (percentage / 100.0), 0.0), 1.0)
    g = min(max(g + (percentage / 100.0), 0.0), 1.0)
    b = min(max(b + (percentage / 100.0), 0.0), 1.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
